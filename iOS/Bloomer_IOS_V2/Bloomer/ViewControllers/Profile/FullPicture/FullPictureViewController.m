//
//  FullPictureViewController.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 3/16/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "FullPictureViewController.h"
#import "MyProfileViewController.h"
#import "AppDelegate.h"
#import "UILabel+Extension.h"
#import "UIColor+Extension.h"
#import "PhotosTaggedInRacesViewController.h"
#import "PhotoListViewController.h"

#define OBJECT_WIDTH 80.0f
#define OBJECT_HEIGHT 80.0f
#define MARGIN_VERTICAL 0.0f
#define MARGIN_HORIZONTAL 0.0f
#define DRAGGABLE_LOCATION_WIDTH  ((OBJECT_WIDTH  * 3) + (MARGIN_HORIZONTAL * 5))
#define DRAGGABLE_LOCATION_HEIGHT ((OBJECT_HEIGHT * 3) + (MARGIN_VERTICAL   * 5))
#define CELL_HEIGHT 60
#define TABLE_VIEW_HEIGHT 350
#define TABLE_VIEW_HEIGHT_IP4 265
#define CAPTION_MAX_HETGHT 100
#define COMMENT_DISPLAY_MAX 4

@interface FullPictureViewController ()
{
    UserDefaultManager *userDefaultManager;
    out_profile_fetch *profileData;
    NSInteger nFlower;
    CGFloat tableViewHeight;
    Spinner *spinner;
    CGFloat lastContentOffset;
    NSString *lastPostID;
    FriendsUpdatePopupView *popup;
    NSInteger userID;
    FlowerMenuPostPopupViewController *flowerPopup;
    BOOL isFollowing;
    UIAlertView *unF;
    NSString* displayName;
    BOOL didGiveFlower;
    BOOL isAvatar;
    NumberGiveFlowerPopUp * numberGiveFlowerPopUp;
}

@end

@implementation FullPictureViewController

@synthesize circularMenu, thankyou, flowerIcon;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    profileData = [userDefaultManager getUserProfileData];
    _imagePhotoAPI = [[image_photo alloc] init];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentTableViewCell" bundle:nil] forCellReuseIdentifier:CommentTableViewCell.cellIdentifier];
    
    [self initView];
    numberGiveFlowerPopUp = [[NumberGiveFlowerPopUp alloc] initWithFrame:[[UIScreen mainScreen ] bounds]];
    
    tableViewHeight = _tableView.frame.size.height;
    _tabbar = appDelegate.tabbar;
    lastPostID = @"";
    didGiveFlower = false;
    
    for (UIView *view in [[[UIApplication sharedApplication] delegate] window].subviews) {
        if ([view isKindOfClass:[MKNumberBadgeView class]])
        {
            _badgeNumber = (MKNumberBadgeView *)view;
            break;
        }
    }
    
    spinner = ((AppDelegate*)[UIApplication sharedApplication].delegate).spinner;
    
    [self configureDraggableLocation:_draggableLocation makeCircle:FALSE];
    _draggableLocation.delegate = self;
    [_tabbar.draggableButton addAllowedDropLocation:_draggableLocation];
    
    [_pictureScrollView setScrollEnabled:_isScrollingEnabled];
    
    _tableView.allowsMultipleSelectionDuringEditing = NO;
    _tableView.allowsSelection = FALSE;
    _tableView.alwaysBounceVertical = TRUE;
    _tableView.bounces = TRUE;
    
    __weak FullPictureViewController *weakSelf = self;
    [_tableView addPullToRefreshWithActionHandler:^{
        FullPictureViewController *strongSelf = weakSelf;
        if (strongSelf)
        {
            [strongSelf handlePullToRefresh];
        }
    }];
    
    
    // Set underline for button comments
    [self.buttonViewComments setTitle:[AppHelper getLocalizedString:@"View more comments ..."]
                             forState:UIControlStateNormal];
    [AppHelper setButtonWithUnderlineTitle:self.buttonViewComments textColor:UIColor.blackColor fontSize:14];
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    
    [self loadContentPost:_post_id];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    profileData = [userDefaultManager getUserProfileData];
    [_tabbar updateFlowerValue];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_tabbar.draggableButton removeAllAllowedDropLocations ];
    if (![_tabbar.draggableButton.droppableLocations containsObject:_draggableLocation])
    {
        [_tabbar.draggableButton addAllowedDropLocation:_draggableLocation];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (circularMenu != nil) {
        [circularMenu removeFromSuperview];
    }
    [_tabbar.draggableButton removeAllowedDropLocation:_draggableLocation];
    
}

