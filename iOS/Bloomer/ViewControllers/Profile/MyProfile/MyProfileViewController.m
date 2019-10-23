//
//  MyProfileViewController.m
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 3/20/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//
#define WIDTH_SCREEN [[UIScreen mainScreen] bounds].size.width
#define HEIGHT_SCREEN [[UIScreen mainScreen] bounds].size.height
#define AVATAR_WIDTH 90
#define OBJECT_WIDTH 80.0f
#define OBJECT_HEIGHT 80.0f
#define MARGIN_VERTICAL 0.0f
#define MARGIN_HORIZONTAL 0.0f
#define DRAGGABLE_LOCATION_WIDTH  ((OBJECT_WIDTH  * 3) + (MARGIN_HORIZONTAL * 5))
#define DRAGGABLE_LOCATION_HEIGHT ((OBJECT_HEIGHT * 3) + (MARGIN_VERTICAL   * 5))
#define OPEN_ACHIEVE_TITTLE 1 // Tittle with
#define CLOSE_ACHIEVE_TITTLE 2 // tittle with link
#define CLOSE_LOCK_ACHIEVE_TITTLE 3 //lock tittle with link
#define NORMAL_ACHIEVE 0
#define UPLOAD_AVATAR_REMINDER_DEFAULT_HEIGHT 100
#define TOPVIEW_DEFAULT_HEIGHT 464

#import "MyProfileViewController.h"
#import "AppHelper.h"
#import "AppDelegate.h"
#import "POP.h"
#import "UIColor+Extension.h"
#import "MySettingViewController.h"
#import "PhotoGalleryViewController.h"
#import "AchievementViewController.h"
#import "UpdatePhoneNumberViewController.h"
#import "NotificationHelper.h"
#import "ChangeAvatarViewController.h"

@interface MyProfileViewController ()
{
    UserDefaultManager *userDefaultManager;
    Spinner *spinner;
    FlowerMenuPopUpViewController *popup;
    FlowerMenuPostPopupViewController *postPopup;
    ImagePickerPopUpViewController *imagePickerPopup;
    RemindInviteCode * remindInvitePopup;
    int loadedItemIndex;
    NSString *postID;
    NSString *lastPostID;
    int flower;
    int tagNumber;
    UIImageView *thankyou;
    NSInteger offset;
    NSInteger pageIndex;
    CGFloat slideshowLastContentOffset;
    CGFloat scrollViewLastContentOffset;
    BOOL scroll;
    BOOL avoidFirstScroll;
    BOOL isTabBarHidden;
    BOOL isTouched;
    BOOL isTouched_Chat;
    BOOL isGrid;
    NSInteger currentIndex;
    NSInteger galleryIndex;
    NSIndexPath *draggedCellIndex;
    NSInteger index;
    BOOL isGiveUser;
//    CGFloat topViewHeight;
    BOOL activeRaces;
    NSTimer *timer;
    NSTimer *bellSwingTimer;
    NSMutableArray *closeDays;
    BOOL giveFlower;
    CGRect bottomFrame;
    CGRect topFrame;
    NSMutableArray *listGallery;
    NSMutableDictionary *listPostGallery;
    
    NSMutableArray* avatarList;
    ChangeStatusPopUpViewController* changeStatusPop;
    NSMutableArray* viewArray;
    UIImage *chosenImage;
    UIView *notiButtonView;
    UIButton *notiButton;
    
    NSInteger bronze;
    NSInteger silver;
    NSInteger gold;
}

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *albumsacheivementCollection;
@property (assign, nonatomic) BOOL isUpdateMobile;
@property (strong,nonatomic) ChatListViewController * chatListVC;

@end

@implementation MyProfileViewController

@synthesize images, profileData, circularMenu, showbottom;

- (void)dealloc {
    NSLog(@"MyProfileViewController dealloc");
    [bellSwingTimer invalidate];
    bellSwingTimer = nil;
}

#pragma mark - View functions

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isUpdateMobile = true;
    activeRaces = true;
    showbottom = true;
    loadedItemIndex = 0;
    postID = @"";
    lastPostID = @"";
    tagNumber = 0;
    giveFlower = false;
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    profileData = [userDefaultManager getUserProfileData];

    closeDays = [[NSMutableArray alloc] init];
    listGallery = [[NSMutableArray alloc] init];
    listPostGallery = [[NSMutableDictionary alloc]init];
    
    for (UIView *view in [[[UIApplication sharedApplication] delegate] window].subviews) {
        if ([view isKindOfClass:[TabBarView class]])
        {
            _tabbar = (TabBarView *)view;
            break;
        }
    }
    
    for (UIView *view in [[[UIApplication sharedApplication] delegate] window].subviews) {
        if ([view isKindOfClass:[MKNumberBadgeView class]])
        {
            _badgeNumber = (MKNumberBadgeView*)view;
            break;
        }
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ProfileRaceListTableViewCell" bundle:nil]
         forCellReuseIdentifier:[ProfileRaceListTableViewCell cellIdentifier]];
    
    changeStatusPop = [[ChangeStatusPopUpViewController alloc] initWithNibName:@"ChangeStatusPopUpViewController" bundle:nil];
    
    _EditBanner.layer.cornerRadius = _EditBanner.frame.size.height /2;
    _EditBanner.layer.masksToBounds = TRUE;
    
    _chatNotiNumber.layer.cornerRadius = _chatNotiNumber.frame.size.height /2;
    _chatNotiNumber.layer.masksToBounds = TRUE;
    
    _rewardNotiBubble.layer.cornerRadius = _rewardNotiBubble.frame.size.height /2;
    _rewardNotiBubble.layer.masksToBounds = TRUE;
    
    _updateInfoButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    //_segmentControl.clipsToBounds = TRUE;
    //_segmentControl.layer.cornerRadius = 15;
    
    currentIndex = 0;
    galleryIndex = 0;
    isGrid = TRUE;
    
    _thumbDraggableLocatioinList = [[NSMutableArray alloc] init];
    _listDraggableLocatioinList = [[NSMutableArray alloc] init];
    
    [self initNavigationBar];
    
    spinner = ((AppDelegate*)[UIApplication sharedApplication].delegate).spinner;
    
    __weak MyProfileViewController *weakSelf = self;
    
    [_tableView addPullToRefreshWithActionHandler:^{
        MyProfileViewController *strongSelf = weakSelf;
        if (strongSelf)
        {
            [strongSelf pullToRefresh];
        }
    }];
    
