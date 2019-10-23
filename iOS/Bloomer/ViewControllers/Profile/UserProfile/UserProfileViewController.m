//
//  UserProfileViewController.m
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 3/22/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "UserProfileViewController.h"
#import "AppDelegate.h"
#import "AppHelper.h"

#define WIDTH_SCREEN [[UIScreen mainScreen] bounds].size.width
#define OBJECT_WIDTH 80.0f
#define OBJECT_HEIGHT 80.0f
#define MARGIN_VERTICAL 0.0f
#define MARGIN_HORIZONTAL 0.0f
#define DRAGGABLE_LOCATION_WIDTH  ((OBJECT_WIDTH  * 3) + (MARGIN_HORIZONTAL * 5))
#define DRAGGABLE_LOCATION_HEIGHT ((OBJECT_HEIGHT * 3) + (MARGIN_VERTICAL   * 5))

@interface UserProfileViewController () {
    UserDefaultManager *userDefaultManager;
    NSMutableArray *bannerList;
    NSMutableArray *listGallery; // list albums
    NSMutableDictionary *listPostGallery; // photos list of album
    out_profile_fetch *profileData;
    CGRect bottomFrame;
    CGRect topFrame;
    NSInteger currentIndex;
    UserProfilePopupViewController *popup;
    FlowerMenuPostPopupViewController *flowerPopup;
    BOOL activeRaces;
    BOOL isShowingChatPopup;
    //giving flower
    ThankYou * thankyouPopup;
    BOOL isGiveUser;
    NSIndexPath *draggedCellIndex;
    NSTimer *timer;
    NSIndexPath *giveIndex;
    UIAlertView* unB;
    BOOL isBlock;
    BOOL isNaviBarInit;
    BOOL isInView;
    
    NSInteger bronze;
    NSInteger silver;
    NSInteger gold;
}

@end

@implementation UserProfileViewController
@synthesize circularMenu, post_id;//, flowerPopup;

#pragma mark - View functions
- (void)viewDidLoad
{
    [super viewDidLoad];
        
    isBlock = false;
    isNaviBarInit = true;
    isInView = true;
    // Do any additional setup after loading the view from its nib.
    userDefaultManager = [[UserDefaultManager alloc] init];
    _listDraggableLocatioinList = [[NSMutableArray alloc] init];
    profileData = [[out_profile_fetch alloc] init];
    bannerList = [[NSMutableArray alloc] init];
    listPostGallery = [[NSMutableDictionary alloc]init];
    _tableView.alwaysBounceVertical = TRUE;
    _tableView.bounces = TRUE;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    
    bottomFrame = CGRectMake(0, 285, 320, 102);
    bottomFrame.origin.y = 285 + _message.frame.size.height;
    [_bottomView setFrame:bottomFrame];
    
    topFrame = CGRectMake(0, 0, WIDTH_SCREEN, 402);
    topFrame.size.height = bottomFrame.origin.y + bottomFrame.size.height;
    [_topView setFrame:topFrame];
    
    _tableView.tableHeaderView = _topView;
    
    currentIndex = 0;
    activeRaces = TRUE;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _tabbar = appDelegate.tabbar;
    
    [self configureDraggableLocation:_draggableLocation makeCircle:FALSE];
    _draggableLocation.delegate = self;
    
    _blockView.text = NSLocalizedString(@"userprofile.WarningBeingLocked.Title", );
    
    _Achievementlabel.text = NSLocalizedString(@"AchievementName.title", );
    _swipeToViewMore.text = NSLocalizedString(@"SwipeLabelLeaderBoard.title", );
    
    _YesButtonBlock.layer.cornerRadius = _YesButtonBlock.frame.size.height/2;
    _YesButtonBlock.clipsToBounds = YES;
    [[_YesButtonBlock layer] setBorderWidth:2.0f];
    [[_YesButtonBlock layer] setBorderColor:UIColorFromRGB(0x202021).CGColor];
    [_YesButtonBlock setTitle:NSLocalizedString(@"InfoUserAgreeButton.title",) forState:UIControlStateNormal];
    
    _NoButtonBlock.layer.cornerRadius = _NoButtonBlock.frame.size.height/2;
    _NoButtonBlock.clipsToBounds = YES;
    [[_NoButtonBlock layer] setBorderWidth:2.0f];
    [[_NoButtonBlock layer] setBorderColor:UIColorFromRGB(0x202021).CGColor];
    [_NoButtonBlock setTitle:NSLocalizedString(@"InfoUserDenyButton.title",) forState:UIControlStateNormal];
    
    _BlockLabel.text = NSLocalizedString(@"InfoUsersBlockContent.title", );
    
    self.achievementButton.enabled = false;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [self refreshProfile];
    }];
    
    [self loadProfileUsingAPI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //INIT value
    isInView = true;
    
    [_tabbar.draggableButton removeAllAllowedDropLocations ];
    if (![_tabbar.draggableButton.droppableLocations containsObject:_draggableLocation])
    {
        [_tabbar.draggableButton addAllowedDropLocation:_draggableLocation];
    }
    for (SEDraggableLocation *location in _listDraggableLocatioinList)
    {
        [_tabbar.draggableButton addAllowedDropLocation:location];
    }
    
    [self.navigationController setNavigationBarHidden:FALSE];
    
    [self.tabBarController.tabBar setTranslucent:true];
    [self.tabBarController.tabBar setHidden:false];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_tabbar.draggableButton removeAllowedDropLocation:_draggableLocation];
    if (circularMenu != nil) {
        [circularMenu removeFromSuperview];
    }
    for (SEDraggableLocation *location in _listDraggableLocatioinList)
    {
        [_tabbar.draggableButton removeAllowedDropLocation:location];
    }
    
    if (self.isMovingFromParentViewController) {
        NSArray *viewControllers = self.navigationController.viewControllers;
        for (NSInteger i = (viewControllers.count - 1); i >= 0; i--) {
            UIViewController *view = viewControllers[i];
            if ([view isKindOfClass:[MembershipViewController class]]) {
                view.hidesBottomBarWhenPushed = true;
                break;
            }else if ([view isKindOfClass:[ChatViewController class]]){
                [self.tabBarController.tabBar setHidden:YES];
                break;
            }

        }
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.view endEditing:YES];
    isInView = false;
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
}