// MARK: - Functions

- (void)initView
{
    self.avatar.layer.cornerRadius = self.avatar.frame.size.height / 2;
    self.avatar.layer.borderWidth = 2;
    self.avatar.layer.borderColor = [UIColor colorFromHexString:@"#E4E4E4"].CGColor;
    self.avatar.clipsToBounds = TRUE;
    
    self.buttonRaceTags.layer.cornerRadius = self.buttonRaceTags.frame.size.height / 2;
    self.buttonRaceTags.clipsToBounds = TRUE;
}

- (void)reloadComments
{
    if (self.commentData.count >= COMMENT_DISPLAY_MAX)
    {
        self.bottomView.hidden = FALSE;
    }
    else
    {
        self.bottomView.hidden = TRUE;
    }
    
    [self.tableView reloadData];
}

#pragma mark - Inititalize

- (void)initNavigationBarWithTitle:(NSString*)name
{
    UILabel *nameTitleView = [[UILabel alloc] init];
    self.navigationItem.titleView = nameTitleView;
    nameTitleView.backgroundColor = [UIColor clearColor];
    nameTitleView.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:16];
    nameTitleView.textColor = [UIColor whiteColor];
    nameTitleView.text = name;
    [nameTitleView sizeToFit];
    nameTitleView.center = CGPointMake(self.navigationController.navigationBar.frame.size.width/2, self.navigationController.navigationBar.frame.size.height/2);
}

- (void)loadProfileUsingAPI
{
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
    
    API_ProfileFetch * api = [[API_ProfileFetch alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] andUserId:[NSString stringWithFormat:@"%ld", (long)userID]];
    [api getRequest:^(BaseJSON * json, RestfulResponse * objStatus) {
        if (objStatus.status)
        {
            [_BlockedView setHidden:TRUE];
            [_commentButton setHidden:false];
        }
        else
        {
            [self.StickerSadImage setImage:[UIImage imageNamed:@"sticker_109"]];
            self.ContentBlockedView.text = [AppHelper getLocalizedString:@"FullPictureViewContentBlock.Title"];
            [_BlockedView setHidden:FALSE];
            if(objStatus.code == 415)
            {
                [_commentButton setHidden:true];
            }else{
                [_commentButton setHidden:false];
            }
            
        }
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    } ErrorHandlure:^(NSError * error) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];
}