//    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
//    [_tableView setSeparatorColor: UIColorFromRGB(0xd2d2d2)];
    
    [_tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf infiniteScrolling];
    }];
    
    if([NSLocalizedString(@"EN", ) isEqualToString:@"EN"])
    {
        _WidthContrainBanner.constant = 100;
    }
    else
    {
        _WidthContrainBanner.constant = 135;
    }
    
    self.uploadAvatarReminderButton.layer.cornerRadius = self.uploadAvatarReminderButton.frame.size.height / 2;
    self.uploadAvatarReminderButton.clipsToBounds = true;
//    self.updatePhoneReminderButton.layer.cornerRadius = self.updatePhoneReminderButton.frame.size.height / 2;
    
    self.achievementButton.enabled = false;
//    [self loadMembershipAPI];
    [self pullToRefresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAboutMe:) name:[NotificationNames UpdateAboutMe] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProfileName:) name:[NotificationNames UpdateProfileName] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProfileUsername:) name:[NotificationNames UpdateProfileUsername] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotiloadProfileMeUsingAPI) name:[NotificationNames UpdateNumberPhone] object:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self initLayoutProfile];
    viewArray = [[NSMutableArray alloc] initWithObjects:_TopViewImage, _FlowerNumberView, _LineView, _ButtonView, _StatusView, nil];
    
//    [self alignBellIconToTheLeftForiOS11];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_tabbar updateFlowerValue];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self pullToRefresh];
    
    [AppHelper changeNavigationBarToRed:self.navigationController];
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:appDelegate.chatBadgeNumber];
    
    [self updateNumbersNoti];
//    [self alignBellIconToTheLeftForiOS11];
    
    NSString* medalKey = [userDefaultManager getMedalKey];
    [_rewardNotiBubble setHidden:[medalKey isEqualToString:@""]];
    
    [self.navigationController setNavigationBarHidden:FALSE];
    [self setupLanguage];
    
    [self updateNotificationNumber];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.chatBadgeNumber removeFromSuperview];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.view endEditing:YES];
}

- (void)setupLanguage
{
    _ChatLabel.text = @"Chat";
    _swipeToViewMore.text = NSLocalizedString(@"SwipeLabelLeaderBoard.title", );
    _TakePhotoLabel.text = NSLocalizedString(@"MyProfile.UploadPhoto", );
    _Achievementlabel.text = NSLocalizedString(@"AchievementName.title", );
    _FlowerShopLabel.text = NSLocalizedString(@"FlowerShopName.Title", );
    [_changeBanner setTitle:NSLocalizedString(@"Editbanner.title", ) forState:UIControlStateNormal];
}

- (void)updateNotificationNumber
{
    NSInteger chatNotificatioNumber = [userDefaultManager getChatNotificationNumber];
    if(chatNotificatioNumber > 0)
    {
        [_chatNotiNumber setHidden:FALSE];
        _chatNotiNumber.text = [@(chatNotificatioNumber) stringValue];
    }
    else{
        [_chatNotiNumber setHidden:TRUE];
    }
}

- (void)switchReminderView:(BOOL)isUpdateMobile
{
    if (isUpdateMobile)
    {
        self.uploadAvatarReminderTitleLabel.text = [AppHelper getLocalizedString:@"UpdateMobileReminder.titleLabel"];
        self.uploadAvatarReminderDescriptionLabel.text = [AppHelper getLocalizedString:@"UpdateMobileReminder.descriptionLabel"];
        [self.uploadAvatarReminderButton setTitle:[AppHelper getLocalizedString:@"UpdateMobileReminder.updateMobileButton"] forState:UIControlStateNormal];
    }
    else
    {
        self.uploadAvatarReminderTitleLabel.text = [AppHelper getLocalizedString:@"AvatarReminder.title"];
        self.uploadAvatarReminderDescriptionLabel.text = [AppHelper getLocalizedString:@"AvatarReminder.desc"];
        [self.uploadAvatarReminderButton setTitle:[AppHelper getLocalizedString:@"AvatarReminder.UploadPic"] forState:UIControlStateNormal];
    }
    
    self.isUpdateMobile = isUpdateMobile;
}

- (void) showRemindInviteCodePopUpWith:(long) inviteFlowerNumb{
    remindInvitePopup = [[RemindInviteCode alloc] initWithNibName:@"RemindInviteCode" bundle:nil];
    remindInvitePopup.navigationController = self.navigationController;
    remindInvitePopup.inviteFlowerNumb = inviteFlowerNumb;
    [remindInvitePopup showInView:[[UIApplication sharedApplication] keyWindow] animated:YES];
}


#pragma mark - Initialize Functions