#pragma mark - Initialize Functions

- (void)initNavigationBar {
    UILabel *nameTitleView = [[UILabel alloc] initWithFrame:CGRectZero];
    nameTitleView.backgroundColor = [UIColor clearColor];
    nameTitleView.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:16];
    nameTitleView.textColor = [UIColor whiteColor];
    nameTitleView.text = profileData.username;
    [nameTitleView sizeToFit];
    
    if (isBlock == FALSE)
    {
        self.navigationItem.titleView = nameTitleView;
    }
    else
    {
        self.navigationItem.titleView = nil;
    }
    
    if (!profileData.is_block || isBlock == FALSE) {
//        UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Icon_More_White"]
//                                                                       style:UIBarButtonItemStylePlain
//                                                                      target:self
//                                                                      action:@selector(touchInfoButton)];
        
//        [infoButton setImageInsets:UIEdgeInsetsMake(20, 0, 0, 0)];
//
//        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:infoButton, nil]];
//        self.navigationItem.rightBarButtonItem = infoButton;
        
        
        UIButton *moreOptionsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [moreOptionsButton setImage:[UIImage imageNamed:@"Icon_More_White"] forState:UIControlStateNormal];
        [moreOptionsButton addTarget:self action:@selector(touchInfoButton) forControlEvents:UIControlEventTouchUpInside];
        moreOptionsButton.frame = CGRectMake(0, 0, 40, 40);
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreOptionsButton];
        
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)initProfile {
    _avatar.layer.borderWidth = 2;
    _avatar.layer.borderColor = [UIColor colorFromHexString:@"#FFFFFF"].CGColor;
    _avatar.layer.cornerRadius = _avatar.frame.size.width / 2;
    _avatar.clipsToBounds = YES;
    
    _avatarCircle.layer.cornerRadius = _avatarCircle.frame.size.width / 2;
    _avatarCircle.layer.borderWidth = 1;
    _avatarCircle.layer.borderColor = [UIColor colorFromHexString:@"#FFFFFF"].CGColor;
    
    _location.text = profileData.location_name;
    _numberFlower.text = @(profileData.num_received_flower + profileData.flower_thankful).stringValue;
    
    if(profileData.num_received_flower + profileData.flower_thankful <= 1)
    {
        _flowerName.text = NSLocalizedString(@"FLOWERName.Title", );
    }
    else
    {
        _flowerName.text = NSLocalizedString(@"FLOWERSName.Title", );
    }
    
    //chat layout
    if(profileData.is_chat || profileData.remain_flower==0){
        [_ChatIcon setImage:[UIImage imageNamed:@"icon_chat-1"]];
        _ChatLabel.textColor = UIColorFromRGB(0x202021);
        [_chatButton setHidden:false];
    } else {
        [_ChatIcon setImage:[UIImage imageNamed:@"icon_chat_popup"]];
        _ChatLabel.textColor = UIColorFromRGB(0xACACAC);
        [_chatButton setHidden:false];
    }
    
    
    _numReciever.text = @(profileData.following).stringValue;
    if (profileData.following <= 1) {
        _RecieveTitle.text = NSLocalizedString(@"RecieverName.Title", );
    } else {
        _RecieveTitle.text = NSLocalizedString(@"RecieversName.Title", );
    }
    
    
    _numGivers.text = @(profileData.follower).stringValue;
    
    if (profileData.follower <= 1) {
        _GiverTitle.text = NSLocalizedString(@"GiverName.Title", );
    } else {
        _GiverTitle.text = NSLocalizedString(@"GiversName.Title", );
    }
    
    _name.text = profileData.name;
    _username.text = profileData.username;
    [_avatar sd_setImageWithURL:[NSURL URLWithString:profileData.avatar]];
    
    _message.numberOfLines = 0;
    
    
    if([profileData.about_me isEqualToString:@""])
    {
        _message.text = profileData.about_me;
        _TopViewContrain = [NSLayoutConstraint constraintWithItem:_message
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_StatusView
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1
                                                         constant:0];
        
        [_StatusView addConstraint:_TopViewContrain];
        _BottomViewContrain = [NSLayoutConstraint constraintWithItem:_StatusView
                                                           attribute:NSLayoutAttributeBottom
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:_message
                                                           attribute:NSLayoutAttributeBottom
                                                          multiplier:1
                                                            constant:0];
        
        
        [_StatusView addConstraint:_BottomViewContrain];
        
        [self.view layoutIfNeeded];
        
        NSInteger myNewHeight = _TopViewImage.frame.size.height + _FlowerNumView.frame.size.height + _ButtonView.frame.size.height + _LineView.frame.size.height + 2;
        
        topFrame = _topView.frame;
        
        
        topFrame.size.height = myNewHeight;
        [_topView setFrame:topFrame];
        
        [self.view layoutIfNeeded];
        
        [_LineView setHidden:true];
    }
    else
    {
        _message.text = [profileData.about_me removeDuplicateNewLines];
        
        [self.view layoutIfNeeded];
        
        NSInteger myNewHeight = _TopViewImage.frame.size.height + _FlowerNumView.frame.size.height + _ButtonView.frame.size.height + _LineView.frame.size.height + _StatusView.frame.size.height + 2;
        
        topFrame = _topView.frame;
        
        topFrame.size.height = myNewHeight;
        [_topView setFrame:topFrame];
        
        [self.view layoutIfNeeded];
        
        _message.textColor = UIColorFromRGB(0x3E3E3E);
        
    }
    
    
//    [_message sizeToFit];
    
    bottomFrame = CGRectMake(0, 285, 320, 102);
    bottomFrame.origin.y = 285 + _message.frame.size.height;
    [_bottomView setFrame:bottomFrame];
    
    //    topFrame = CGRectMake(0, 0, 320, 402);
    //    topFrame.size.height = bottomFrame.origin.y + bottomFrame.size.height;
    //    [_topView setFrame:topFrame];
    _tableView.tableHeaderView = _topView;
    
    [self.winnerButton setHidden:[profileData.video_link isEqualToString:@""]];
    
    if (isNaviBarInit) {
        [self initNavigationBar];
        isNaviBarInit = false;
    }
}

