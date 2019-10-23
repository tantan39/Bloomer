//
//  ChatViewController.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/1/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "ChatViewController.h"
#import "AppDelegate.h"
#import "POP.h"
#import "ErrorMessageView.h"
#import "AppHelper.h"
#import "NotificationHelper.h"
#import "ChatPopupView.h"
//#import "profile_fetch_using.h"

#define FLOWER_LIMIT_VIEW_HEIGHT 30
#define STICKER_VIEW_HEIGHT 40
#define ACTIVE_SIDE_VIEW_HEIGHT 28
#define INACTIVE_SIDE_VIEW_HEIGHT 28

#define LABEL_WIDTH 210
#define LABEL_HEIGHT 28
#define STICKER_HEIGHT 80
#define CELL_HEIGHT_STICKER 90
#define CELL_HEIGHT_LEFT 38
#define CELL_HEIGHT_RIGHT 38
#define CELL_HEIGHT_FLOWER 52
#define OBJECT_WIDTH 80.0f
#define OBJECT_HEIGHT 80.0f
#define MARGIN_VERTICAL 0.0f
#define MARGIN_HORIZONTAL 0.0f
#define DRAGGABLE_LOCATION_WIDTH  ((OBJECT_WIDTH  * 3) + (MARGIN_HORIZONTAL * 5))
#define DRAGGABLE_LOCATION_HEIGHT ((OBJECT_HEIGHT * 3) + (MARGIN_VERTICAL   * 5))

#define USING_EMOJI FALSE
#define USING_STICKER TRUE
#define TEXT_VIEW_DEFAULT_HEIGHT 35
#define CHAT_VIEW_DEFAULT_HEIGHT 55

//Emoji default max size
static const CGFloat EMOJI_MAX_SIZE = 28;

@interface ChatViewController () <FlowerMenuPopupViewDelegate>
{
    UserDefaultManager* userDefaultManager;
    out_profile_fetch *profileData;
    ReportChatPopUpViewController* reportPopUp;
    NSInteger apiType;
    image_photo *imagePhotoAPI;
    FlowerMenuPostPopupViewController *flowerPopup;
    NSString* s_placeholder;
    long long nGivingflower;
    ThankYou *thankyou;
    CGRect previousTextViewPosition;
    NSInteger currentTextViewLine;
    ChatPopupView *popupView;
    out_profile_fetch *chatUser;
    
    //group by date
    NSMutableArray* tableViewSections;
    NSMutableDictionary* tableViewCells;
    BOOL isLoadMore;
    ChatStatus * chatStatus;
}

//Emoji Keyboard
//@property (strong, nonatomic) NSMutableArray *emojiTags;
//@property (strong, nonatomic) NSMutableArray *emojiImages;

@property (strong, nonatomic) SEDraggableLocation *homeDraggableLocation;
@property (strong, nonatomic) SEDraggable *buttonDraggable;
@property (strong, nonatomic) UIImageView *imageButtonDraggable;
@property (assign, nonatomic) BOOL isBlock;
@property (assign, nonatomic) BOOL isBlocked;

@end