- (void)initNavigationBar
{
    // init chat View;
    [self updateNotificationNumber];
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings"] style:UIBarButtonItemStylePlain target:self action:@selector(touchSettingsButton)];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -15;
    notiButtonView = [[UIView alloc] initWithFrame:CGRectMake(-15, 0, 44, 44)];
    notiButton = [UIButton buttonWithType:UIButtonTypeSystem];
    notiButton.autoresizesSubviews = true;
    notiButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    [notiButton addTarget:self action:@selector(touchNotificationButton) forControlEvents:UIControlEventTouchUpInside];
    notiButton.frame = notiButtonView.frame;
//    [notiButton layer].anchorPoint = CGPointMake(0.5, 0.4);
    
    [notiButtonView addSubview:notiButton];
    [self updateNumbersNoti];
    
    UIBarButtonItem *notificationButtonItem = [[UIBarButtonItem alloc] initWithCustomView:notiButtonView];
    //    UIBarButtonItem *notificationButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Btn_Notification_Normal.png"] style:UIBarButtonItemStylePlain target:self action:@selector(touchNotificationButton)];
    
    //        UIButton *chat = [UIButton buttonWithType:UIButtonTypeSystem];
    //        UIImage *chatB = [UIImage imageNamed:@"Btn_MyChatHistory_Normal.png"];
    //        [chat setBackgroundImage:chatB forState:UIControlStateNormal];
    //        [chat addTarget:self action:@selector(touchChatButton:) forControlEvents:UIControlEventTouchUpInside];
    //        chat.frame = CGRectMake(-5, 0, 25, 25);
    //        UIView *chatButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    //        [chatButtonView addSubview:chat];
    //        UIBarButtonItem *chatButton = [[UIBarButtonItem alloc] initWithCustomView:chatButtonView];
    
    //    UIBarButtonItem *chatButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Btn_MyChatHistory_Normal.png"] style:UIBarButtonItemStylePlain target:self action:@selector(touchChatButton:)];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:/*notificationButton,*/ settingsButton, nil]];
    NSArray *leftItems = [NSArray arrayWithObjects:/*notificationButton,*/ /*negativeSpacer,*/ notificationButtonItem, nil];
    [self.navigationItem setLeftBarButtonItems:leftItems];
}

- (void)updateNumbersNoti {
    [notiButton setImage:[UIImage imageNamed:@"Bell_Icon2"] forState:UIControlStateNormal];
    [bellSwingTimer invalidate];
    bellSwingTimer = nil;
    for (int i = 0; i < notiButtonView.subviews.count; i++) {
        if ([notiButtonView.subviews[i] isKindOfClass:[UILabel class]]) {
            [notiButtonView.subviews[i] removeFromSuperview];
        }
    }
    
    NSInteger notificatioNumber = [userDefaultManager getNotificationNumber];
    if (notificatioNumber > 0)
    {
        [notiButton setImage:[UIImage imageNamed:@"icon_ring_active"] forState:UIControlStateNormal];
        
        UILabel *notiNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 17, 13)];
        notiNum.textAlignment = NSTextAlignmentCenter;
        [notiNum setFont:[UIFont boldSystemFontOfSize:9]];
        notiNum.text = [@(notificatioNumber) stringValue];
        notiNum.backgroundColor = [UIColor whiteColor];
        notiNum.layer.cornerRadius = notiNum.frame.size.height /2;
        notiNum.layer.masksToBounds = YES;
        notiNum.layer.borderWidth = 1.0;
        notiNum.layer.borderColor = UIColorFromRGB(0xB22225).CGColor;
        notiNum.textColor = UIColorFromRGB(0xB22225);
        
        notiNum.frame = CGRectMake(notiButton.frame.size.width - 1.5 * notiNum.frame.size.width,
                                   notiButton.frame.size.width / 2 - notiNum.frame.size.height / 1.3,
                                   notiNum.frame.size.width, notiNum.frame.size.height );
        [notiButtonView addSubview:notiNum];
        bellSwingTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:[WeakLinkObj weakObjectWithRealTarget:self]
                                       selector:@selector(swingNotiBellView:)
                                       userInfo:notiButton repeats:true];
    }
}

- (void)alignBellIconToTheLeftForiOS11 {
    // Fix Notification bell got shifted to the right in iOS 11
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0")) {
        UIView *view = notiButtonView;
        while (![view isKindOfClass:[UINavigationBar class]] && view.superview != nil) {
            view = view.superview;
            if ([view isKindOfClass:[UIStackView class]] && view.superview != nil) {
                [view.superview addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-8.0]];
                [view.superview addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:-4.0]];
                break;
            }
        }
    }
}

-(void) initLayoutProfile{
    _avatar.layer.borderWidth = 2;
    _avatar.layer.borderColor = [UIColor colorFromHexString:@"#FFFFFF"].CGColor;
    _avatar.layer.cornerRadius = _avatar.frame.size.width / 2;
    _avatar.clipsToBounds = YES;
    
    _avatarCircle.layer.cornerRadius = _avatarCircle.frame.size.width / 2;
    _avatarCircle.layer.borderWidth = 1;
    _avatarCircle.layer.borderColor = [UIColor colorFromHexString:@"#FFFFFF"].CGColor;
    
    _followingButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _followingButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    _followerButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _followerButton.titleLabel.textAlignment = NSTextAlignmentCenter;

    _message.numberOfLines = 0;
    
    _tableView.alwaysBounceVertical = TRUE;
    _tableView.bounces = TRUE;
    _tableView.tableHeaderView = _topView;
    
//    bottomFrame = CGRectMake(0, 285, 320, 102);
//    bottomFrame.origin.y = 285 + _message.frame.size.height;
//    [_bottomView setFrame:bottomFrame];
//
//    topFrame = CGRectMake(0, 0, self.view.bounds.size.width, TOPVIEW_DEFAULT_HEIGHT);
//    topFrame.size.height = bottomFrame.origin.y + bottomFrame.size.height + self.uploadAvatarReminderView.frame.size.height;
//    [_topView setFrame:topFrame];
//    _tableView.tableHeaderView = _topView;
}