- (void)initSlideShow {
    [_slideshow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 0; i < bannerList.count; i++) {
        BannerObj *temp = (BannerObj *)[bannerList objectAtIndex:i];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH_SCREEN * i, 0, WIDTH_SCREEN, _slideshow.frame.size.height)];
        
        [[SDImageCache sharedImageCache]clearMemory];
        [[SDImageCache sharedImageCache]clearDisk];
        
        [imageView setImageWithAnimationFromURL:[NSURL URLWithString:temp.photo_url] placeHolder:[UIImage imageNamed:@"Banners_mockup.png"]];
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = TRUE;
        
        [_slideshow addSubview:imageView];
        
        _slideshow.contentSize = CGSizeMake(bannerList.count * WIDTH_SCREEN, _slideshow.frame.size.height);
    }
}



#pragma mark - Giving Flower
- (void)draggableLocation:(SEDraggableLocation *)location didRefuseObject:(SEDraggable *)object entryMethod:(SEDraggableLocationEntryMethod)method
{
    [object setHidden:true];
    
    if (circularMenu != nil) {
        [circularMenu removeFromSuperview];
    }
    
    if (location == _draggableLocation)
    {
        isGiveUser = TRUE;
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        
        circularMenu = [self createCircularMenuWithFrame:_draggableLocation.bounds];
        circularMenu.startPoint = CGPointMake(self.slideshow.contentOffset.x + (screenSize.width / 2), self.slideshow.contentOffset.y + (self.slideshow.frame.size.height / 2));
        circularMenu.delegate = self;
        circularMenu.menuWholeAngle = 2.5f;
        circularMenu.farRadius = 60.0f;
        circularMenu.endRadius = 50.0f;
        circularMenu.nearRadius = 40.0f;
        circularMenu.animationDuration = 0.7f;
        circularMenu.rotateAngle = 5.04f;
        [circularMenu setExpanding:YES];
        
        [self.slideshow addSubview:circularMenu];
    }
    else
    {
        isGiveUser = FALSE;
        
        int realIndex = (int)location.index.row / 10;
        int inCellIndex = location.index.row % 10;
        
        NSIndexPath *indexLocation = [NSIndexPath indexPathForRow:realIndex inSection:0];
        
        ProfileRaceListTableViewCell *cell = (ProfileRaceListTableViewCell *)[_tableView cellForRowAtIndexPath:indexLocation];
        
        if(inCellIndex == 0)
        {
            circularMenu = [self createCircularMenuWithFrame:cell.bounds];
            circularMenu.startPoint = [location convertRect:CGRectMake(location.center.x, location.center.y, cell.bounds.size.width, cell.bounds.size.height) toView:self.tableView].origin;
            circularMenu.delegate = self;
            circularMenu.menuWholeAngle = M_PI * 2;
            circularMenu.rotateAngle = M_PI + M_PI/4;
            circularMenu.farRadius = 35.0f;
            circularMenu.endRadius = 32.0;
            circularMenu.nearRadius = 30.0f;
            circularMenu.animationDuration = 0.7f;
            [circularMenu setExpanding:YES];
            
            [_tableView addSubview:circularMenu];
            
            post_id = cell.postID;
            
        }
        else if(inCellIndex == 1)
        {
            circularMenu = [self createCircularMenuWithFrame:cell.bounds];
            circularMenu.startPoint = [location convertRect:CGRectMake(location.center.x, location.center.y, cell.bounds.size.width, cell.bounds.size.height) toView:self.tableView].origin;
            circularMenu.delegate = self;
            circularMenu.menuWholeAngle = M_PI * 2;
            circularMenu.rotateAngle = M_PI + M_PI/4;
            circularMenu.farRadius = 35.0f;
            circularMenu.endRadius = 32.0;
            circularMenu.nearRadius = 30.0f;
            circularMenu.animationDuration = 0.7f;
            [circularMenu setExpanding:YES];
            
            [_tableView addSubview:circularMenu];
            
            post_id = cell.postID1;
        }
        
        [self removeThankYou];
        giveIndex = location.index;
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
    AwesomeMenuItem *startItem;
    if(isGiveUser == TRUE)
    {
        startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"GivingFlower_Store.png"]
                                          highlightedImage:[UIImage imageNamed:@"GivingFlower_Store.png"]
                                                      text:@""];
    }
    else if(isGiveUser == FALSE)
    {
        startItem = [[AwesomeMenuItem alloc] initWithImage:nil
                                          highlightedImage:nil
                                                      text:@""];
    }
    AwesomeMenu *resultMenu = [[AwesomeMenu alloc] initWithFrame:frame startItem:startItem optionMenus:menus isCell:FALSE];
    
    return resultMenu;
}

- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    [menu removeFromSuperview];
    //    if (isGiveUser)
    //    {
    CGRect frameInRootView = [_avatar convertRect:_avatar.bounds toView:_topView];
    [self CreateThankYouForProfile:CGPointMake(frameInRootView.origin.x - 10, frameInRootView.origin.y)];
    
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
    } else {
        if (idx == 3) {
            flowerPopup = [[FlowerMenuPostPopupViewController alloc] initWithNibName:@"FlowerMenuPopUpViewController" bundle:nil];
            flowerPopup.uid = _uid;
            flowerPopup.parentView = self;
            flowerPopup.isFirstRank = FALSE;
            [flowerPopup showInView:[[[UIApplication sharedApplication] delegate] window] animated:TRUE];
        } else if (idx == 4 || idx == -1) {
            FlowerGardenViewController *view = [[FlowerGardenViewController alloc] initWithNibName:@"FlowerGardenViewController" bundle:nil];
            [_tabbar snapbackFlowerIconToTabbar];
            view.hidesBottomBarWhenPushed = TRUE;
            [self.navigationController pushViewController:view animated:TRUE];
        }
    }
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    if ([[touch view] isKindOfClass:[AwesomeMenuItem class]]){
        return NO;
    }
    
    [self removeThankYou];
    
    if (circularMenu != nil)
    {
        [circularMenu removeFromSuperview];
        //        if (isGiveUser == FALSE)
        //        {
        //            [circularMenu removeFromSuperview];
        //        }
    }
    
    return YES;
}

- (void)CreateThankYouForProfile:(CGPoint)point
{
    [thankyouPopup removeFromSuperview];
    if(thankyouPopup){
        [thankyouPopup repositionToPoint:point];
    } else {
        thankyouPopup = [[ThankYou alloc]initWithStyle:ThankYouStyleForProfile atPoint:point];
    }
    
}


- (void)CreateGalleryThankYouView:(CGPoint)point
{
    [thankyouPopup removeFromSuperview];
    
}


- (void)AddThankYouView
{
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(removeThankYou) userInfo:nil repeats:NO];
    
    [_topView addSubview:thankyouPopup];
}

- (void)removeThankYou
{
    if(thankyouPopup != nil && [thankyouPopup superview]== _topView){
        [thankyouPopup removeFromSuperview];
    }
    
}


#pragma mark - API functions + Delegate

- (IBAction)touchUnBlock:(id)sender {
    block_remove *params = [[block_remove alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] uid:_uid];
    if(params) {
        API_BlockRemove *api = [[API_BlockRemove alloc] initWithParams:params];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            if (response.status)
            {
                [self loadProfileUsingAPI];
            }
            else
            {
                [AppHelper showMessageBox:nil message:response.message];
            }
        } ErrorHandlure:^(NSError *error) {
            
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == unB) {
        if (buttonIndex == 1) {
            block_remove *params = [[block_remove alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] uid:_uid];
            if(params) {
                API_BlockRemove *api = [[API_BlockRemove alloc] initWithParams:params];
                [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                    if (response.status)
                    {
                        [self loadProfileUsingAPI];
                    }
                    else
                    {
                        [AppHelper showMessageBox:nil message:response.message];
                    }
                } ErrorHandlure:^(NSError *error) {
                    
                }];
            }
        }
    }
}

- (void)loadSlideShowUsingAPI {
    API_Profile_BannerFetches *api = [[API_Profile_BannerFetches alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                                               device_token:[userDefaultManager getDeviceToken]
                                                                                        uid:_uid];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        if (response.status) {
            JSON_BannerFetch *data = (JSON_BannerFetch *)jsonObject;
            bannerList = data.bannerList;
            
            if (bannerList.count <= 1) {
                [_swipeToViewMore setHidden:true];
            } else {
                [_swipeToViewMore setHidden:false];
            }
            
            if (bannerList.count != 0) {
                [self initSlideShow];
            }
        } else {
            [AppHelper showMessageBox:nil message:response.message];
        }
    } ErrorHandlure:^(NSError *error) {
    }];
    
}