@implementation ChatViewController
@synthesize circularMenu, emojiKeyboard;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    userDefaultManager = [[UserDefaultManager alloc] init];

    profileData = [userDefaultManager getUserProfileData];
    
    self.listDraggableLocation = [[NSMutableArray alloc] init];
    imagePhotoAPI = [[image_photo alloc] init];
    self.messages = [[NSMutableArray alloc] init];
    self.pendingMessages = [[NSMutableArray alloc] init];
    apiType = -1;
    currentTextViewLine = 1;

    reportPopUp = [[ReportChatPopUpViewController alloc] initWithNibName:@"ReportChatPopUpViewController" bundle:nil];
    reportPopUp.uid = self.uid;
    
    //setup giving flower button
    [self initTabbar];
    [self initNavigationBar];
    
    [self configureDraggableLocation:self.draggableLocation makeCircle:FALSE];
    self.draggableLocation.delegate = self;
    [self.buttonDraggable addAllowedDropLocation:self.draggableLocation];

    self.flowerChatLimitViewHeight.constant = 0;
    self.chatBoxView.layer.cornerRadius = self.chatBoxView.frame.size.height / 2;
    self.chatBoxView.clipsToBounds = true;
    
    
    chatStatus = [[ChatStatus alloc] init];
    SocketManager * socketManager = [SocketManager shareInstance];
    
    __weak typeof(self) weakSelf = self;
    
    __weak typeof(SocketManager *) weakSocketManager = socketManager;

    self.roomID = self.roomID ? self.roomID : @"";
    [self loadPreviousMessageWitnSenderID:profileData.uid ReceiverID:_uid RoomID:self.roomID MessageID:@""];
    
    [socketManager setOnHistoryMessages:^(ChatStatus *status, NSMutableArray *data,NSString * roomID, NSInteger remain_flower) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name: [NotificationNames AuthenSuccess] object:nil];
        if (status.block == 0) {
            // do this
            if (remain_flower == 0) {
                weakSelf.flowerChatLimitViewHeight.constant = 0;
                weakSelf.labelTitleEmptyView.hidden = false;
                weakSelf.chatView.hidden = false;
                weakSelf.stickerView.hidden = false;
                
                weakSelf.roomID = roomID;
                [weakSelf handlePreviousMessages:data];
            }else{
                weakSelf.flowerChatLimitViewHeight.constant = FLOWER_LIMIT_VIEW_HEIGHT;
                weakSelf.labelTitleEmptyView.hidden = YES;
                weakSelf.chatView.hidden = YES;
                weakSelf.stickerView.hidden = YES;
                [weakSelf.labelTitleFlowerChatLimitView setText:[NSString stringWithFormat:NSLocalizedString(@"chat.remainflower", nil), remain_flower]];
            }

        }else{
            [weakSelf checkBlockStateWithStatus:status];
            weakSelf.roomID = roomID;
            [weakSelf handlePreviousMessages:data];
        }
    }];
    
    [socketManager setOnMessageReceive:^(message* data) {
        message * newMessage = (message *) data;
        if ([newMessage.room_id isEqualToString:self.roomID]) {
            
            [self.emptyView setHidden:YES];
             [self.chatTableView setHidden:NO];
            
            [_messages insertObject:newMessage atIndex:0];
            [weakSelf setupDataSource:_messages];
            [weakSelf scrollViewScrollToBottom];
        }
        [weakSocketManager seenMessageWithID:profileData.uid SenderID:self.uid RoomID:self.roomID mID:newMessage.message_id];
        
        if ([self.delegate respondsToSelector:@selector(chatViewController_UpdateListMessageWith:)]) {
            [self.delegate chatViewController_UpdateListMessageWith:newMessage];
        }
        
    }];
    
    [socketManager setIsConnectedResponse:^(NSError * error) {
        if (!error) {
            NSMutableArray * temp = [weakSelf.pendingMessages mutableCopy];
            for (message * msg in temp) {
                [[SocketManager shareInstance] sendMessageWithSenderID:msg.sender_id ReceiverID:_uid Content:msg.body Resource:msg.resource];
                [weakSelf.pendingMessages removeObject:msg];
            }
        }else{
            [TTMessageView showMessageUnderNavBar:self Message:[AppHelper getLocalizedString:@"Socket.Error"]];
        }
    }];
    
    [socketManager setOnBlockEventResponse:^(ChatStatus * status) {
        if (status.block == 2) { //Blocked
            chatStatus = status;
            [self checkBlockStateWithStatus:chatStatus];
            
            if (circularMenu != nil){
                [circularMenu removeFromSuperview];
            }
        }
    }];
    
    [socketManager setOnUnBlockEventResponse:^(BOOL status) {
        if (status) {
            chatStatus.block = 0;
            [self checkBlockStateWithStatus:chatStatus];
        }
    }];
    
    s_placeholder = [AppHelper getLocalizedString:@"Chat.typeAMessage"];
    [self.chatTextView setText:s_placeholder];
    
    [self.emojiKeyboard initEmojiKeyBoardImage:self.tabContentView animatedLine:self.animatedLine animatedLineLeftMargin:self.animatedLineLeftMargin];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authenSusscess) name:[NotificationNames AuthenSuccess] object:nil];
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupLanguage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(switchStickerKeyboard:)
                                                 name:[NotificationNames SwitchStickerKeyboard]
                                               object:nil];
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.badgeNumber removeFromSuperview];
    
    for (SEDraggableLocation *location in self.listDraggableLocation)
    {
        [self.tabbar.draggableButton addAllowedDropLocation:location];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tabbar updateFlowerValue];
    //[self clearDraggableLocationList];
    
    nGivingflower = 0;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:[NotificationNames SwitchStickerKeyboard]
                                                  object:nil];
    
    // reset frame of Tabbar-flower
    [self.tabbar setFrame:CGRectMake(135, -13, 50, 63)];
    [self.tabBarController.tabBar addSubview:self.tabbar];
    
    if (circularMenu != nil) {
        [circularMenu removeFromSuperview];
    }
    
    for (SEDraggableLocation *location in self.listDraggableLocation)
    {
        [self.tabbar.draggableButton removeAllowedDropLocation:location];
    }
    
    [self.tabbar.draggableButton removeAllowedDropLocation:self.draggableLocation];
}

- (void)setupLanguage
{
    self.labelTitleEmptyView.text = [AppHelper getLocalizedString:@"Chat.labelTitleEmptyView"];
    self.labelDescriptionEmptyView.text = [AppHelper getLocalizedString:@"Chat.labelDescriptionEmptyView"];
    self.labelTitleActiveSideView.text = [AppHelper getLocalizedString:@"Chat.labelTitleActiveSideView"];
//    self.labelTitleInactiveSideView.text = [AppHelper getLocalizedString:@"Chat.labelTitleInactiveSideView"];
}

- (void)clearDraggableLocationList
{
    if (self.listDraggableLocation.count != 0)
    {
        for (int i = 0; i < self.listDraggableLocation.count; i++)
        {
            [self.tabbar.draggableButton removeAllowedDropLocation:[self.listDraggableLocation objectAtIndex:i]];
        }
    }
}

- (void)initNavigationBar
{
    UIBarButtonItem *reportButton;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7"))
    {
        reportButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Button_Report_Normal.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(touchReportButton)];
    } else {
        reportButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Button_Report_Normal.png"]
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(touchReportButton)];
    }
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:reportButton, nil]];
    
    [AppHelper setTitleViewForNavigationBar:self.navigationItem title:self.screen_name];
    
    UIBarButtonItem *buttonMore = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Icon_More_White"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(touchButtonMore)];
    self.navigationItem.rightBarButtonItem = buttonMore;
}

- (void)initTabbar
{
    self.homeDraggableLocation = [[SEDraggableLocation alloc] initWithFrame:self.buttonFlowerStatic.frame];
    self.homeDraggableLocation.translatesAutoresizingMaskIntoConstraints = false;
    self.homeDraggableLocation.delegate = self;
    [self.chatView addSubview:self.homeDraggableLocation];
    
    [AppHelper configureDraggableLocation:self.homeDraggableLocation objectSize:self.buttonFlowerStatic.frame.size];
    
    self.imageButtonDraggable = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon_Flower_TabBar"] highlightedImage:[UIImage imageNamed:@"Icon_Giving_Flower"]];
    self.buttonDraggable = [[SEDraggable alloc] initWithImageView:self.imageButtonDraggable];
    self.buttonDraggable.delegate = self;
    
    [self setupConstraintsForDraggableButton:self.homeDraggableLocation];
    
    [AppHelper configureDraggableObject:self.buttonDraggable draggableLocation:self.homeDraggableLocation];
    
    [self.chatView setExclusiveTouch:TRUE];
}