- (void)initProfile {
    
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
    //    [_updateInfoButton setTitle:@"Update\nInfo" forState: UIControlStateNormal];
    
    //    NSString *following = [NSString stringWithFormat:NSLocalizedString(@"%ld\nRECEIVERS", nil) , (long)profileData.following];
    //    [_followingButton setTitle:following forState:UIControlStateNormal];
    
    _NumRecieve.text = @(profileData.following).stringValue;
    if (profileData.following <= 1) {
        _RecieverTitle.text = NSLocalizedString(@"RecieverName.Title", );
    } else {
        _RecieverTitle.text = NSLocalizedString(@"RecieversName.Title", );
    }
    
    
    _NumberGived.text = @(profileData.follower).stringValue;
    
    if (profileData.follower <= 1) {
        _GiverTitle.text = NSLocalizedString(@"GiverName.Title", );
    } else {
        _GiverTitle.text = NSLocalizedString(@"GiversName.Title", );
    }
    
    self.navigationItem.title = profileData.username;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    _name.text = profileData.name;
    _username.text = profileData.username;
    //[_avatar setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:profileData.avatar] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10] placeholderImage:nil success:nil failure:nil];
//    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:profileData.avatar]]];
    [_avatar setImageWithURL:[NSURL URLWithString:profileData.avatar]];
    
    [self initAboutMe:self.profileData.about_me];
    
    [self.view setNeedsDisplay];
    [self.view layoutIfNeeded];
    
    NSInteger myNewHeight = 0;
    myNewHeight = _TopViewImage.frame.size.height + _FlowerNumberView.frame.size.height + _ButtonView.frame.size.height + _LineView.frame.size.height + _StatusView.frame.size.height + 2 + self.uploadAvatarReminderView.frame.size.height;
    
    topFrame = _topView.frame;
    topFrame.size.height = myNewHeight;
    [_topView setFrame:topFrame];
    
//    [_message sizeToFit];
    [self.winnerButton setHidden:[profileData.video_link isEqualToString:@""]];
    
    [self.view layoutIfNeeded];
    
}


- (void)initSlideShow {
    [_slideshow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 0; i < images.count; i++) {
        BannerObj *temp = (BannerObj *)[images objectAtIndex:i];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH_SCREEN * i, 0, WIDTH_SCREEN, _slideshow.frame.size.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = TRUE;
        
        [[SDImageCache sharedImageCache]clearMemory];
        [[SDImageCache sharedImageCache]clearDisk];
        
        [imageView setImageWithAnimationFromURL:[NSURL URLWithString:temp.photo_url] placeHolder:[UIImage imageNamed:@"Banners_mockup.png"]];
        
        [_slideshow addSubview:imageView];
        
        _slideshow.contentSize = CGSizeMake(images.count * WIDTH_SCREEN, _slideshow.frame.size.height);
    }
}


- (void)infiniteScrolling
{
    if (tagNumber == 0) {
        if (_galleryData.count != 0)
        {
            postID = [[_galleryData objectAtIndex:_galleryData.count - 1] post_id];
        }
        else
        {
            postID = @"";
        }
        
        if (postID != lastPostID) {
            //            [self loadGalleryUsingAPI];
            [self loadGallery];
            lastPostID = postID;
        }
    }
    [_tableView.infiniteScrollingView stopAnimating];
}

- (void)initAboutMe:(NSString*)string
{
    changeStatusPop.textData.text = string;
    if([string isEqual: @""])
    {
        self.message.text = NSLocalizedString(@"ProfileEmptytitle.title", );
        self.message.textColor = UIColorFromRGB(0xD2D2D2);
    }
    else if([[profileData.about_me stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqual: @""])
    {
        self.message.text = string;
        self.message.textColor = UIColorFromRGB(0x3E3E3E);
    }
    else {
        self.message.text = [string removeDuplicateNewLines];
        self.message.textColor = UIColorFromRGB(0x3E3E3E);
    }
}

#pragma mark - Scrollview Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView != _tableView) {
        scroll = true;
    } else {
        //[_tabbar setHidden:TRUE];
        
        //        if ([_tabbar tabBarIsVisible:_tabbar.tabBarController]) {
        //            [_tabbar setTabBarVisible:FALSE animated:TRUE tabBarConrtoller:_tabbar.tabBarController];
        //            _tabbar.previousState = TRUE;
        //        }
    }
}

- (void)scrollToFirstPage
{
    pageIndex = 1;
    offset = WIDTH_SCREEN * pageIndex;
    [_slideshow setContentOffset: CGPointMake(offset, _slideshow.contentOffset.y) animated:NO];
}

- (void)scrollToLastPage
{
    pageIndex = images.count;
    offset = WIDTH_SCREEN * pageIndex;
    [_slideshow setContentOffset: CGPointMake(offset, _slideshow.contentOffset.y) animated:NO];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == _tableView)
    {
        //[_tabbar setHidden:FALSE];
        
        //        if (_tabbar.previousState)
        //        {
        //            [_tabbar setTabBarVisible:TRUE animated:TRUE tabBarConrtoller:_tabbar.tabBarController];
        //            _tabbar.previousState = FALSE;
        //        }
    } else {
        
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _slideshow)
    {
        scrollView.userInteractionEnabled = FALSE;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _slideshow)
    {
        scrollView.userInteractionEnabled = TRUE;
        
        if (_slideshow.contentOffset.x <= 0) {
            [_slideshow scrollRectToVisible:CGRectMake(images.count * WIDTH_SCREEN, 0, _slideshow.frame.size.width, _slideshow.frame.size.height) animated:NO];
            pageIndex = images.count;
        }
        else if (_slideshow.contentOffset.x >= (images.count + 1) * WIDTH_SCREEN) {
            [_slideshow scrollRectToVisible:CGRectMake(WIDTH_SCREEN, 0, _slideshow.frame.size.width, _slideshow.frame.size.height) animated:NO];
            pageIndex = 1;
        }
        
        
        if (scroll && !avoidFirstScroll)
        {
            if (slideshowLastContentOffset > _slideshow.contentOffset.x)
            {
                if (pageIndex < 1)
                    pageIndex = images.count;
                else
                    pageIndex--;
            }
            else if (slideshowLastContentOffset < _slideshow.contentOffset.x)
            {
                if (pageIndex > images.count) {
                    pageIndex = 1;
                }
                else
                    pageIndex++;
                
                if (pageIndex == 4) {
                    pageIndex = 3;
                }
                
                if (pageIndex == 3 && images.count == 2 ) {
                    pageIndex = 2;
                }
            }
            
            scroll = false;
        }
        
        //        covers *firstCover = (covers *)[images objectAtIndex:0];
        //
        //        if (pageIndex == 0 || [firstCover.photo_id isEqualToString:@""]) {
        //            [_repositionButton setHidden:TRUE];
        //        } else {
        //            [_repositionButton setHidden:FALSE];
        //        }
        
        slideshowLastContentOffset = _slideshow.contentOffset.x;
        //NSLog(@"PAGE INDEX: %ld", (long)pageIndex);
        //NSLog(@"IMAGE COUNT: %ld", (long)images.count);
    }
}