- (void)loadMembershipAPI {
    // Membership
    API_Get_RewardMemebership* membershipAPI = [[API_Get_RewardMemebership alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                                                             deviceId:[userDefaultManager getDeviceToken]
                                                                                            andUserId:self.uid];
    __weak typeof(self) weakSelf = self;
    [membershipAPI getRequest:^(BaseJSON *json, RestfulResponse *response) {
        if (weakSelf) {
            //            __strong typeof(weakSelf)strongSelf = weakSelf;
            RewardMembership *object = (RewardMembership *)json;
            if (response.status) {
                bronze = object.Bronze;
                silver = object.Silver;
                gold = object.Gold;
                
                self.achievementButton.enabled = true;
            } else {
                [AppHelper showMessageBox:nil message:response.message];
            }
            [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
            
        } else {
            [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        }
        
    } ErrorHandlure:^(NSError *error) {
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];
}

- (void)loadProfileUsingAPI
{
    if (isInView == true) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
    }
    API_ProfileFetch * api = [[API_ProfileFetch alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] andUserId:[NSString stringWithFormat:@"%ld", (long)_uid]];
    
    [api getRequest:^(BaseJSON * json, RestfulResponse * objStatus) {
        out_profile_fetch * data = (out_profile_fetch *) json;
        if (objStatus.status)
        {
            isBlock = false;
            [_LockView setHidden:YES];
            profileData = data;
            if(profileData.is_block){
                [_BeingLockedView setHidden:NO];
                [self initNavigationBar];
            } else {
                [_BeingLockedView setHidden:YES];
                [self initProfile];
                [self loadSlideShowUsingAPI];
                [self loadGallery];
            }
         
            if (!self.achievementButton.enabled)
            {
                [self loadMembershipAPI];
            }
        }
        else
        {
            
            profileData.is_block = true;
            isBlock = true;
            if(objStatus.code == 415 || objStatus.code == 454)
            {
                [_BeingLockedView setHidden:NO ];
                [_LockView setHidden:YES];
            }else if(objStatus.code == 409 ){
                [_LockView setHidden:NO];
                [_BeingLockedView setHidden:YES ];
            }
            
            [self initNavigationBar];
            
        }
        [self loadGBS];
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    } ErrorHandlure:^(NSError * error) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];
    
}


- (void)loadGallery {
    API_Profile_Gallery_Fetches *API = [[API_Profile_Gallery_Fetches alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] uid:_uid];
    [API request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        out_profile_gallery_fetches * data = (out_profile_gallery_fetches *) jsonObject;
        if (response.status) {
            listGallery = [data galleryList];
            if([listGallery count] == 0) {
                profile_gallery *tmp = [[profile_gallery alloc] initWithName:nil key:nil status:0];
                [listGallery addObject:tmp];
                [_tableView reloadData];
            }
            for (profile_gallery* galleryItem in listGallery) {
                if(galleryItem.name != nil)
                    [self loadPhotoByRaceKey:galleryItem.key userID:[profileData uid]];
            }
            [_tableView reloadData];
        } else {
            [AppHelper showMessageBox:nil message:response.message];
        }
    } ErrorHandlure:^(NSError *error) {
        
    }];
}

- (void)getDataProfileGallery_fetches:(out_profile_gallery_fetches *)data {

}

- (void)loadPhotoByRaceKey:(NSString*)key userID:(NSInteger)uID {
    API_Profile_Post_GalleryFetches *API = [[API_Profile_Post_GalleryFetches alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] key:key uid:uID post_id:@"" limit:LOAD_GALLERY_MIN_LIMIT];
    [API request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        JSON_GalleryFetches *data = (JSON_GalleryFetches *)jsonObject;
        if (response.status) {
            [listPostGallery setObject:data.galleryList forKey:key];
            for (int i = 0; i < listGallery.count; i++) {
                if([((profile_gallery*)listGallery[i]).key isEqualToString:key]) {
                    if(data.galleryList.count == 0)
                        [listGallery removeObjectAtIndex:i];
                    break;
                }
            }
            [_tableView reloadData];
        } else {
            [AppHelper showMessageBox:nil message:response.message];
        }
    } ErrorHandlure:^(NSError *error) {
        
    }];

}

- (void)giveFlower:(long long)flower {
    if(isGiveUser == TRUE)
    {
        flower_give_profile *param = [[flower_give_profile alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                                         device_token:[userDefaultManager getDeviceToken]
                                                                           num_flower:flower
                                                                             receiver:_uid];
        if (param) {
            API_Flower_GiveProfile *flowerGiveProfileAPI = [[API_Flower_GiveProfile alloc] initWithParams:param];
            [flowerGiveProfileAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                out_flower_give * data = (out_flower_give *) jsonObject;
                if (response.status) {
                    [userDefaultManager didTutorialGiveFlowerRace:TRUE];
                    [self processAfterGivingFlower:data];
                    [data showFlowerGivingPopupIn:[UIApplication sharedApplication].keyWindow];
                } else {
                    [AppHelper showMessageBox:nil message:response.message];
                }
            } ErrorHandlure:^(NSError *error) {
                
            }];
        }

    }
    else if(isGiveUser == FALSE)
    {
        flower_give_post *params = [[flower_give_post alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] num_flower:flower postID:post_id];
        if (params) {
            API_Flower_GivePost *api = [[API_Flower_GivePost alloc] initWithParams:params];
            [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                out_flower_give * data = (out_flower_give *) jsonObject;
                if (response.status) {
                    [userDefaultManager didTutorialGiveFlowerRace:TRUE];
                    [self processAfterGivingFlower:data];
                    [data showFlowerGivingPopupIn:[UIApplication sharedApplication].keyWindow];
                } else {
                    [AppHelper showMessageBox:nil message:response.message];
                }
            } ErrorHandlure:^(NSError *error) {
                
            }];
        }
        
    }
}