- (void)animateLine:(CGFloat)x
{
    self.animatedLineLeftMargin.constant = x;
    
    [UIView animateWithDuration:0.15 animations:^{
        [self.animatedLine layoutIfNeeded];
        [self.stickerView layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (void)setupConstraintsForDraggableButton:(UIView*)view
{
    NSLayoutConstraint *topMargin = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.buttonFlowerStatic attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *leftMargin = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.buttonFlowerStatic attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *rightMargin = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.buttonFlowerStatic attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint *bottomMargin = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.buttonFlowerStatic attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    [self.chatView addConstraints:@[topMargin, leftMargin, rightMargin, bottomMargin]];
}

- (void) authenSusscess {
    [self loadPreviousMessageWitnSenderID:profileData.uid ReceiverID:_uid RoomID:self.roomID MessageID:@""];
}

- (void)checkBlockStateWithStatus:(ChatStatus *) status
{
    chatStatus = status;
    if (status.block == 1 || status.block == 2) {
        [self.view endEditing:YES];
        [self.stickerView setHidden:YES];
        [self.chatView setHidden:YES];
        self.buttonFlowerStatic.hidden = true;
        self.buttonDraggable.hidden = true;
        self.activeSideViewHeight.constant = ACTIVE_SIDE_VIEW_HEIGHT;
        self.labelTitleActiveSideView.text = status.msg;
        
        self.stickerViewHeight.constant = 0;
        self.chatViewHeight.constant = 0 ;
        [self.view layoutIfNeeded];
        
    }else if (status.block == 0){
        
        [self.stickerView setHidden:NO];
        [self.chatView setHidden:NO];
        self.buttonFlowerStatic.hidden = NO;
        self.buttonDraggable.hidden = NO;
        self.activeSideViewHeight.constant = 0;
        
        self.stickerViewHeight.constant = STICKER_VIEW_HEIGHT;
        self.chatViewHeight.constant = CHAT_VIEW_DEFAULT_HEIGHT ;
        [self.view layoutIfNeeded];
        
    }
    
}

#pragma mark - Giving Flowers
- (void)draggableLocation:(SEDraggableLocation *)location didRefuseObject:(SEDraggable *)object entryMethod:(SEDraggableLocationEntryMethod)method {
    [self dismissKeyBoard];
    [object setHidden:true];
    
    if (circularMenu != nil) {
        [circularMenu removeFromSuperview];
    }
    
    if (location == self.draggableLocation) {
        circularMenu = [self createCircularMenuWithFrame:self.draggableLocation.bounds];
        circularMenu.startPoint = CGPointMake(self.draggableLocation.center.x, self.draggableLocation.center.y);
        circularMenu.delegate = self;
        circularMenu.menuWholeAngle = 2.5f;
        circularMenu.farRadius = 60.0f;
        circularMenu.endRadius = 50.0f;
        circularMenu.nearRadius = 40.0f;
        circularMenu.animationDuration = 0.7f;
        circularMenu.rotateAngle = 5.04f;
        [circularMenu setExpanding:YES];
        
        [self.view addSubview:circularMenu];
    }
}

- (void)configureDraggableLocation:(SEDraggableLocation *)draggableLocation makeCircle:(BOOL)isCircle {
    // set the width and height of the objects to be contained in this SEDraggableLocation (for spacing/arrangement purposes)
    draggableLocation.objectWidth = OBJECT_WIDTH;
    draggableLocation.objectHeight = OBJECT_HEIGHT;
    
    // set the bounding margins for this location
    draggableLocation.marginLeft = MARGIN_HORIZONTAL;
    draggableLocation.marginRight = MARGIN_HORIZONTAL;
    draggableLocation.marginTop = MARGIN_VERTICAL;
    draggableLocation.marginBottom = MARGIN_VERTICAL;
    
    // set the margins that should be preserved between auto-arranged objects in this location
    draggableLocation.marginBetweenX = MARGIN_HORIZONTAL;
    draggableLocation.marginBetweenY = MARGIN_VERTICAL;
    
    // set up highlight-on-drag-over behavior
    //draggableLocation.highlightColor = [UIColor redColor].CGColor;
    if(isCircle)
        draggableLocation.layer.cornerRadius = draggableLocation.frame.size.width / 2; // VanLuu-remove #1 avatar
    draggableLocation.clipsToBounds = true;
    draggableLocation.highlightOpacity = 0.4f;
    draggableLocation.shouldHighlightOnDragOver = YES;
    draggableLocation.highlightColor = [UIColor clearColor].CGColor;
    
    // you may want to toggle this on/off when certain events occur in your app
    draggableLocation.shouldAcceptDroppedObjects = NO;
    
    // set up auto-arranging behavior
    draggableLocation.shouldKeepObjectsArranged = YES;
    draggableLocation.fillHorizontallyFirst = YES; // NO makes it fill rows first
    draggableLocation.allowRows = YES;
    draggableLocation.allowColumns = YES;
    draggableLocation.shouldAnimateObjectAdjustments = YES; // if this is set to NO, objects will simply appear instantaneously at their new positions
    draggableLocation.animationDuration = 0.5f;
    draggableLocation.animationDelay = 0.0f;
    draggableLocation.animationOptions = UIViewAnimationOptionLayoutSubviews ; // UIViewAnimationOptionBeginFromCurrentState;
    
    draggableLocation.shouldAcceptObjectsSnappingBack = YES;
}

- (AwesomeMenu *)createCircularMenuWithFrame:(CGRect)frame
{
    UIImage *backgroundImage1 = [UIImage imageNamed:@"GivingFlowers_1.png"];
    UIImage *highlightedBackgroundImage1 = [UIImage imageNamed:@"GivingFlowers_1.png"];
    UIImage *backgroundImage10 = [UIImage imageNamed:@"GivingFlowers_10.png"];
    UIImage *highlightedBackgroundImage10 = [UIImage imageNamed:@"GivingFlowers_10.png"];
    UIImage *backgroundImage100 = [UIImage imageNamed:@"GivingFlowers_100.png"];
    UIImage *highlightedBackgroundImage100 = [UIImage imageNamed:@"GivingFlowers_100.png"];
    AwesomeMenuItem *flowerButton1 = [[AwesomeMenuItem alloc]
                                      initWithImage:backgroundImage1
                                      highlightedImage:highlightedBackgroundImage1
                                      text:@(FIRST_FLOWER_BUTTON_VALUE).stringValue];
    AwesomeMenuItem *flowerButton2 = [[AwesomeMenuItem alloc]
                                      initWithImage:backgroundImage10
                                      highlightedImage:highlightedBackgroundImage10
                                      text:@(SECOND_FLOWER_BUTTON_VALUE).stringValue];
    AwesomeMenuItem *flowerButton3 = [[AwesomeMenuItem alloc]
                                      initWithImage:backgroundImage100
                                      highlightedImage:highlightedBackgroundImage100
                                      text:@(THIRD_FLOWER_BUTTON_VALUE).stringValue];
    AwesomeMenuItem *flowerButton4 = [[AwesomeMenuItem alloc]
                                      initWithImage:[UIImage imageNamed:@"GivingFlowers_....png"]
                                      highlightedImage:[UIImage imageNamed:@"GivingFlowers_....png"]
                                      text:@""];
    NSArray *menus = [NSArray arrayWithObjects:flowerButton1, flowerButton2, flowerButton3, flowerButton4, nil];
    
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"GivingFlower_Store.png"]
                                                       highlightedImage:[UIImage imageNamed:@"GivingFlower_Store.png"]
                                                                   text:@""];
    
    AwesomeMenu *resultMenu = [[AwesomeMenu alloc] initWithFrame:frame startItem:startItem optionMenus:menus isCell:FALSE];
    
    return resultMenu;
}

- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    [menu removeFromSuperview];
    
    if (idx < 3 && idx > -1)
    {
        int flower = 0;
        
        switch (idx) {
            case 0:
                flower = FIRST_FLOWER_BUTTON_VALUE;
                break;
            case 1:
                flower = SECOND_FLOWER_BUTTON_VALUE;
                break;
            case 2:
                flower = THIRD_FLOWER_BUTTON_VALUE;
                break;
        }
        
        [self giveFlower:flower];
    }
    else
    {
        if (idx == 3) {
            flowerPopup = [[FlowerMenuPostPopupViewController alloc] initWithNibName:@"FlowerMenuPopUpViewController" bundle:nil];
            
            flowerPopup.uid = self.uid;
            flowerPopup.parentView = self;
            flowerPopup.isFirstRank = FALSE;
            flowerPopup.delegate = self;
            [flowerPopup showInView:[[[UIApplication sharedApplication] delegate] window] animated:TRUE];
        } else if (idx == 4 || idx == -1) {
            FlowerGardenViewController *view = [[FlowerGardenViewController alloc] initWithNibName:@"FlowerGardenViewController" bundle:nil];
            [self.tabbar snapbackFlowerIconToTabbar];
            view.hidesBottomBarWhenPushed = TRUE;
            [self.navigationController pushViewController:view animated:TRUE];
        }
    }
    
    [self createThankYouView];
}

// MARK: - SEDraggableDelegate

- (void)draggableObject:(SEDraggable *)object finishedEnteringLocation:(SEDraggableLocation *)location withEntryMethod:(SEDraggableLocationEntryMethod)entryMethod
{
    [object setHidden:false];
    
    if (entryMethod == SEDraggableLocationEntryMethodWantsToSnapBack)
    {
        [self.imageButtonDraggable setImage:[UIImage imageNamed:@"Icon_Flower_TabBar"]];
        [self.imageButtonDraggable setHidden:FALSE];
    }
}

- (void) draggableObjectDidMove:(SEDraggable *)object
{
    [self.imageButtonDraggable setImage:[UIImage imageNamed:@"Icon_Giving_Flowers"]];
}

#pragma mark - Giving Flower - Thank You popup

- (void)createThankYouView
{
    [self removeThankYou];
    CGPoint targetPoint = CGPointMake(self.draggableLocation.frame.size.width/3, -48);
    //    CGRect frameInRootView = [receivedLocation convertRect:receivedLocation.bounds toView:_galleryTableView];
    if (thankyou != nil) {
        [thankyou repositionToPoint:targetPoint];
    } else {
        thankyou = [[ThankYou alloc] initWithStyle:ThankYouStyleForTopBloomerProfile atPoint:targetPoint frame:self.draggableLocation.frame];
    }
}

- (void)ShowThankYouPopup
{
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:[WeakLinkObj weakObjectWithRealTarget:self] selector:@selector(removeThankYou) userInfo:nil repeats:NO];
    [self.view addSubview:thankyou];
}