#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(currentIndex == 0)
        return listGallery.count;
    else
        return _achieveData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (currentIndex == 0) {
        ProfileRaceListTableViewCell *cell = (ProfileRaceListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[ProfileRaceListTableViewCell cellIdentifier]
                                                                                                             forIndexPath:indexPath];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.navigationController = self.navigationController;

        profile_gallery *temp = (profile_gallery *)[listGallery objectAtIndex:indexPath.row];
        NSMutableArray *photos;
        if(temp.name != nil)
            photos = (NSMutableArray *)[listPostGallery objectForKey:temp.key];
        //format RaceName - closed & left
        UILabel *tempLabel = [Support formatLabel:cell.raceName raceName:temp.name status:temp.status];
        cell.raceName.text = tempLabel.text;
        cell.status = temp.status;
        cell.key = temp.key;
        cell.uid = [profileData uid];
        [cell.noPhotoView setHidden:temp.name != nil];

        if (!cell.done && temp.name != nil) {
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

// MARK: - API functions + Delegate

- (void)loadProfileMeUsingAPI {
    [spinner startAnimating];
    API_Profile_Me * api = [[API_Profile_Me alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken]];
    [api getRequest:^(BaseJSON * json, RestfulResponse * objStatus) {
        out_profile_fetch * object = (out_profile_fetch *) json;
        [spinner stopAnimating];
        if (objStatus.status)
        {
            profileData = object;
            
            self.uploadAvatarReminderViewHeight.constant = [profileData.mobile isEqualToString:@""] || !profileData.isupload_avatar ? UPLOAD_AVATAR_REMINDER_DEFAULT_HEIGHT : 0;
            if ([profileData.mobile isEqualToString:@""]) {
                [self switchReminderView:true];
            } else if (!profileData.isupload_avatar) {
                [self switchReminderView:false];
            } else {
                [self touchUploadAvatarReminderCloseButton:nil];
            }
            
            [userDefaultManager saveUserProfileData:profileData];
            [_tabbar updateFlowerValue];
            [self initProfile];
        }
        else{

            [Support addErrorMessage:objStatus.message intoView:self.view];
            
        }
        [self loadGSB];
        [spinner stopAnimating];

    } ErrorHandlure:^(NSError * error) {
        [spinner stopAnimating];
    }];
}


- (void)NotiloadProfileMeUsingAPI {
    API_Profile_Me * api = [[API_Profile_Me alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken]];
    [api getRequest:^(BaseJSON * json, RestfulResponse * objStatus) {
        out_profile_fetch * object = (out_profile_fetch *) json;
        if (objStatus.status)
        {
            profileData = object;
            
            self.uploadAvatarReminderViewHeight.constant = [profileData.mobile isEqualToString:@""] || !profileData.isupload_avatar ? UPLOAD_AVATAR_REMINDER_DEFAULT_HEIGHT : 0;
            if ([profileData.mobile isEqualToString:@""]) {
                [self switchReminderView:true];
            } else if (!profileData.isupload_avatar) {
                [self switchReminderView:false];
            } else {
                [self touchUploadAvatarReminderCloseButton:nil];
            }
            
            [userDefaultManager saveUserProfileData:profileData];
            [_tabbar updateFlowerValue];
            [self initProfile];
        }
        else{
            
            [Support addErrorMessage:objStatus.message intoView:self.view];
            
        }
        [self loadGSB];
        
    } ErrorHandlure:^(NSError * error) {
    }];
}


- (void)loadMembershipAPI {
    // Membership
    API_Get_RewardMemebership* membershipAPI = [[API_Get_RewardMemebership alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                                                             deviceId:[userDefaultManager getDeviceToken]
                                                                                            andUserId:profileData.uid];
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

- (void)loadGSB
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


- (void)loadSlideShowUsingAPI {
    API_Profile_BannerFetches *api = [[API_Profile_BannerFetches alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                                               device_token:[userDefaultManager getDeviceToken]
                                                                                        uid:[profileData uid]];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        if (response.status) {
            JSON_BannerFetch *data = (JSON_BannerFetch *)jsonObject;
            images = data.bannerList;
            
            if (images.count <= 1) {
                [_swipeToViewMore setHidden:true];
            } else {
                [_swipeToViewMore setHidden:false];
            }
            
            if (images.count != 0) {
                [self initSlideShow];
            }
        } else {
            [Support addErrorMessage:response.message intoView:self.view];
        }
    } ErrorHandlure:^(NSError *error) {
        [spinner stopAnimating];
    }];

}



- (void)loadPhotoByRaceKey:(NSString*)key userID:(NSInteger)uID {
    API_Profile_Post_GalleryFetches *API = [[API_Profile_Post_GalleryFetches alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] key:key uid:uID post_id:@""limit:LOAD_GALLERY_MIN_LIMIT];
    [API request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        JSON_GalleryFetches * data = (JSON_GalleryFetches *) jsonObject;
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

            [Support addErrorMessage:response.message intoView:self.view];
        }
    } ErrorHandlure:^(NSError *error) {
        
    }];

}

- (void)loadGallery {
    API_Profile_Gallery_Fetches *API = [[API_Profile_Gallery_Fetches alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] uid:[profileData uid]];
    [spinner startAnimating];
    [API request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        out_profile_gallery_fetches * data = (out_profile_gallery_fetches *) jsonObject;
        [spinner stopAnimating];
        if (response.status) {
            listGallery = [data galleryList];
            if([listGallery count] == 0) {
                profile_gallery *tmpObj = [[profile_gallery alloc] initWithName:nil key:nil status:0];
                [listGallery addObject:tmpObj];
                [_tableView reloadData];
            }
            for (profile_gallery* galleryItem in listGallery) {
                if(galleryItem.name != nil)
                    [self loadPhotoByRaceKey:galleryItem.key userID:[profileData uid]];
            }
            
        } else {
            [Support addErrorMessage:response.message intoView:self.view];
        }
    } ErrorHandlure:^(NSError *error) {
        [spinner stopAnimating];
    }];
}