- (void)processAfterGivingFlower:(out_flower_give *)data {
    if(isGiveUser == TRUE)
    {
        out_profile_fetch* myProfile = [userDefaultManager getUserProfileData];
        
        myProfile.your_num_flower = data.mFlower;
        [userDefaultManager saveUserProfileData:myProfile];
        [_tabbar updateFlowerValue];
        
        [_numberFlower setText:[NSString stringWithFormat:@"%ld",(long)data.flower_model]];
        
        [self loadProfileUsingAPI];
        
        [_tableView reloadData];
        
        [self AddThankYouView];
    }
    else if (!isGiveUser)
    {
        int realIndex = (int)giveIndex.row / 10;
        
        int inCellIndex = giveIndex.row % 10;
        
        NSIndexPath *indexLocation = [NSIndexPath indexPathForRow:realIndex inSection:0];
        
        ProfileRaceListTableViewCell *cell = (ProfileRaceListTableViewCell *)[_tableView cellForRowAtIndexPath:indexLocation];
        
        // add thank you popup
        
        NSString *str1FromInt = [NSString stringWithFormat:@"%d",realIndex];
        NSString *str2FromInt = [NSString stringWithFormat:@"%d",inCellIndex];
        
        
        [cell showThankYou:YES atIndex:inCellIndex];
        
        NSDictionary *wrapper = [NSDictionary dictionaryWithObjectsAndKeys:str1FromInt, @"realIndex", str2FromInt, @"inCellIndex", nil];
        
        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(removeThankYouInCell:) userInfo:wrapper repeats:NO];
        
        out_profile_fetch* myProfile = [userDefaultManager getUserProfileData];
        myProfile.your_num_flower = data.mFlower;
        [userDefaultManager saveUserProfileData:myProfile];
        [_tabbar updateFlowerValue];
    }
    
    if (data.bonus_flower > 0)
    {
        [AppHelper showMatchingFlowerPopUp:data.bonus_flower];
    }
}

- (void)removeThankYouInCell:(NSTimer*)theTimer {
    
    NSDictionary *wrapper = (NSDictionary *)[theTimer userInfo];
    
    NSString * obj1 = [wrapper objectForKey:@"realIndex"];
    NSString * obj2 = [wrapper objectForKey:@"inCellIndex"];
    
    int realIndex = [obj1 intValue];
    
    int inCellIndex = [obj2 intValue];
    
    NSIndexPath *indexLocation = [NSIndexPath indexPathForRow:realIndex inSection:0];
    
    ProfileRaceListTableViewCell *cell = (ProfileRaceListTableViewCell *)[_tableView cellForRowAtIndexPath:indexLocation];
    
    // add thank you popup
    
    [cell showThankYou:NO atIndex:inCellIndex];
    [self.tableView reloadRowsAtIndexPaths:@[indexLocation] withRowAnimation:UITableViewRowAnimationNone];
    
    [self loadProfileUsingAPI];
}

//Achievment APIs
- (void)loadAchieveUsingAPI
{
}

- (void) refreshProfile{
    API_ProfileFetch * api = [[API_ProfileFetch alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] andUserId:[NSString stringWithFormat:@"%ld", (long)_uid]];
    
    [api getRequest:^(BaseJSON * json, RestfulResponse * objStatus) {
        [self.tableView.pullToRefreshView stopAnimating];
        out_profile_fetch * data = (out_profile_fetch *) json;
        if (objStatus.status)
        {
            isBlock = false;
            [_LockView setHidden:YES];
            profileData = data;
            if(profileData.is_block){
                [_BeingLockedView setHidden:NO];
                [self initNavigationBar];
            } else {
                [_BeingLockedView setHidden:YES];
                [self initProfile];
                [self loadSlideShowUsingAPI];
                [self loadGallery];
            }
            
            if (!self.achievementButton.enabled)
            {
                [self loadMembershipAPI];
            }
        }
        else
        {
            
            profileData.is_block = true;
            isBlock = true;
            if(objStatus.code == 415 || objStatus.code == 454)
            {
                [_BeingLockedView setHidden:NO ];
                [_LockView setHidden:YES];
            }else if(objStatus.code == 409 ){
                [_LockView setHidden:NO];
                [_BeingLockedView setHidden:YES ];
            }
            
            [self initNavigationBar];
            
        }
        [self loadGBS];
    } ErrorHandlure:^(NSError * error) {
        [self.tableView.pullToRefreshView stopAnimating];
    }];
}


#pragma mark - Action Functions
- (void)touchInfoButton {
    popup = [[UserProfilePopupViewController alloc] initWithNibName:@"UserProfilePopupViewController" bundle:nil];
    popup.gaveFlower = profileData.gaveFlower;
    popup.uid = _uid;
    popup.isFollowing = profileData.is_follow;
    popup.isBlock = profileData.is_block;
    popup.parentView = self;

    popup.view.frame = [UIScreen mainScreen].bounds; // Get device's bounds
    [popup showInView:[[[UIApplication sharedApplication] delegate] window] animated:true];
}

- (IBAction)onSwitchAlbumsAndAchievements:(id)sender {
    currentIndex = ((UIButton*)sender).tag;
    [_tableView reloadData];
    [self reloadTableByCurrentIndex];
}