- (void)removeThankYou
{
    if(thankyou != nil) {
        [thankyou removeFromSuperview];
    }
}

- (void)didEndEditing:(NSInteger)nFlower isCanel:(BOOL)isCanel
{
    if(!isCanel) {
        [self giveFlower:nFlower];
    }
    [self dismissKeyBoard];
}

- (void)giveFlower:(long long)flower {
    nGivingflower = flower;
    flower_give_profile *param = [[flower_give_profile alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                                     device_token:[userDefaultManager getDeviceToken]
                                                                       num_flower:flower
                                                                         receiver:self.uid];
    if (param) {
        API_Flower_GiveProfile *flowerGiveProfileAPI = [[API_Flower_GiveProfile alloc] initWithParams:param];
        __weak typeof(self) weakSelf = self;
        [flowerGiveProfileAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            out_flower_give * data = (out_flower_give *)jsonObject;
            if (weakSelf) {
                
                if (response.status) {
                    [userDefaultManager didTutorialGiveFlowerRace:TRUE];
                    [weakSelf processAfterGivingFlower:data];
                    [data showFlowerGivingPopupIn:[UIApplication sharedApplication].keyWindow];
                    NSTimeInterval timestamp = [NSDate timeIntervalSinceReferenceDate];
                    
                    NSString *sflowerNumber = [NSString stringWithFormat:@"%lld", data.numGiveFlower];
                    
                    message *mess = [[message alloc] init];
                    mess.responseID = [NSString stringWithFormat:@"%f",timestamp];
                    mess.timestamp = [[NSDate date] timeIntervalSince1970]*1000.0;
                    mess.sent = 0;
                    mess.sender_id = profileData.uid;
                    mess.body = sflowerNumber;
                    mess.resource = RES_TYPE_GIVE_FLOWER;
                    
                    [_messages insertObject:mess atIndex:0];
                    [self setupDataSource:_messages];
                    
                    [self scrollViewScrollToBottom];
                    
                    
                    if ([[SocketManager shareInstance] IsConnected]) {
                        [[SocketManager shareInstance] sendMessageWithSenderID:mess.sender_id ReceiverID:_uid Content:mess.body Resource:mess.resource];
                    }else{
                        [self.pendingMessages addObject:mess];
                    }
                    
                    
                    [weakSelf.emptyView setHidden:TRUE];
                    [weakSelf.chatTableView setHidden:FALSE];
                    [weakSelf.view reloadInputViews];
                
                    
                    [weakSelf ShowThankYouPopup];
                } else {
                    [AppHelper showMessageUnderNavBar:self message:response.message timer:YES];
                }
                
                nGivingflower = 0;
            }

        } ErrorHandlure:^(NSError *error) {
            
        }];
    }

}