- (void)loadSponsorUsingAPI
{
    [spinner startAnimating];
    
    API_Sponsors_Fetch *sponsorAPI = [[API_Sponsors_Fetch alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] user_id:profileData.uid];
    [sponsorAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        out_sponsor_fetch * data = (out_sponsor_fetch *) jsonObject;
        if (response.status)
        {
            _sponsorData = data.sponsorData;
            [_tableView reloadData];
        }
        else
        {
            [Support addErrorMessage:response.message intoView:self.view];
        }
        
        [spinner stopAnimating];
    } ErrorHandlure:^(NSError *error) {
        [spinner stopAnimating];
    }];
}

- (void)loadFavouriteUsingAPI
{
    [spinner startAnimating];
    
    API_RaceFavouriteOne *api = [[API_RaceFavouriteOne alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                                     device_token:[userDefaultManager getDeviceToken]
                                                                              min:0
                                                                              max:-1];
    
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        JSON_RaceFavouriteOne *jsonRaceFetches = (JSON_RaceFavouriteOne *)jsonObject;
        if (response.status) {
            self.favouriteData = jsonRaceFetches.favourites;
            [self.tableView reloadData];
        } else {
            [Support addErrorMessage:response.message intoView:self.view];
        }
        [spinner stopAnimating];
        
    } ErrorHandlure:^(NSError *error) {
        [spinner stopAnimating];
    }];
}

#pragma achievement

- (void)loadAchieveUsingAPI
{
    
}


- (void)setPrize:(UIImageView*)image Rank:(NSInteger)rank
{
    if (rank == 1)
    {
        image.image = [UIImage imageNamed:@"Ico_FirstPrize.png"];
    }
    
    if (rank == 2)
    {
        image.image = [UIImage imageNamed:@"Ico_SecondPrize.png"];
    }
    
    if (rank == 3)
    {
        image.image = [UIImage imageNamed:@"Ico_ThirdPrize.png"];
    }
    
    if (rank >= 4 && rank < 200)
    {
        image.image = [UIImage imageNamed:@"Ico_4-200Prize.png"];
    }
    
    if (rank >= 200)
    {
        image.image = [UIImage imageNamed:@"Ico_200toInfPrize.png"];
    }
}

- (void)clearDraggableLocationList
{
    if (galleryIndex == 0 && _thumbDraggableLocatioinList.count != 0)
    {
        for (int i = 0; i < _thumbDraggableLocatioinList.count; i++)
        {
            [_tabbar.draggableButton removeAllowedDropLocation:[_thumbDraggableLocatioinList objectAtIndex:i]];
        }
    }
    else
        if (galleryIndex == 1 && _listDraggableLocatioinList.count != 0)
        {
            for (int i = 0; i < _listDraggableLocatioinList.count; i++)
            {
                [_tabbar.draggableButton removeAllowedDropLocation:[_listDraggableLocatioinList objectAtIndex:i]];
            }
        }
}

#pragma mark - Action Functions
- (void)pullToRefresh
{
    [self.galleryData removeAllObjects];
    loadedItemIndex = 0;
    postID = @"";
    
    [self loadProfileMeUsingAPI];
    [self loadMembershipAPI];
    [self loadSlideShowUsingAPI];
    [self reloadTableByCurrentIndex];
    //    [self loadDataBasedOnButtonIndex:currentIndex];
    
    [_tableView.pullToRefreshView stopAnimating];
}

- (void)touchNotificationButton
{
    NotificationViewController *view;
    
    //    if (IS_IPHONE_5)
    //    {
    view = [[NotificationViewController alloc] initWithNibName:@"NotificationViewController" bundle:nil];
    //    }
    //    else
    //        if (IS_IPHONE_4)
    //        {
    //            view = [[NotificationViewController alloc] initWithNibName:@"NotificationViewController_ip4" bundle:nil];
    //        }
    
    view.hidesBottomBarWhenPushed = TRUE;
    [self.navigationController pushViewController:view animated:TRUE];
}

- (void)touchSettingsButton
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MySetting" bundle:nil];
    MySettingViewController *view = [storyboard instantiateViewControllerWithIdentifier:@"MySetting"];
    view.hidesBottomBarWhenPushed = TRUE;
    
    [_tabbar snapbackFlowerIconToTabbar];
    
    [self.navigationController pushViewController:view animated:TRUE];}