- (IBAction)touchCurrentRank:(id)sender {
    [_currentRankButton setTitleColor:[UIColor colorWithRed:0.612 green:0 blue:0.078 alpha:1.0] forState:UIControlStateNormal];
    [_bestResultButton setTitleColor:[UIColor colorWithRed:0.682 green:0.682 blue:0.682 alpha:1.0] forState:UIControlStateNormal];
    _currentRankButton.titleLabel.font = [UIFont fontWithName:@"SFUIDisplay-Semibold" size:14];
    _bestResultButton.titleLabel.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:14];
    
    activeRaces = TRUE;
    _achieveData = _activeAchieveData;
    [_tableView reloadData];
    
}

- (IBAction)touchBestResult:(id)sender {
    [_currentRankButton setTitleColor:[UIColor colorWithRed:0.682 green:0.682 blue:0.682 alpha:1.0] forState:UIControlStateNormal];
    [_bestResultButton setTitleColor:[UIColor colorWithRed:0.612 green:0 blue:0.078 alpha:1.0] forState:UIControlStateNormal];
    _currentRankButton.titleLabel.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:14];
    _bestResultButton.titleLabel.font = [UIFont fontWithName:@"SFUIDisplay-Semibold" size:14];
    
    activeRaces = FALSE;
    _achieveData = _closedAchieveData;
    [_tableView reloadData];
}
//
//- (IBAction)touchSegmentControl:(id)sender {
//    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
//    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
//
//    if (selectedSegment == 0) {
//        currentIndex = 0;
//
//        [_topView setFrame:topFrame];
//        [_bottomView setFrame:bottomFrame];
//
//        [_rankView setHidden:TRUE];
//        _tableView.tableHeaderView = _topView;
//        [_tableView reloadData];
//    } else if (selectedSegment == 1) {
//        currentIndex = 1;
//
//        CGRect topViewFrame = topFrame;
//        topViewFrame.size.height = topFrame.size.height + 35;
//        CGRect bottomViewFrame = bottomFrame;
//        bottomViewFrame.size.height = bottomFrame.size.height + 35;
//        [_topView setFrame:topViewFrame];
//        [_bottomView setFrame:bottomViewFrame];
//
//        [_rankView setHidden:FALSE];
//        _tableView.tableHeaderView = _topView;
//        [_tableView reloadData];
//    }
//}

- (IBAction)touchChat:(id)sender {
    if(profileData.is_chat || profileData.remain_flower==0){
        ChatViewController *view;
        view = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
        
        view.uid = profileData.uid;
        view.screen_name = profileData.name;
//        view.isBlock = profileData.is_blocked_chat;
//        view.isBlocked = profileData.is_blocked_chat;
        view.blocker = profileData.blocker;
        view.receiverAvatar = _avatar;
//        view.isChat = true;
        [_tabbar snapbackFlowerIconToTabbar];
        
        [self.tabBarController.tabBar setHidden:YES];
        
        view.hidesBottomBarWhenPushed = TRUE;
        
        [self.navigationController pushViewController:view animated:TRUE];
    } else {
        [_unlockChatContentLabel setText:[NSString stringWithFormat:NSLocalizedString(@"Just give me %ld more %@ and we can chat",nil),profileData.remain_flower, profileData.remain_flower > 1?NSLocalizedString(@"flowers",):NSLocalizedString(@"flower",nil)]];
        [_chatPopupView setHidden:NO];
        if(!isShowingChatPopup){
            isShowingChatPopup = TRUE;
            [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(removeUnLockChatPopup) userInfo:nil repeats:NO];
        }
    }
}