//group message by date
- (void) setupDataSource:(NSMutableArray*)sortedDateArray
{
    NSSortDescriptor *sortDescriptor;
     NSArray *sortDescriptors;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
    sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    sortedDateArray = [[sortedDateArray sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    
    tableViewSections = [NSMutableArray arrayWithCapacity:0];
    tableViewCells = [NSMutableDictionary dictionaryWithCapacity:0];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init] ;
    dateFormatter.locale = [NSLocale currentLocale];
    dateFormatter.timeZone =  [NSTimeZone timeZoneWithName:@"GMT+7"];;//calendar.timeZone;
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSUInteger dateComponents = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSInteger previousYear = -1;
    NSInteger previousMonth = -1;
    NSInteger previousDay = -1;
    NSMutableArray* tableViewCellsForSection = nil;
    for (message* mess in sortedDateArray)
    {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:mess.timestamp/1000.0];
        NSDateComponents* components = [calendar components:dateComponents fromDate:date];
        NSInteger year = [components year];
        NSInteger month = [components month];
        NSInteger day = [components day];
        if (year != previousYear || month != previousMonth || day!= previousDay)
        {
            NSString* sectionHeading = [dateFormatter stringFromDate:date];
            [tableViewSections addObject:sectionHeading];
            tableViewCellsForSection = [NSMutableArray arrayWithCapacity:0];
            [tableViewCells setObject:tableViewCellsForSection forKey:sectionHeading];
            previousYear = year;
            previousMonth = month;
            previousDay = day;
        }
        
        [tableViewCellsForSection addObject:mess];
    }
    [self.chatTableView reloadData];
}
/*

-(void) initStickerList
{
    stickerList = [[NSMutableDictionary alloc] init];
    //100190_k
    int emojiID=0;
    int emojiCollectionID=4;
    for (int i = 1; i < 25; i++) {
        
        [stickerList setValue:[NSString stringWithFormat:@"1001%i%i_k",emojiCollectionID, emojiID] forKey: [NSString stringWithFormat:@"[%i]",i] ];
        emojiID++;
        if(emojiID > 9)
        {
            emojiCollectionID++;
            emojiID=0;
        }
    }
}
*/


- (void) loadPreviousMessageWitnSenderID:(NSInteger) senderID ReceiverID:(NSInteger) receiverID RoomID:(NSString *) roomID MessageID:(NSString *) msgID{
    [[SocketManager shareInstance] getMessageHistoryWithSenderID:senderID ReceiverID:receiverID RoomID:roomID mID:msgID];
}

- (void)sendMessage:(NSString*) content
{
    if (content != nil && ![content isEqualToString:@""])
    {
        NSTimeInterval timestamp = [NSDate timeIntervalSinceReferenceDate];
        
        [_emptyView setHidden:TRUE];
        [_chatTableView setHidden:FALSE];
        [self.view reloadInputViews];
        
        message *mess = [[message alloc] init];
        mess.room_id = self.roomID;
        mess.responseID = [NSString stringWithFormat:@"%f",timestamp];
        mess.timestamp = [[NSDate date] timeIntervalSince1970]*1000.0;
        mess.sent = 1;
        mess.sender_id = profileData.uid;
        mess.body = content;
        if([emojiKeyboard.stickerList objectForKey:mess.body])
            mess.resource = RES_TYPE_STICKER;
        
        __weak typeof(self) weakSelf = self;
        [[SocketManager shareInstance] setOnMessageSendResponse:^(ChatStatus *status, BOOL send) {
            if (send) {
                [_messages insertObject:mess atIndex:0];
                [weakSelf setupDataSource:_messages];
                [weakSelf scrollViewScrollToBottom];
            }else{
                chatStatus = status;
                [weakSelf checkBlockStateWithStatus:status];
            }
            if ([self.delegate respondsToSelector:@selector(chatViewController_UpdateListMessageWith:)]) {
                [self.delegate chatViewController_UpdateListMessageWith:mess];
            }
 
        }];
        
        if ([[SocketManager shareInstance] IsConnected]) {
            [[SocketManager shareInstance] sendMessageWithSenderID:mess.sender_id ReceiverID:_uid Content:mess.body Resource:mess.resource];
        }else{
            [self.pendingMessages addObject:mess];
        }

        // clear content of chat input
        self.chatTextView.text = @"";
        self.chatViewHeight.constant = CHAT_VIEW_DEFAULT_HEIGHT;
        
        for (UIImageView *view in [self.chatTextView subviews])
        {
            if([NSStringFromClass([view class]) isEqualToString:@"_UITextContainerView"])
                continue;
            [view removeFromSuperview];
        }
    }
}