- (IBAction)onSwitchAlbumsAndAchievements:(id)sender{
    currentIndex = ((UIButton*)sender).tag;
    [_tableView reloadData];
    [self reloadTableByCurrentIndex];
    
}

- (IBAction)SegmentedControl:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0) {
        
    } else if (selectedSegment == 1) {
        
    }
}

- (IBAction)touchFollowers:(id)sender {
    FlowerRelationViewController *flowerRelationViewController = [[FlowerRelationViewController alloc] initWithNibName:@"FlowerRelationViewController" bundle:nil];
    //    flowerRelationViewController.tabIndex = 0;
    flowerRelationViewController.isFollower = true;
    flowerRelationViewController.hidesBottomBarWhenPushed = true;
    
    [self.navigationController pushViewController:flowerRelationViewController animated:true];
}

- (IBAction)touchFollowing:(id)sender {
    FlowerRelationViewController *flowerRelationViewController = [[FlowerRelationViewController alloc] initWithNibName:@"FlowerRelationViewController" bundle:nil];
    //    flowerRelationViewController.tabIndex = 0;
    flowerRelationViewController.isFollower = false;
    flowerRelationViewController.hidesBottomBarWhenPushed = true;
    
    [self.navigationController pushViewController:flowerRelationViewController animated:true];
}

- (IBAction)touchUploadButton:(id)sender
{
    if([profileData.city.city_short_name isEqualToString:k_UNKNOWN_LOCATION]) {
        SelectCityViewController *view = [[SelectCityViewController alloc] initWithNibName:@"SelectCityViewController" bundle:nil];
        view.hidesBottomBarWhenPushed = YES;
        __weak MyProfileViewController *weakSelf = self;
        view.complete = ^{
            weakSelf.profileData = [userDefaultManager getUserProfileData];
            [weakSelf loadAvatars];
        };
        [self.navigationController pushViewController:view animated:YES];
    }
    else if (!profileData.isupload_avatar)
    {
        [self touchChangeAvatarButton:nil];
    }
    else
    {
        imagePickerPopup = [[ImagePickerPopUpViewController alloc] initWithNibName:@"ImagePickerPopUpViewController" bundle:nil];
        imagePickerPopup.parentView = self;
        imagePickerPopup.isUploadAvatar = false;
        [imagePickerPopup showInView:[[[UIApplication sharedApplication] delegate] window] animated:true];
    }
}

- (IBAction)touchChoosingBanners:(id)sender {
    ChoosingBannersViewController *view = [[ChoosingBannersViewController alloc] initWithNibName:@"ChoosingBannersViewController" bundle:nil];
    view.covers = [[[images reverseObjectEnumerator] allObjects] mutableCopy];
    
    if (view.covers.count < 3) {
        
        covers *firstCover = (covers *)[images firstObject];
        NSInteger beginIndex = view.covers.count;
        
        if ([firstCover.photo_id isEqualToString:@""]) {
            [view.covers removeObjectAtIndex:0];
            beginIndex = 0;
        }
        
        for (NSInteger i = beginIndex; i < 3; i++) {
            
            covers *temp = [[covers alloc] init];
            temp.photo_id = @"";
            temp.pCover = @"Default_Banner.png";
            temp.pLarge = @"Default_Banner.png";
            
            [view.covers addObject:temp];
        }
    }
    
    view.parentView = self;
    view.hidesBottomBarWhenPushed = TRUE;
    
    [self.navigationController pushViewController:view animated:TRUE];
}

- (IBAction)touchActiveRaces:(id)sender {
    activeRaces = TRUE;
    //    [_activeRacesButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    //    [_closeRacesButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    _achieveData = _activeAchieveData;
    [_tableView reloadData];
}

- (IBAction)touchCloseRaces:(id)sender {
    activeRaces = FALSE;
    //    [_activeRacesButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [_closeRacesButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _achieveData = _closedAchieveData;
    [_tableView reloadData];
}
- (IBAction)onTouchEditProfile:(id)sender {
    EditProfileViewController *editView;
    editView.hidesBottomBarWhenPushed = TRUE;
    editView = [[EditProfileViewController alloc] initWithNibName:@"EditProfileViewController" bundle:nil];
    [self.navigationController pushViewController:editView animated:YES];
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
    //    _achieveData = _activeAchieveData;
    [_tableView reloadData];
}

- (IBAction)touchChangeAvatarButton:(UIButton*)sender
{
    if (self.isUpdateMobile && sender == self.uploadAvatarReminderButton)
    {
        UpdatePhoneNumberViewController *view = [[UpdatePhoneNumberViewController alloc] initWithNibName:@"UpdatePhoneNumberViewController" bundle:nil];
        view.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:view animated:true];
    }
    else if(![profileData.city.city_short_name isEqualToString:k_UNKNOWN_LOCATION])
    {
        [self loadAvatars];
    }
    else
    {
        SelectCityViewController *view = [[SelectCityViewController alloc] initWithNibName:@"SelectCityViewController" bundle:nil];
        view.hidesBottomBarWhenPushed = YES;
        __weak MyProfileViewController *weakSelf = self;
        view.complete = ^{
            weakSelf.profileData = [userDefaultManager getUserProfileData];
            [weakSelf loadAvatars];
        };
        [self.navigationController pushViewController:view animated:YES];
    }
}

#pragma mark - More Functions
- (void)swingNotiBellView:(NSTimer *)_timer {
    UIButton *btnNoti = (UIButton *) _timer.userInfo;
    if (btnNoti) {
        [btnNoti swing:nil];
    }
}