- (void)loadContentView:(out_content_post*)data
{
    userID = data.uid;
    
    isAvatar = data.is_avatar;
    
    self.labelName.text = data.name;
    self.labelUsername.text = data.username;
    self.labelCaption.text = data.caption;
    
    [_avatar setImageWithURL:[NSURL URLWithString:data.avatar]];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:data.timestamp / 1000];
    [self.buttonMore setTitle:[date timeAgo] forState:UIControlStateNormal];
    
    NSString* tagList=@"";
    for (NSString* tag in data.tags)
    {
        tagList = [tagList stringByAppendingString:tag];
    }
    
    [self.buttonRaceTags setTitle:tagList forState:UIControlStateNormal];
    self.raceName = tagList;
    
    isFollowing = data.is_follow;
    
    [self.topView layoutIfNeeded];
    
    if (data.is_share)
    {
        self.buttonShare.enabled = true;
    }
    else
    {
        self.buttonShare.enabled = false;
    }
    
    [self.buttonSponsor setUserInteractionEnabled:data.flower > 0];
    
    if (data.mygiveflower > 0)
    {
        [self.labelFlower setTextColor:[UIColor colorFromHexString:@"#B22225"]];
        [self.labelFlower setFlowers:data.flower];
        
        //Update NumberFlowerPopup
        [numberGiveFlowerPopUp bindDataWithProfile:profileData Content:data];
        
        self.iconGivedFlowerPhoto.hidden = false;
        didGiveFlower = true;
    }
    else
    {
        if (data.uid == profileData.uid)
        {
            if(data.flower == 0) {
                [self.labelFlower setTextColor:[UIColor colorFromHexString:@"#6B6B6B"]];
                [self.labelFlower setFlowers:data.flower imageString:@"Icon_Flower_Black"];
            } else {
                [self.labelFlower setTextColor:[UIColor colorFromHexString:@"#B22225"]];
                [self.labelFlower setFlowers:data.flower];
            }
        }
        else
        {
            [self.labelFlower setTextColor:[UIColor colorFromHexString:@"#6B6B6B"]];
            [self.labelFlower setFlowers:data.flower imageString:@"Icon_Flower_Black"];
        }
        
        self.iconGivedFlowerPhoto.hidden = true;
        didGiveFlower = false;
    }
    
    CGRect topViewFrame = self.topView.frame;
    topViewFrame.size.height = self.actionView.frame.origin.y + self.actionView.frame.size.height;
    self.topView.frame = topViewFrame;
    self.tableView.tableHeaderView = self.topView;
    
    [self.commentData removeAllObjects];
    self.commentData = [[NSMutableArray alloc] init];
    if (data.list) {
        [data.list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx >= 3) {
                *stop = YES;
                return ;
            }
            if (obj) {
                [self.commentData addObject:obj];
            }
        }];
    }
    
    if (data.size >= COMMENT_DISPLAY_MAX)
    {
        self.bottomView.hidden = FALSE;
    }
    else
    {
        self.bottomView.hidden = TRUE;
    }
    
    [self.tableView reloadData];
    [self loadProfileUsingAPI];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([[touch view] isKindOfClass:[AwesomeMenuItem class]])
    {
        return NO;
    }
    else
    {
        if (circularMenu != nil && [circularMenu superview] == _pictureView)
        {
            [circularMenu removeFromSuperview];
            [flowerIcon removeFromSuperview];
            
        }
        
        return YES;
    }
}

#pragma mark - Giving Flower

- (void) draggableLocation:(SEDraggableLocation *)location didRefuseObject:(SEDraggable *)object entryMethod:(SEDraggableLocationEntryMethod)method
{
    [object setHidden:true];
    if (circularMenu != nil)
    {
        [circularMenu removeFromSuperview];
        [flowerIcon removeFromSuperview];
    }
    
    circularMenu = [self createCircularMenuWithFrame:_draggableLocation.bounds];
    circularMenu.startPoint = self.pictureView.center;
    circularMenu.delegate = self;
    circularMenu.menuWholeAngle = 2.5f;
    circularMenu.farRadius = 60.0f;
    circularMenu.endRadius = 50.0f;
    circularMenu.nearRadius = 40.0f;
    circularMenu.animationDuration = 0.7f;
    circularMenu.rotateAngle = 5.04f;
    [circularMenu setExpanding:YES];
    
    [self.pictureView addSubview:circularMenu];
}

- (void) configureDraggableLocation:(SEDraggableLocation *)draggableLocation makeCircle:(BOOL)isCircle {
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
    draggableLocation.highlightColor = [UIColor redColor].CGColor;
    if (isCircle)
    {
        draggableLocation.layer.cornerRadius = draggableLocation.frame.size.width / 2;
    }
    
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
    UIImage *backgroundImage1 = [UIImage imageNamed:@"GivingFlowers_1"];
    UIImage *highlightedBackgroundImage1 = [UIImage imageNamed:@"GivingFlowers_1"];
    UIImage *backgroundImage10 = [UIImage imageNamed:@"GivingFlowers_10"];
    UIImage *highlightedBackgroundImage10 = [UIImage imageNamed:@"GivingFlowers_10"];
    UIImage *backgroundImage100 = [UIImage imageNamed:@"GivingFlowers_100"];
    UIImage *highlightedBackgroundImage100 = [UIImage imageNamed:@"GivingFlowers_100"];
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
                                      initWithImage:[UIImage imageNamed:@"GivingFlowers_..."]
                                      highlightedImage:[UIImage imageNamed:@"GivingFlowers_..."]
                                      text:@""];
    NSArray *menus = [NSArray arrayWithObjects:flowerButton1, flowerButton2, flowerButton3, flowerButton4, nil];
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"GivingFlower_Store"]
                                                       highlightedImage:[UIImage imageNamed:@"GivingFlower_Store"]
                                                                   text:@""];
    
    AwesomeMenu *resultMenu = [[AwesomeMenu alloc] initWithFrame:frame startItem:startItem optionMenus:menus isCell:FALSE];
    
    return resultMenu;
    
}

- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    [menu removeFromSuperview];
    [flowerIcon removeFromSuperview];
    
    [self CreateThankYouView:self.pictureView.frame.origin];
    
    face* temp = (face*)[_faceData objectAtIndex:_currentIndex];
    
    if (idx < 3 && idx > -1) {
        nFlower = 0;
        switch (idx) {
            case 0:
                nFlower = FIRST_FLOWER_BUTTON_VALUE;
                break;
            case 1:
                nFlower = SECOND_FLOWER_BUTTON_VALUE;
                break;
            case 2:
                nFlower = THIRD_FLOWER_BUTTON_VALUE;
                break;
        }
        [self giveFlowerPost:nFlower];
    } else {
        if (idx == 3) {
            flowerPopup = [[FlowerMenuPostPopupViewController alloc] initWithNibName:@"FlowerMenuPopUpViewController" bundle:nil];
            flowerPopup.postID = temp.post_id;
            flowerPopup.parentView = self;
            //flowerPopup.faceData = temp;
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

- (void)processAfterGivingFlower:(out_flower_give *)data {
    profileData.your_num_flower = data.mFlower;
    [userDefaultManager saveUserProfileData:profileData];
    [_tabbar updateFlowerValue];
    
    [self AddThankYouView];
    [self loadContentPost: self.post_id];
    
    if (data.bonus_flower > 0)
    {
        [AppHelper showMatchingFlowerPopUp:data.bonus_flower];
    }
}

- (void)CreateThankYouView:(CGPoint)point
{
    [thankyou removeFromSuperview];
    if(thankyou){
        [thankyou repositionToPoint:point];
    } else {
        
        thankyou = [[ThankYou alloc] initWithStyle:ThankYouStyleForCollectionViewCell atPoint:point frame:self.pictureView.frame];
    }
}

- (void)AddThankYouView
{
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(removeThankYou) userInfo:nil repeats:NO];
    [_tableView addSubview:thankyou];
}

// MARK: - Actions

- (IBAction)touchAvatarButton:(id)sender {
    
    if (profileData.uid != userID)
    {
        UserProfileViewController *view = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
        view.uid = userID;
        
        [self.navigationController pushViewController:view animated:TRUE];
    }
    else
    {
        [AppDelegate setSelectedIndexTabbar:4];
    }
}

- (IBAction)touchCommentButton:(id)sender {
    [self goToCommentViewController];
}

- (IBAction)touchViewAllCommentsButton:(id)sender {
    [self goToCommentViewController];
}

- (IBAction)touchRace:(id)sender {
    //    PhotosTaggedInRacesViewController *view = [[PhotosTaggedInRacesViewController alloc] initWithNibName:@"PhotosTaggedInRacesViewController" bundle:nil];
    //    [self.navigationController pushViewController:view animated:TRUE];
}

- (IBAction)touchReport:(id)sender
{
    if (self.imageView.image != NULL)
    {
        BOOL isMe;
        
        if (userID == profileData.uid)
        {
            isMe = TRUE;
        }
        else
        {
            isMe = FALSE;
        }
        
        popup = [FriendsUpdatePopupView createInView:[[[UIApplication sharedApplication] delegate] window]];
        popup.distance = self.navigationController.navigationBar.frame.size.height + self.buttonMore.frame.size.height;
        popup.delegate = self;
        popup.post_id = self.post_id;
        popup.isMe = isMe;
        popup.parentView = self;
//        popup.following = isFollowing;
        popup.picture = self.imageView.image;
        popup.caption = self.labelCaption.text;
        popup.parentView = self;
        popup.isAvatar = isAvatar;
        [popup showWithAnimated:true];
    }
}

- (IBAction)TouchPictureView:(id)sender
{
    if (self.content_post.photo_url_full && ![self.content_post.photo_url_full isEqualToString:@""])
    {

        FullScreensViewController *view = [[FullScreensViewController alloc]initWithNibName:@"FullScreensViewController" bundle:nil];
        view.modalPresentationCapturesStatusBarAppearance = FALSE;
        view.parentView = self;
        view.photo = self.imageView.image;
        view.strURL = self.content_post.photo_url_full;
        view.galerryData = self.galleryData;
        view.currentIndex = self.currentIndex;
        view.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        UIViewController *previousViewController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
        if ([previousViewController isKindOfClass:[PhotosTaggedInRacesViewController class]])
        {
            view.isMultiple = false;
        }
        else
        {
            view.isMultiple = true;
        }
        
        [self presentViewController:view animated:TRUE completion:nil];
       
    }
}

- (IBAction)touchFlower:(id)sender
{
    if (userID == profileData.uid)
    {
        FlowerGiverViewController *view = [[FlowerGiverViewController alloc] init];
        view.notificationKey = @"";
        view.post_id = _post_id;
        view.userID = userID;
        view.hidesBottomBarWhenPushed = true;
        
        [self.navigationController pushViewController:view animated:YES];
    }
    else
    {
        if (didGiveFlower)
        {
            CGRect position = [self.buttonSponsor convertRect:self.buttonSponsor.bounds toView:[[UIApplication sharedApplication] keyWindow]];
            [numberGiveFlowerPopUp showAnimateFromYOffset:position.origin.y];
        }
    }
}

- (IBAction)touchShareButton:(id)sender
{
    if (self.imageView.image != NULL)
    {
        if(![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fbauth2://"]]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Install and log in to Facebook to enable sharing pictures.", ) delegate:nil cancelButtonTitle:NSLocalizedString(@"Alert.TryAgain", ) otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
        
        photo.image = self.imageView.image;
        photo.userGenerated = YES;
        FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
        content.photos = @[photo];
        
        FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
        dialog.delegate = self;
        dialog.fromViewController = self;
        dialog.shareContent = content;
        dialog.mode = FBSDKShareDialogModeAutomatic;
        
        [dialog show];
    }
}

- (void)touchUnFollow {
    unF = [[UIAlertView alloc] initWithTitle:nil
                                     message:NSLocalizedString(@"Are you sure you want to unfollow this user?",nil)
                                    delegate:self
                           cancelButtonTitle:NSLocalizedString(@"No",nil)
                           otherButtonTitles:NSLocalizedString(@"Yes",nil), nil];
    [unF show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == unF) {
        if (buttonIndex == 1) {
            block_remove *param = [[block_remove alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] uid:userID];
            if (param) {
                API_UnFollow *api = [[API_UnFollow alloc] initWithParams:param];
                [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                    if (response.status)
                    {
                        [AppHelper showMessageBox:nil message:NSLocalizedString(@"InfoUsersSuccessFollow.title",nil)];
                        [self loadContentPost:_post_id];
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

- (void)removeThankYou
{
    [thankyou removeFromSuperview];
}

// MARK: - UITableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell = (CommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CommentTableViewCell.cellIdentifier];
    
    comment *temp = (comment *)[self.commentData objectAtIndex:indexPath.row];
    
    cell.labelContent.text = temp.content;
    cell.labelName.text = temp.name;
    cell.labelUsername.text = temp.username;
    [cell.avatar setImageWithURL:[NSURL URLWithString:temp.avatar]];
    
    cell.uid = temp.uid;
    cell.navigationController = self.navigationController;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CommentTableViewCell.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    face *faceTemp = (face *)[_faceData objectAtIndex:_currentIndex];
    
    if (faceTemp.uid == profileData.uid)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - Slidable Post-scrollview

- (void)initPhotoScrollViewWithData:(out_content_post *) content;
{
    gallery *temp = (gallery *)[self.galleryData objectAtIndex:_currentIndex];
    temp.photo_url = content.photo_url;
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.pictureScrollView.bounds];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [_pictureScrollView addSubview:self.imageView];
    [self.imageView setImageWithURL:[NSURL URLWithString:temp.photo_url] placeholderImage: nil];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:temp.photo_url]];
    __weak UIImageView *weakImageView = self.imageView;
    __weak FullPictureViewController *weakSelf = self;
    [self.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakImageView.contentMode = UIViewContentModeScaleAspectFill;
        weakImageView.clipsToBounds = TRUE;
        weakImageView.userInteractionEnabled = true;
        weakImageView.image = image;

        UIGestureRecognizer *tapPhotoRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:weakSelf action:@selector(TouchPictureView:)];
        [weakImageView addGestureRecognizer:tapPhotoRecognizer];

        [weakSelf.pictureScrollView addSubview:weakImageView];

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {

    }];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    _pictureScrollView.userInteractionEnabled = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender
{
    if ((int)_pictureScrollView.contentOffset.x % 320 == 0)
    {
        if (_pictureScrollView.contentOffset.x > lastContentOffset)
        {
            _currentIndex++;
            
            [_sponsorData removeAllObjects];
            [self.commentData removeAllObjects];
            _sponsorData = nil;
            self.commentData = nil;
            _post_id = [[self.galleryData objectAtIndex:_currentIndex] post_id];
            
            [self loadContentPost];
        }
        else
            if (_pictureScrollView.contentOffset.x < lastContentOffset)
            {
                _currentIndex--;
                
                [_sponsorData removeAllObjects];
                [self.commentData removeAllObjects];
                _sponsorData = nil;
                self.commentData = nil;
                _post_id = [[self.galleryData objectAtIndex:_currentIndex] post_id];
                
                [self loadContentPost];
            }
        
        lastContentOffset = _pictureScrollView.contentOffset.x;
    }
    
    if (_post_id != lastPostID)
    {
        lastPostID = _post_id;
    }
    
    _pictureScrollView.userInteractionEnabled = YES;
}

- (void)goToCommentViewController
{
    CommentViewController *view = [[CommentViewController alloc] initWithNibName:@"CommentViewController" bundle:nil];
    view.parentView = self;
    view.hidesBottomBarWhenPushed = true;
    view.post_id = _post_id;
    view.displayName = self.labelName.text;
    view.postCaption = self.labelCaption.text;
    view.post_UserID = userID;
    
    [self.navigationController pushViewController:view animated:true];
}

- (void)updateFlowerInParentView:(long long)model_nflower
{
    UIViewController* parentView = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    
    if ([parentView isKindOfClass:[MyProfileViewController class]])
    {
        MyProfileViewController *view = (MyProfileViewController*)parentView;
        //        view.flowerValue.text = @(model_nflower).stringValue;
        [view.tableView reloadData];
    }
    else
        if ([parentView isKindOfClass:[UserProfileViewController class]])
        {
            UserProfileViewController *view = (UserProfileViewController*)parentView;
            //            view.flowerValue.text = @(model_nflower).stringValue; VL
            [view.tableView reloadData];
        }
        else
        {
            UINavigationController *navigationController = [self.tabBarController.viewControllers objectAtIndex:1];
            MyProfileViewController *view = (MyProfileViewController*)[navigationController.viewControllers firstObject];
            //            view.flowerValue.text = @(model_nflower).stringValue;
            [view loadDataBasedOnButtonIndex:0];
        }
}

- (void)updateInfoInParentView
{
//    UIViewController* parentView = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    
    /*if ([self.parentView isKindOfClass:[MyProfileViewController class]])
    {
        MyProfileViewController *view = (MyProfileViewController*)self.parentView;
        [view.tableView reloadData];
    }
    else if ([self.parentView isKindOfClass:[UserProfileViewController class]])
    {
        UserProfileViewController *view = (UserProfileViewController*)self.parentView;
        [view.tableView reloadData];
    }
    else*/ if([self.parentView isKindOfClass:[PhotoListViewController class]]) {
        PhotoListViewController *view = (PhotoListViewController*)self.parentView;
        [view pullToRefresh];
    }
}

- (void)handlePullToRefresh
{
    [self loadContentPost];
    
    [_tableView.pullToRefreshView stopAnimating];
}

#pragma mark - APIs function

- (void)loadContentPost {
    API_Content_Post_Fetches *api = [[API_Content_Post_Fetches alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] post_id:self.post_id];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        out_content_post * data = (out_content_post *) jsonObject;
        self.content_post = data;
        if (response.status)
        {
            if(displayName == nil)
            {
                displayName = data.name;
                [self initNavigationBarWithTitle:displayName];
            }
            [self initPhotoScrollViewWithData:data];
            [self loadContentView:data];
            
            [self updateInfoInParentView];
        }
        else
        {
            [AppHelper showMessageBox:nil message:response.message];
        }
    } ErrorHandlure:^(NSError *error) {
        
    }];
    
}

- (void)loadContentPost:(NSString *)post_id {
    API_Content_Post_Fetches *api = [[API_Content_Post_Fetches alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] post_id:post_id];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        out_content_post * data = (out_content_post *) jsonObject;
        self.content_post = data;
        if (response.status)
        {
            if(displayName == nil)
            {
                displayName = data.name;
                [self initNavigationBarWithTitle:displayName];
            }
            [self initPhotoScrollViewWithData:data];
            [self loadContentView:data];
            
            [self updateInfoInParentView];
        }
        else
        {
            [AppHelper showMessageBox:nil message:response.message];
        }
    } ErrorHandlure:^(NSError *error) {
        
    }];
}

- (void)giveFlowerPost:(long long)flower {
    flower_give_post *params = [[flower_give_post alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] num_flower:flower postID:_post_id];
    if (params) {
        API_Flower_GivePost *api = [[API_Flower_GivePost alloc] initWithParams:params];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            out_flower_give * data = (out_flower_give *) jsonObject;
            if (response.status)
            {
                [userDefaultManager didTutorialGiveFlowerRace:TRUE];
                [self processAfterGivingFlower:data];
                [data showFlowerGivingPopupIn:[UIApplication sharedApplication].keyWindow];
            }
            else
            {
                [AppHelper showMessageBox:nil message:response.message];
            }
        } ErrorHandlure:^(NSError *error) {
            
        }];
    }
    
}