- (void) handlePreviousMessages:(NSMutableArray *) messages{

    // update resource type for message
    for (int i = 0; i < messages.count; i++)
    {
        if (((message*)[messages objectAtIndex:i]).resource == RES_TYPE_TEXT)
        {
            if ([emojiKeyboard.stickerList objectForKey:((message*)[messages objectAtIndex:i]).body])
                ((message*)[messages objectAtIndex:i]).resource = RES_TYPE_STICKER;
        }
    }

    [self.messages addObjectsFromArray:messages];
    
    if (messages.count != 0){
        
        [self.emptyView setHidden:TRUE];
        [self.chatTableView setHidden:FALSE];
        // setup group by date for section
        [self setupDataSource:self.messages];
        
        [self.chatTableView setFrame:CGRectMake(self.chatTableView.frame.origin.x, self.chatTableView.frame.origin.y, self.chatTableView.frame.size.width, self.chatView.frame.origin.y)];
        
        if (!isLoadMore) {
            [self scrollViewScrollToBottom];
        }
        
        [self.chatTableView layoutIfNeeded];

    }
    
    if (self.messages.count == 0)
    {
        [self.emptyView setHidden:FALSE];
        [self.chatTableView setHidden:TRUE];

    }

}

#pragma mark - ChatTableView
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if (![touch.view isKindOfClass:[UITextView class]] && ![touch.view isKindOfClass:[UIButton class]] && ![touch.view isKindOfClass:[UIImageView class]])
    {
        [self dismissKeyBoard];
    }
    
    if (touch.view == self.chatTextView)
    {
        self.animatedLine.hidden = true;
        self.chatTextView.inputView = nil;
        [self.chatTextView reloadInputViews];
        [self.chatTextView becomeFirstResponder];
    }

    if ([[touch view] isKindOfClass:[AwesomeMenuItem class]])
    {
        return NO;
    }
    
    if (circularMenu != nil)
    {
        [circularMenu removeFromSuperview];
    }
    
    return YES;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView*)tableView
{
    return tableViewSections.count;
}

- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    id key = [tableViewSections objectAtIndex:section];
    NSArray* tableViewCellsForSection = [tableViewCells objectForKey:key];
    return tableViewCellsForSection.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString* headerCellIdentifier = @"headerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:headerCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headerCellIdentifier];
    }
    
    // Configure the cell title etc
//    [self configureHeaderCell:cell inSection:section];
    
    //put your values, this is part of my code
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 22.0f)];
    [view setBackgroundColor:[UIColor whiteColor]];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 22)];
    lbl.textAlignment = NSTextAlignmentCenter;
    [lbl setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:12]];
    [lbl setTextColor:[UIColor lightGrayColor]];
    [lbl setText:[tableViewSections objectAtIndex:section]];
    [view addSubview:lbl];
    
//    [lbl setText:[NSString stringWithFormat:@"Section: %ld",(long)section]];
    
    [cell addSubview:view];