- (void)reloadTableByCurrentIndex {
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
            //            UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:_rankView.bounds];
            //            _rankView.layer.masksToBounds = NO;
            //            _rankView.layer.shadowColor = [UIColor blackColor].CGColor;
            //            _rankView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
            //            _rankView.layer.shadowOpacity = 0.5f;
            //            _rankView.layer.shadowPath = shadowPath.CGPath;
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
            //            [self loadGalleryUsingAPI];
            [self loadGallery];
            break;
            
        case 1:
            [self loadSponsorUsingAPI];
            break;
            
        case 2:
            [self loadFavouriteUsingAPI];
            break;
            
        case 3:
            [self loadAchieveUsingAPI];
            break;
    }
}

- (IBAction)touchChangeBanner:(id)sender {
    if (images.count > 0)
    {
        ChangeBannerViewController *view;
        view = [[ChangeBannerViewController alloc] initWithNibName:@"ChangeBannerViewController" bundle:nil];
        view.hidesBottomBarWhenPushed = true;
        view.bannerList = images;
        view.delegate = self;
        [self.navigationController pushViewController:view animated:YES];
    }
}

- (void)loadAvatars {
    [spinner startAnimating];
    API_Profile_AvatarsFetches *api = [[API_Profile_AvatarsFetches alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken]];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        out_avatars_fetches * data= (out_avatars_fetches *) jsonObject;
        if (response.status)
        {
            avatarList = [data avatarList];
            //        if (avatarList.count > 0)
            //        {
            ChangeAvatarViewController *view;
            view = [[ChangeAvatarViewController alloc] initWithNibName:@"ChangeAvatarViewController" bundle:nil];
            if([avatarList count] == 0) {
                avatar *avatarRace = [[avatar alloc] initWithName:profileData.location_name key:profileData.city.city_short_name phptoURL:nil category:RACECATEGORY_LOCATION];
                [avatarList addObject:avatarRace];
            }
            view.avatarList = avatarList;
            view.parentView = self;
            view.uid = profileData.uid;
            view.listGallery = listGallery;
            view.hidesBottomBarWhenPushed = true;
            
            [self.navigationController pushViewController:view animated:YES];
            //        }
        }
        else {
            [AppHelper showMessageBox:nil message:response.message];
        }
        [spinner stopAnimating];
    } ErrorHandlure:^(NSError *error) {
        [spinner stopAnimating];
    }];
}

- (IBAction)TouchChangeStatus:(id)sender {
    
//    _message.text = @" ";
    [self.view setNeedsLayout];
    changeStatusPop.textData.text = profileData.about_me;
    changeStatusPop.parentView = self;
    [changeStatusPop showInView:[[[UIApplication sharedApplication] delegate] window] andData:profileData.about_me animated:TRUE];
}

- (IBAction)TouchAchievement:(id)sender {
    MembershipViewController *view = [[MembershipViewController alloc] init];
    userDefaultManager = [[UserDefaultManager alloc] init];
    view.uid = [userDefaultManager getUserProfileData].uid;
    view.bronze = bronze;
    view.silver = silver;
    view.gold = gold;
    view.hidesBottomBarWhenPushed = true;
    
    self.achievementButton.enabled = false;
    [self.navigationController pushViewController:view animated:true];
    self.achievementButton.enabled = true;
}

- (IBAction)TouchFlowerButton:(id)sender {
    
    FlowerGardenViewController *view;
    
    view = [[FlowerGardenViewController alloc] initWithNibName:@"FlowerGardenViewController" bundle:nil];
    [_tabbar snapbackFlowerIconToTabbar];
    view.hidesBottomBarWhenPushed = TRUE;
    [self.navigationController pushViewController:view animated:TRUE];
    
}
- (IBAction)TouchChatButton:(id)sender {
    self.chatListVC = [[ChatListViewController alloc] initWithNibName:@"ChatListViewController" bundle:nil];
    [_tabbar snapbackFlowerIconToTabbar];
    self.chatListVC.hidesBottomBarWhenPushed = TRUE;

    [self.navigationController pushViewController:self.chatListVC animated:TRUE];
}

- (IBAction)TouchInsideWinnerButton:(id)sender {
    if([profileData.video_link isEqualToString:@""]) return;
    BrowserViewController *browserview = [[BrowserViewController alloc] initWithNibName:@"BrowserViewController" bundle:nil];
    browserview.urlString = profileData.video_link;
    browserview.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:browserview animated:true];
}

- (IBAction)touchUploadAvatarReminderCloseButton:(id)sender
{
    self.uploadAvatarReminderViewHeight.constant = 0;
    topFrame = CGRectMake(0, 0, self.view.bounds.size.width, TOPVIEW_DEFAULT_HEIGHT);
    [_topView setFrame:topFrame];
    _tableView.tableHeaderView = _topView;
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)UploadAvatartoLocationRaceWithImage:(UIImage*)image raceKey:(NSString*)key complete:(void (^) (void))complete {
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
    API_Avatar_RaceAttached *avatarAPI = [[API_Avatar_RaceAttached alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] image:image key:key];
    __weak MyProfileViewController *weakSelf = self;
    
    [avatarAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        if(complete != nil)
        {
            [weakSelf pullToRefresh];
            complete();
        }
    } ErrorHandlure:^(NSError *error) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];
}

// MARK:- ChangeBannerViewControllerDelegate
- (void)updateBannerSuccess{
    [self loadSlideShowUsingAPI];
}

// MARK: - Selectors
- (void)updateAboutMe:(NSNotification*)notification
{
    NSString* aboutMe = [[notification userInfo] objectForKey:[NotificationKey AboutMe]];
    [self initAboutMe:aboutMe];
}

- (void)updateProfileName:(NSNotification*)notification
{
    NSString* name = [[notification userInfo] objectForKey:[NotificationKey ProfileName]];
    self.name.text = name;
}

- (void)updateProfileUsername:(NSNotification*)notification
{
    NSString* username = [[notification userInfo] objectForKey:[NotificationKey ProfileUsername]];
    self.username.text = username;
    self.navigationItem.title = username;
}

@end