// MARK: - FriendsUpdatePopupViewDelegate
- (void)touchDeletePostWith:(NSString *)postID{
    if([self.parentView isKindOfClass:[PhotosTaggedInRacesViewController class]]) {
        PhotosTaggedInRacesViewController *vc = (PhotosTaggedInRacesViewController*)self.parentView;
        [vc reloadGallery];
        [self.navigationController popViewControllerAnimated:true];
        return;
    }
    
    PhotoListViewController *photoList = (PhotoListViewController*)self.parentView;

    for (NSInteger i = 0; i < photoList.postsData.count; i++)
    {
        out_content_post *postData = (out_content_post*)[photoList.postsData objectAtIndex:i];
        if ([postData.post_id isEqualToString:postID])
        {
            [photoList.postsData removeObject:postData];
            [photoList.tableView reloadData];
            
            if (photoList.postsData.count == 0){
                for (UIViewController * vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[MyProfileViewController class]]) {
                        MyProfileViewController * myProfileVC = (MyProfileViewController *) vc;
                        [myProfileVC loadGallery]; //Reload MyProfileViewController gallery races
                        [self.navigationController popToViewController:myProfileVC animated:YES];
                    }
                }
            }else{
                [self.navigationController popViewControllerAnimated:true];
            }
            
            break;
        }
    }
    
}

// MARK: - FBSDKSharingDelegate

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    NSLog(@"error : %@", error);
}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    API_ShareFacebook* api = [[API_ShareFacebook alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] isPopup:NO];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        Json_ShareFacebook * data = (Json_ShareFacebook *) jsonObject;
        profileData.your_num_flower += data.flower;
        [userDefaultManager saveUserProfileData:profileData];
    } ErrorHandlure:^(NSError *error) {
        
    }];
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
    
}

@end