//    cell.transform =CGAffineTransformMakeScale(1, -1);
//    return view;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id key = [tableViewSections objectAtIndex:indexPath.section];
    NSArray* tableViewCellsForSection = [tableViewCells objectForKey:key];

    message* mess = (message*)[tableViewCellsForSection objectAtIndex:indexPath.row];
    
    if (mess.resource == RES_TYPE_GIVE_FLOWER)
    {
        NSString *identifier = @"ChatFlower";
        
        ChatTableViewCellFlower *flowerCell = (ChatTableViewCellFlower*)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (flowerCell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"ChatTableViewCellFlower" bundle:nil] forCellReuseIdentifier:identifier];
            flowerCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        }
        
        long long nFlower = [mess.body longLongValue] ;
        
        if (mess.sender_id != profileData.uid)
        {
            [flowerCell.imgBG setImage:[UIImage imageNamed:@"frame_friend_action"]];
            [flowerCell.lblContent setText:[NSString stringWithFormat:NSLocalizedString(@"%@ gave you %@ %@", nil), _screen_name, mess.body, nFlower > 1 ?NSLocalizedString(@"flowers", nil) : NSLocalizedString(@"flower", nil)]];
        }
        else
        {
            [flowerCell.imgBG setImage:[UIImage imageNamed:@"frame_user_action"]];
            [flowerCell.lblContent setText:[NSString stringWithFormat:NSLocalizedString(@"You gave %@ %@ to %@", nil), mess.body, nFlower > 1?NSLocalizedString(@"flowers", nil) : NSLocalizedString(@"flower", nil), _screen_name]];
        }
        
        return flowerCell;
    }
    else
    {
        if (mess.sender_id != profileData.uid)
        {
            NSString *identifier = @"ChatLeft";
            
            ChatTableViewCellLeft *cell = (ChatTableViewCellLeft*)[tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (cell == nil) {
                [tableView registerNib:[UINib nibWithNibName:@"ChatTableViewCellLeft" bundle:nil] forCellReuseIdentifier:identifier];
                cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            }
            
            [cell configCellWithMessage:mess Avatar:self.receiverAvatar.image StickerList:emojiKeyboard.stickerList];
            cell.navigationController = self.navigationController;
            return cell;
        }
        else
        {
            NSString *identifier = @"ChatRight";
            ChatTableViewCellRight *cell = (ChatTableViewCellRight*)[tableView dequeueReusableCellWithIdentifier:identifier];

            if (cell == nil) {
                [tableView registerNib:[UINib nibWithNibName:@"ChatTableViewCellRight" bundle:nil] forCellReuseIdentifier:identifier];
                cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            }
            
            [cell configCellWithMessage:mess StickerList:emojiKeyboard.stickerList];
            

        
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id key = [tableViewSections objectAtIndex:indexPath.section];
    NSArray* tableViewCellsForSection = [tableViewCells objectForKey:key];
    message* mess = (message*)[tableViewCellsForSection objectAtIndex:indexPath.row];
    if(mess.resource == RES_TYPE_GIVE_FLOWER)
        return CELL_HEIGHT_FLOWER;
    if(mess.resource == RES_TYPE_STICKER)
        return CELL_HEIGHT_STICKER;

    return UITableViewAutomaticDimension;
}

- (void)scrollViewScrollToBottom
{
    if (tableViewSections == nil || tableViewCells == nil) {
        return;
    }
    id key = [tableViewSections objectAtIndex:tableViewSections.count - 1];
    NSArray* tableViewCellsForSection = [tableViewCells objectForKey:key];
    NSIndexPath* ip = [NSIndexPath indexPathForRow:tableViewCellsForSection.count -1 inSection:tableViewSections.count - 1];
    [_chatTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


// MARK: - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.chatTableView)
    {
        if (scrollView.contentOffset.y == 0) {
            isLoadMore = YES;
            message* lastMess = (message *)[self.messages lastObject];
            [self loadPreviousChatWithLastMessageID:lastMess.message_id];
        }
    }
}

#pragma mark - UITextView - CHAT INPUT
- (void)resetTextStyle {
    //After changing text selection, should reset style.
    NSRange wholeRange = NSMakeRange(0, _chatTextView.textStorage.length);
    
    [_chatTextView.textStorage removeAttribute:NSFontAttributeName range:wholeRange];
    
    [_chatTextView.textStorage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:wholeRange];
}



#pragma mark - Emoji Action

- (IBAction)showPlainText:(id)sender {
//    _infoLabel.text = [NSString stringWithFormat:@"Output: %@", [_textView.textStorage getPlainString]];
}

#pragma mark - Emoji Keyboard

- (IBAction)switchKeyBoard:(id)sender
{
    if (self.chatTextView.inputView == nil)
    {  // switch to EmojiInputKeyboard
        UIImage *image = [UIImage imageNamed:@"icon_text"];
        [sender setImage:image forState:UIControlStateNormal];
        self.chatTextView.inputView = self.emojiKeyboard;
    }
    else // switch to Default Keyboard
    {
        self.chatTextView.inputView = nil;
        UIImage *image = [UIImage imageNamed:@"Icon_Emoji"];
        [sender setImage:image forState:UIControlStateNormal];
    }
    
    [self.chatTextView reloadInputViews];
    [self.chatTextView becomeFirstResponder];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text containsString:s_placeholder])
    {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    self.chatTextView.inputView = nil;
    
    if (textView.text.length == 0)
    {
        textView.text = s_placeholder;
        textView.textColor = [UIColor lightGrayColor];
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""])
    {
        [_sendButton setEnabled:FALSE];
    }
    else
    {
        [_sendButton setEnabled:TRUE];
    }
    
    UITextPosition* pos = textView.endOfDocument;//explore others like beginningOfDocument if you want to customize the behaviour
    CGRect currentRect = [textView caretRectForPosition:pos];
    
    if (currentRect.origin.y != previousTextViewPosition.origin.y)
    {
        if (currentRect.origin.y > previousTextViewPosition.origin.y)
        {
            currentTextViewLine += 1;
        }
        else
        {
            currentTextViewLine -= 1;
        }

        if (currentTextViewLine <= 5)
        {
            self.chatViewHeight.constant = CHAT_VIEW_DEFAULT_HEIGHT + textView.contentSize.height - TEXT_VIEW_DEFAULT_HEIGHT;
        }
    }
    
    previousTextViewPosition = currentRect;
    
#if USING_EMOJI == TRUE
    //replace all empji_Codes with emoji_Images
    //need to implement find all emojiCodes
    [self replaceEmojiKeyByImageInTextView:textView replacementText:@"[2]" emojiIcon:[UIImage imageNamed:@"1001A3_k"]];
#endif

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([textView.text containsString:s_placeholder])
    {
        textView.text = [textView.text substringFromIndex:[s_placeholder length]];
        textView.textColor = [UIColor blackColor];
    }
    
//    if ([text isEqualToString:@"\n"])
//    {
//        if(![textView.text isEqualToString:@""])
//        {
//            //send message
//            [self touchSendButton:self];
//        }
//
//        [textView becomeFirstResponder];
//
//        return NO;
//    }
    
    if ([text isEqualToString:@""])
    {
        currentTextViewLine = 1;
    }
    
#if USING_STICKER == TRUE
    //replace all empji_Codes with emoji_Images
    //need to implement find all emojiCodes
   if ([emojiKeyboard.stickerList objectForKey:text]) {
        [self sendMessage:text];
        
        [textView becomeFirstResponder];
        return NO;
    }
#endif

    return YES;
}

- (void)replaceEmojiKeyByImageInTextView:(UITextView*)textView replacementText:(NSString*) fText emojiIcon:(UIImage*) icon
{
    NSString *findText = fText;
    NSInteger contentLength = textView.text.length;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:textView.text];
    NSRange rangeSearch = [textView.text rangeOfString:findText options:0 range:NSMakeRange(0, contentLength)];
    
    
    __block UIFont *font ;
    
    while (rangeSearch.location!= NSNotFound) { // search all emojiKey in text of TextView
        __block BOOL _skip=false;
        if(!_skip){
       
            // found text and update range for searching
            textView.selectedRange = rangeSearch;
            
            [textView.attributedText enumerateAttributesInRange:rangeSearch
                                                        options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired
                                                     usingBlock:
             ^(NSDictionary *attributes, NSRange range, BOOL *stop)
             {
                 NSMutableDictionary *mutableAttributes = [NSMutableDictionary dictionaryWithDictionary:attributes];
                 UIFont *currentColor = [mutableAttributes objectForKey:@"NSColor"];
                 font = [mutableAttributes objectForKey:@"NSFont"];
                 if (currentColor!= nil)
                 {
                     _skip = TRUE;
                 }
             }];
            
            // replace found text by emoji icon image
            CGSize sizeofFindText =[[textView.text substringWithRange:rangeSearch] sizeWithAttributes:@{NSFontAttributeName: font}];
            // find position for insert icon
            CGPoint cursorPosition = [textView caretRectForPosition:textView.selectedTextRange.start].origin;
            UIView *customEmojiView = [[UIView alloc]initWithFrame:CGRectMake(cursorPosition.x/*-22.5f*/, cursorPosition.y +1, sizeofFindText.width, sizeofFindText.width)];
            //insert icon into textview
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, sizeofFindText.width, sizeofFindText.width)];
            [img setImage:icon];
            [customEmojiView addSubview:img];
            [textView insertSubview:customEmojiView atIndex:0];
            //change color of emojikey in text
            
            [attributedString addAttribute:NSForegroundColorAttributeName
                                     value:[UIColor clearColor]
                                     range:rangeSearch];
            [attributedString addAttribute:NSFontAttributeName
                                     value:font
                                     range:NSMakeRange(0, textView.text.length)];
            textView.attributedText = attributedString;
        }
        //find next
        if(rangeSearch.location + (rangeSearch.length*2) <= textView.text.length)
        {
            rangeSearch.location += fText.length;
            rangeSearch =[textView.text rangeOfString:findText options:0 range:NSMakeRange(rangeSearch.location, textView.text.length - rangeSearch.location)];
            
        }
        else
        {
            textView.selectedRange = NSMakeRange(contentLength, 0);
            break;
        }
    }
    textView.selectedRange = NSMakeRange(contentLength, 0);
}