#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(currentIndex == 0)
        return listGallery.count;
    else
        return _achieveData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (currentIndex == 0) {
        NSString *identifier = @"ProfileRaceList";
        ProfileRaceListTableViewCell *cell = (ProfileRaceListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"ProfileRaceListTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.navigationController = self.navigationController;
        
        profile_gallery *temp = (profile_gallery *)[listGallery objectAtIndex:indexPath.row];
        
        NSMutableArray *photos = (NSMutableArray *)[listPostGallery objectForKey:temp.key];
        
        NSIndexPath *indexCell0 = [NSIndexPath indexPathForRow:indexPath.row * 10 inSection:0];
        NSIndexPath *indexCell1 = [NSIndexPath indexPathForRow:((indexPath.row * 10) +1) inSection:0];
        
        [self configureDraggableLocation:cell.draggableLocation makeCircle:NO];
        cell.draggableLocation.delegate = self;
        cell.draggableLocation.index = indexCell0;
        
        [_tabbar.draggableButton addAllowedDropLocation:cell.draggableLocation];
        [_listDraggableLocatioinList addObject:cell.draggableLocation];
        
        if(photos.count > 1)
        {
            
            [self configureDraggableLocation:cell.draggableLocation1 makeCircle:NO];
            cell.draggableLocation1.delegate = self;
            cell.draggableLocation1.index = indexCell1;
            
            [_tabbar.draggableButton addAllowedDropLocation:cell.draggableLocation1];
            [_listDraggableLocatioinList addObject:cell.draggableLocation1];
        }
        
        UILabel *tempLabel = [Support formatLabel:cell.raceName raceName:temp.name status:temp.status];
        cell.raceName.text = tempLabel.text;
        cell.status = temp.status;
        cell.key = temp.key;
        cell.uid = _uid;
        if(temp.name == nil)
            [cell.noPhotoView setHidden:NO];
        
        if (!cell.done && temp.name != nil) {
            //            [cell loadPhoto];
            [cell loadPhotosByArray:photos];
        }
        
        return cell;
    } else {
        NSString *identifier = @"ProfileAchievementList";
        ProfileAchievementsListTableViewCell *cell = (ProfileAchievementsListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"ProfileAchievementsListTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        }
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.preservesSuperviewLayoutMargins = false;
        cell.separatorInset = UIEdgeInsetsZero;
        cell.layoutMargins = UIEdgeInsetsZero;
        
        achievementObject* rankInfo = [_achieveData objectAtIndex:indexPath.row];
        
        if([rankInfo getKey] == 0)
        {
            [cell setUpType0:[rankInfo getName] rank:[rankInfo getData]];
            if(indexPath.row < _achieveData.count-1)
            {
                achievementObject* rankTempInfo = [_achieveData objectAtIndex:indexPath.row + 1];
                if([rankTempInfo getKey] != 0)
                {
                    cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
                }
            }
        }
        else if([rankInfo getKey] == 1)
        {
            [cell setUpType1:[rankInfo getName] flowers:[rankInfo getData]];
            cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
        }
        else if([rankInfo getKey] == 2)
        {
            [cell setUpType2:[rankInfo getName]];
            cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
        }
        else if([rankInfo getKey] == 3)
        {
            [cell setUpType3:[rankInfo getName]];
            cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
        }
        
        if (indexPath.row == _achieveData.count-1) {
            cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
        }
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (currentIndex == 0) {
        //        return 159.f;
        CGFloat screenDefaultHeight = 667; //For IP6,7,8
        CGFloat cellDefaultHeight = IS_IPHONE_X ? 140.f : 170.f;
        
        CGFloat ratio = cellDefaultHeight / screenDefaultHeight;
        CGFloat screenSize = [[UIScreen mainScreen] bounds].size.height;
        CGFloat heightCell = screenSize * ratio;
        return heightCell;
    } else {
        return 40.f;
    }
}

#pragma mark - More Functions
-(void) reloadTableByCurrentIndex{
    switch (currentIndex) {
        case 0:
        {
            [_albumsacheivementCollection[0] setSelected:YES];
            [_albumsacheivementCollection[1] setSelected:NO];
            
            [_topView setFrame:topFrame];
            [_bottomView setFrame:bottomFrame];
            
            [_rankView setHidden:TRUE];
            _tableView.tableHeaderView = _topView;
            [self loadDataBasedOnButtonIndex:0];
            break;
        }
        case 1:
        {
            [_albumsacheivementCollection[0] setSelected:NO];
            [_albumsacheivementCollection[1] setSelected:YES];
            
            CGRect topViewFrame = topFrame;
            topViewFrame.size.height = topFrame.size.height + 35;
            CGRect bottomViewFrame = bottomFrame;
            bottomViewFrame.size.height = bottomFrame.size.height + 35;
            [_topView setFrame:topViewFrame];
            [_bottomView setFrame:bottomViewFrame];
            
            [_rankView setHidden:FALSE];
            _tableView.tableHeaderView = _topView;
            [self loadDataBasedOnButtonIndex:3];
            break;
        }
        default:
            break;
    }
    
}

- (void)loadDataBasedOnButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self loadGallery];
            break;
        case 3:
            [self loadAchieveUsingAPI];
            break;
    }
}

#pragma mark - More Functions
-(void)removeUnLockChatPopup{
    [_chatPopupView setHidden:YES];
    [_ChatIcon setImage:[UIImage imageNamed:@"icon_chat_popup"]];
    _ChatLabel.textColor = UIColorFromRGB(0xACACAC);
    isShowingChatPopup = FALSE;
}

- (IBAction)Achievement:(id)sender {
    MembershipViewController *view = [[MembershipViewController alloc] init];
    userDefaultManager = [[UserDefaultManager alloc] init];
    view.isUserMembership = true;
    view.uid = self.uid;
    view.profileData = profileData;
    view.bronze = bronze;
    view.silver = silver;
    view.gold = gold;
    view.hidesBottomBarWhenPushed = true;
//    [self.tabBarController.tabBar setTranslucent:true];
    [self.tabBarController.tabBar setHidden:true];
    self.achievementButton.enabled = false;
    [self.navigationController pushViewController:view animated:true];
    self.achievementButton.enabled = true;
}


- (IBAction)TouchButtonWinner:(id)sender {
    if ([profileData.video_link isEqualToString:@""]) return;
    BrowserViewController *browserview = [[BrowserViewController alloc] initWithNibName:@"BrowserViewController" bundle:nil];
    browserview.urlString = profileData.video_link;
    browserview.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:browserview animated:true];
}
- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadGBS
{
    if(![profileData.gsb_medal isEqualToString:@""])
    {
        [self.GBSView setHidden:NO];
        if([profileData.gsb_medal isEqualToString:@"B"])
        {
            self.imageGBS.image = [UIImage imageNamed:NSLocalizedString(@"Icon_Flag_Bronze", )];
        }
        else if([profileData.gsb_medal isEqualToString:@"S"])
        {
            self.imageGBS.image = [UIImage imageNamed:NSLocalizedString(@"Icon_Flag_Silver", )];
        }
        else if([profileData.gsb_medal isEqualToString:@"G"])
        {
            self.imageGBS.image = [UIImage imageNamed:NSLocalizedString(@"Icon_Flag_Gold", )];
        }
    }
    else
    {
        [self.GBSView setHidden:YES];
    }
}

@end