- (IBAction)handleSingletap:(id)sender {
    [self dismissKeyBoard];
}

- (void)dismissKeyBoard
{
    [self.view endEditing:TRUE];
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    CGSize keyboardSize = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSTimeInterval time = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions option = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedLongValue];
    CGFloat keyboardHeight = keyboardSize.height;
    
    if (@available(iOS 11.0, *)) {
        keyboardHeight -= self.view.safeAreaInsets.bottom;
    }
    
    self.stickerViewBottomMargin.constant = -1 * keyboardHeight;
    [self.stickerView setNeedsUpdateConstraints];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:time delay:0 options:option animations:^{
        [self.stickerView layoutIfNeeded];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (weakSelf) {
            [weakSelf scrollViewScrollToBottom];
        }
    }];
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    self.stickerViewBottomMargin.constant = 0;
    [self.stickerView setNeedsUpdateConstraints];
    
    NSTimeInterval time = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions option = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedLongValue];
    
    [UIView animateWithDuration:time delay:0 options:option animations:^{
        [self.stickerView layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - Button Delegate

- (IBAction)touchClearTextField:(id)sender {
    [self.chatTextView deleteBackward];
}

- (void)touchReportButton
{
    [self dismissKeyBoard];
    
    reportPopUp.parentView = self;
    [reportPopUp showInView:[[[UIApplication sharedApplication] delegate] window] animated:TRUE];
}

- (IBAction)touchSendButton:(id)sender
{
    [_sendButton setEnabled:FALSE];
    [self sendMessage:self.chatTextView.textStorage.getPlainString];
}

- (void)processAfterGivingFlower:(out_flower_give *)data {
    profileData = [userDefaultManager getUserProfileData];
    profileData.your_num_flower = data.mFlower;
    [userDefaultManager saveUserProfileData:profileData];
    [_tabbar updateFlowerValue];
    
    if (data.bonus_flower > 0)
    {
        [AppHelper showMatchingFlowerPopUp:data.bonus_flower];
    }
}

#pragma mark - Others Functions

- (void)loadPreviousChatWithLastMessageID:(NSString *)msgID
{
    if (msgID) {
        [[SocketManager shareInstance] getMessageHistoryWithSenderID:profileData.uid ReceiverID:_uid RoomID:self.roomID mID:msgID];
    }
}

// MARK: - Selectors
- (void)switchStickerKeyboard:(NSNotification*)notification
{
    self.animatedLine.hidden = false;
    self.chatTextView.inputView = self.emojiKeyboard;
    [self.chatTextView reloadInputViews];
    [self.chatTextView becomeFirstResponder];
}

- (void)touchButtonMore
{
    [self dismissKeyBoard];
    
    if (circularMenu != nil)
    {
        [circularMenu removeFromSuperview];
    }
    
     popupView = [ChatPopupView createInView:[[[UIApplication sharedApplication] delegate] window]];
    popupView.navigationController = self.navigationController;
    popupView.parentViewController = self;
    popupView.delegate = self;
    popupView.uid = self.uid;
    popupView.block = chatStatus.block;
//    popupView.is_blocked = self.isBlocked;
    popupView.destinationView = _destinationView;
    [popupView show];
}

//MARK: - ChatPopupViewDelegate
- (void)chatPopupView_selectViewProfile{
    UserProfileViewController *view = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
    view.uid = self.uid;
    view.hidesBottomBarWhenPushed = false;
    view.destinationView = _destinationView;
    [self.navigationController pushViewController:view animated:YES];
}

- (void)chatPopupView_deleteConversation{
    
    deleteConversionData *params = [[deleteConversionData alloc] initWithAccessToken:[userDefaultManager getAccessToken] deviceId:[userDefaultManager getDeviceToken] rosterId:_uid];
    if (params) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
        API_Delete_Conversation *api = [[API_Delete_Conversation alloc] initWithParams:params];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
            if(response.status) {
                if ([self.delegate respondsToSelector:@selector(chatViewController_DeleteRoomWithID:)]) {
                    [self.delegate chatViewController_DeleteRoomWithID:self.roomID];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        } ErrorHandlure:^(NSError *error) {
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        }];
    }
}

- (void)chatPopupView_blockConversation{
    [[SocketManager shareInstance] blockChatWithID:profileData.uid ReceiverID:self.uid];
    [[SocketManager shareInstance] setOnBlockEventResponse:^(ChatStatus * status) {
        if (status.block == 1) { //Block
            chatStatus = status;
            [self checkBlockStateWithStatus:chatStatus];
        }
    }];
}

- (void)chatPopupView_unBlockConversation{
    [[SocketManager shareInstance] unBlockChatWithID:profileData.uid ReceiverID:self.uid];
    [[SocketManager shareInstance] setOnUnBlockEventResponse:^(BOOL status) {
        if (status) {
            chatStatus.block = 0;
            [self checkBlockStateWithStatus:chatStatus];
             [AppHelper showMessageBox:nil message:[AppHelper getLocalizedString:@"Chat.unblockSuccessfulMessage"]];
            
            if (self.roomID) {
                [self.messages removeAllObjects];
                [self loadPreviousMessageWitnSenderID:profileData.uid ReceiverID:_uid RoomID:self.roomID MessageID:@""];
            }
            

        }
    }];
    
}

@end
