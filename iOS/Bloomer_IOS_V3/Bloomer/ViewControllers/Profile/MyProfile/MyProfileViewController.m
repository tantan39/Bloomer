//
//  MyProfileViewController.m
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 3/20/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

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

#import "UIColor+Extension.h"
#import "MySettingViewController.h"
#import "PhotoGalleryViewController.h"
#import "AchievementViewController.h"
#import "UpdatePhoneNumberViewController.h"
#import "NotificationHelper.h"
#import "ChangeAvatarViewController.h"
#import "BloomerActionSheet.h"
#import "ChangeProfileViewController.h"

@interface MyProfileViewController ()
{
    UserDefaultManager *userDefaultManager;
    Spinner *spinner;
    FlowerMenuPopUpViewController *popup;
    FlowerMenuPostPopupViewController *postPopup;
    ImagePickerPopUpViewController *imagePickerPopup;
    RemindInviteCode * remindInvitePopup;

    NSString *postID;
    NSString *lastPostID;
    int flower;
    int tagNumber;
    UIImageView *thankyou;
    NSInteger offset;

    BOOL isTabBarHidden;
    BOOL isTouched;
    BOOL isTouched_Chat;
    BOOL isGrid;
    NSInteger currentIndex;
    NSInteger galleryIndex;
    NSIndexPath *draggedCellIndex;
    NSInteger index;
    BOOL isGiveUser;

    BOOL activeRaces;
//    NSTimer *timer;
//    NSTimer *bellSwingTimer;
    NSMutableArray *closeDays;
    BOOL giveFlower;

    NSMutableArray *listGallery;
    NSMutableDictionary *listPostGallery;
    
    NSMutableArray* avatarList;
    ChangeStatusPopUpViewController* changeStatusPop;
    NSMutableArray* viewArray;
    UIImage *chosenImage;
    UIButton *notiButton;
    
    NSInteger bronze;
    NSInteger silver;
    NSInteger gold;
    PhotosDataSource * photosDataSource;
    PostsDataSouce * postsDataSource;
    AlbumsDataSource * albumsDataSource;
    BellNotificationCustomView * notificationView;
}

@property (assign, nonatomic) BOOL isUpdateMobile;
@property (strong,nonatomic) ChatListViewController * chatListVC;

@end

@implementation MyProfileViewController

@synthesize images, profileData, circularMenu;

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.isUpdateMobile = true;
//    activeRaces = true;?
//    postID = @"";
//    lastPostID = @"";
//    tagNumber = 0;
//    giveFlower = false;
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    profileData = [userDefaultManager getUserProfileData];

//    closeDays = [[NSMutableArray alloc] init];
//    listGallery = [[NSMutableArray alloc] init];
//    listPostGallery = [[NSMutableDictionary alloc]init];
    
//    for (UIView *view in [[[UIApplication sharedApplication] delegate] window].subviews) {
//        if ([view isKindOfClass:[TabBarView class]])
//        {
//            _tabbar = (TabBarView *)view;
//            break;
//        }
//    }
//
//    for (UIView *view in [[[UIApplication sharedApplication] delegate] window].subviews) {
//        if ([view isKindOfClass:[MKNumberBadgeView class]])
//        {
//            _badgeNumber = (MKNumberBadgeView*)view;
//            break;
//        }
//    }
//

//
//    changeStatusPop = [[ChangeStatusPopUpViewController alloc] initWithNibName:@"ChangeStatusPopUpViewController" bundle:nil];

//    _chatNotiNumber.layer.cornerRadius = _chatNotiNumber.frame.size.height /2;
//    _chatNotiNumber.layer.masksToBounds = TRUE;
//
//    _rewardNotiBubble.layer.cornerRadius = _rewardNotiBubble.frame.size.height /2;
//    _rewardNotiBubble.layer.masksToBounds = TRUE;
//
//    _updateInfoButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//
//    //_segmentControl.clipsToBounds = TRUE;
//    //_segmentControl.layer.cornerRadius = 15;
//
//    currentIndex = 0;
//    galleryIndex = 0;
//    isGrid = TRUE;
//
//    _thumbDraggableLocatioinList = [[NSMutableArray alloc] init];
//    _listDraggableLocatioinList = [[NSMutableArray alloc] init];
//
//    [self initNavigationBar];
//
//    spinner = ((AppDelegate*)[UIApplication sharedApplication].delegate).spinner;
//
//    __weak MyProfileViewController *weakSelf = self;
    
//    [_tableView addPullToRefreshWithActionHandler:^{
//        MyProfileViewController *strongSelf = weakSelf;
//        if (strongSelf)
//        {
//            [strongSelf pullToRefresh];
//        }
//    }];
//
//    [_tableView addInfiniteScrollingWithActionHandler:^{
//        [weakSelf infiniteScrolling];
//    }];
//
//    if([NSLocalizedString(@"EN", ) isEqualToString:@"EN"])
//    {
//        _WidthContrainBanner.constant = 100;
//    }
//    else
//    {
//        _WidthContrainBanner.constant = 135;
//    }
    
    
    self.sections = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:ProfileInfo],[NSNumber numberWithInt:DataCollection], nil];
    
    if ([profileData.mobile isEqualToString:@""] || !profileData.isupload_avatar) {
        [self.sections insertObject:[NSNumber numberWithInt:UpdateProfileRemindPopUp] atIndex:0];
    }
    
    [self.collectionView registerNib:[UINib nibWithNibName:[UpdateProfileCollectionViewCell nibName] bundle:nil] forCellWithReuseIdentifier:[UpdateProfileCollectionViewCell cellIdentifier]];
    
    [self.collectionView registerNib:[UINib nibWithNibName:[MyProfileHeaderViewCell nibName] bundle:nil] forCellWithReuseIdentifier:[MyProfileHeaderViewCell nibName]];
    
    photosDataSource = [[PhotosDataSource alloc] initWith:self.collectionView Sections:self.sections DataSource:@[] Delegate:self];
//    photosDataSource.delegate = self;
    [photosDataSource reloadData];
    
    postsDataSource = [[PostsDataSouce alloc] initWith:self.collectionView Sections:self.sections DataSource:@[] Delegate:self];
////    postsDataSource.delegate = self;
//
    albumsDataSource = [[AlbumsDataSource alloc] initWith:self.collectionView Sections:self.sections DataSource:@[] Delegate:self];
//    albumsDataSource.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAboutMe:) name:[NotificationNames UpdateAboutMe] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProfileName:) name:[NotificationNames UpdateProfileName] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProfileUsername:) name:[NotificationNames UpdateProfileUsername] object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_tabbar updateFlowerValue];
    
    [self setupNavigationBar];
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:appDelegate.chatBadgeNumber];
    
//    [self updateNumbersNoti];
    
    NSString* medalKey = [userDefaultManager getMedalKey];
//    [_rewardNotiBubble setHidden:[medalKey isEqualToString:@""]];
    
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//
//    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    [appDelegate.chatBadgeNumber removeFromSuperview];
//
//    [self.view endEditing:YES];
//}

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

- (void) showRemindInviteCodePopUpWith:(long) inviteFlowerNumb{
    remindInvitePopup = [[RemindInviteCode alloc] initWithNibName:@"RemindInviteCode" bundle:nil];
    remindInvitePopup.navigationController = self.navigationController;
    remindInvitePopup.inviteFlowerNumb = inviteFlowerNumb;
    [remindInvitePopup showInView:[[UIApplication sharedApplication] keyWindow] animated:YES];
}


#pragma mark - Initialize Functions

- (void)setupNavigationBar
{
    // init chat View;
//    [self updateNotificationNumber];
    
    [AppHelper changeNavigationBarToWhite:self.navigationController];
    [AppHelper hideShadowImageNavigationBar:self.navigationController];
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_Settingprofile"] style:UIBarButtonItemStylePlain target:self action:@selector(touchSettingsButton)];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -15;
    
    notificationView = [[BellNotificationCustomView alloc] initWithFrame:CGRectMake(8, 0, 44, 44)];
    notificationView.delegate = self;
    
    UIBarButtonItem *notificationButtonItem = [[UIBarButtonItem alloc] initWithCustomView:notificationView];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:/*notificationButton,*/ settingsButton, nil]];

    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,notificationButtonItem, nil]];
    
    NSInteger notificatioNumber = [userDefaultManager getNotificationNumber];
    [notificationView updateNumbersNotification:notificatioNumber];
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
//    [_tableView.infiniteScrollingView stopAnimating];
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

- (void) pushUpdateAvatarVC {
    UpdateAvatarViewController *view;
    view = [[UpdateAvatarViewController alloc] initWithNibName:@"UpdateAvatarViewController" bundle:nil];
    view.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:view animated:YES];
}

#pragma mark - UICollection Header Delegate
- (void)updateProfilePopUpClose_PressedWith:(UpdateProfileType)type{
    [self.sections removeObjectAtIndex:0];
    [photosDataSource reloadSections:self.sections];
    [postsDataSource reloadSections:self.sections];
    [albumsDataSource reloadSections:self.sections];
}

- (void)updateProfilePopUpUpdate_PressedWith:(UpdateProfileType)type{
    
}

- (void)btnEditAvatar_Pressed{
//    if (self.isUpdateMobile && sender == self.uploadAvatarReminderButton)
    if (self.isUpdateMobile)
    {
        UpdatePhoneNumberViewController *view = [[UpdatePhoneNumberViewController alloc] initWithNibName:@"UpdatePhoneNumberViewController" bundle:nil];
        view.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:view animated:true];
    }
    else if(![profileData.city.city_short_name isEqualToString:k_UNKNOWN_LOCATION])
    {
        [self pushUpdateAvatarVC];
       
    }
    else
    {
        SelectCityViewController *view = [[SelectCityViewController alloc] initWithNibName:@"SelectCityViewController" bundle:nil];
        view.hidesBottomBarWhenPushed = YES;
        __weak MyProfileViewController *weakSelf = self;
        view.complete = ^{
            weakSelf.profileData = [userDefaultManager getUserProfileData];
            [weakSelf pushUpdateAvatarVC];
        };
        [self.navigationController pushViewController:view animated:YES];
    }
}

- (void)btnEditProfile_Pressed{
    ChangeProfileViewController *editView;
    editView.hidesBottomBarWhenPushed = TRUE;
    editView = [[ChangeProfileViewController alloc] initWithNibName:@"ChangeProfileViewController" bundle:nil];
    NavigationViewController *changProfile = [[NavigationViewController alloc] initWithRootViewController:editView];
    changProfile.hidesBottomBarWhenPushed = TRUE;
    [self presentViewController:changProfile animated:TRUE completion:^{
    }];
    
}

- (void)btnEditBio_Pressed{
    ChangeAboutMeViewController *view = [[ChangeAboutMeViewController alloc] initWithNibName:@"ChangeAboutMeViewController" bundle:nil];
    view.updateStatus = ^(NSString* status) {
        self.profileData.about_me = status;
//        [self setData];
        [userDefaultManager saveUserProfileData:self.profileData];
    };
    view.hidesBottomBarWhenPushed = TRUE;
    [_tabbar snapbackFlowerIconToTabbar];
    [self.navigationController pushViewController:view animated:TRUE];
}

- (void)btnFollowers_Pressed{
    FlowerRelationViewController *flowerRelationViewController = [[FlowerRelationViewController alloc] initWithNibName:@"FlowerRelationViewController" bundle:nil];
    //    flowerRelationViewController.tabIndex = 0;
    flowerRelationViewController.isFollower = true;
    flowerRelationViewController.hidesBottomBarWhenPushed = true;
    
    [self.navigationController pushViewController:flowerRelationViewController animated:true];
}

- (void)btnFollowing_Pressed{
    FlowerRelationViewController *flowerRelationViewController = [[FlowerRelationViewController alloc] initWithNibName:@"FlowerRelationViewController" bundle:nil];
    //    flowerRelationViewController.tabIndex = 0;
    flowerRelationViewController.isFollower = false;
    flowerRelationViewController.hidesBottomBarWhenPushed = true;
    
    [self.navigationController pushViewController:flowerRelationViewController animated:true];
}

- (void)btnAchivement_Pressed{
    MembershipViewController *view = [[MembershipViewController alloc] init];
    userDefaultManager = [[UserDefaultManager alloc] init];
    view.uid = [userDefaultManager getUserProfileData].uid;
    view.bronze = bronze;
    view.silver = silver;
    view.gold = gold;
    view.hidesBottomBarWhenPushed = true;
    
    [self.navigationController pushViewController:view animated:true];

}

- (void)btnChat_Pressed{
    self.chatListVC = [[ChatListViewController alloc] initWithNibName:@"ChatListViewController" bundle:nil];
    [_tabbar snapbackFlowerIconToTabbar];
    self.chatListVC.hidesBottomBarWhenPushed = TRUE;
    
    [self.navigationController pushViewController:self.chatListVC animated:TRUE];

}

- (void)switchDisplayMode:(NSInteger)value{
    switch (value) {
        case 1:
            [postsDataSource reloadData];
            break;
        case 2:
            [albumsDataSource reloadData];
            break;
        default:
            [photosDataSource reloadData];
            break;
    }
    
}

- (void)touchItemSetting {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MySetting" bundle:nil];
    MySettingViewController *view = [storyboard instantiateViewControllerWithIdentifier:@"MySetting"];
    view.hidesBottomBarWhenPushed = TRUE;
    [_tabbar snapbackFlowerIconToTabbar];
    [self.navigationController pushViewController:view animated:TRUE];
}

- (void)touchItemTerms  {
    TermAndPolicyViewController *view = [[TermAndPolicyViewController alloc] initWithNibName:@"TermAndPolicyViewController" bundle:nil];
    view.urlString = [APIDefine termsOfUseLink];
    view.hidesBottomBarWhenPushed = TRUE;
    [_tabbar snapbackFlowerIconToTabbar];
    view.isTerm = YES;
    [self.navigationController pushViewController:view animated:TRUE];
}

- (void)touchItemPolicy {
    
    TermAndPolicyViewController *view = [[TermAndPolicyViewController alloc] initWithNibName:@"TermAndPolicyViewController" bundle:nil];
    view.urlString = [APIDefine privacyPolicyLink];
    view.isTerm = NO;
    view.hidesBottomBarWhenPushed = TRUE;
    [_tabbar snapbackFlowerIconToTabbar];
    [self.navigationController pushViewController:view animated:TRUE];
}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
////    if (currentIndex == 0) {
////        ProfileRaceListTableViewCell *cell = (ProfileRaceListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[ProfileRaceListTableViewCell cellIdentifier]
////                                                                                                             forIndexPath:indexPath];
////
////        cell.selectionStyle = UITableViewCellSelectionStyleNone;
////        cell.navigationController = self.navigationController;
////
////        profile_gallery *temp = (profile_gallery *)[listGallery objectAtIndex:indexPath.row];
////        NSMutableArray *photos;
////        if(temp.name != nil)
////            photos = (NSMutableArray *)[listPostGallery objectForKey:temp.key];
////        //format RaceName - closed & left
////        UILabel *tempLabel = [Support formatLabel:cell.raceName raceName:temp.name status:temp.status];
////        cell.raceName.text = tempLabel.text;
////        cell.status = temp.status;
////        cell.key = temp.key;
////        cell.uid = [profileData uid];
////        [cell.noPhotoView setHidden:temp.name != nil];
////
////        if (!cell.done && temp.name != nil) {
////            [cell loadPhotosByArray:photos];
////        }
////
////        return cell;
////    } else {
////        NSString *identifier = @"ProfileAchievementList";
////        ProfileAchievementsListTableViewCell *cell = (ProfileAchievementsListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
////
////        if (cell == nil) {
////            [tableView registerNib:[UINib nibWithNibName:@"ProfileAchievementsListTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
////            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
////        }
////        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
////
////        cell.preservesSuperviewLayoutMargins = false;
////        cell.separatorInset = UIEdgeInsetsZero;
////        cell.layoutMargins = UIEdgeInsetsZero;
////
////        achievementObject* rankInfo = [_achieveData objectAtIndex:indexPath.row];
////
////        if([rankInfo getKey] == 0)
////        {
////            [cell setUpType0:[rankInfo getName] rank:[rankInfo getData]];
////            if(indexPath.row < _achieveData.count-1)
////            {
////                achievementObject* rankTempInfo = [_achieveData objectAtIndex:indexPath.row + 1];
////                if([rankTempInfo getKey] != 0)
////                {
////                    cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
////                }
////            }
////        }
////        else if([rankInfo getKey] == 1)
////        {
////            [cell setUpType1:[rankInfo getName] flowers:[rankInfo getData]];
////            cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
////        }
////        else if([rankInfo getKey] == 2)
////        {
////            [cell setUpType2:[rankInfo getName]];
////            cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
////        }
////        else if([rankInfo getKey] == 3)
////        {
////            [cell setUpType3:[rankInfo getName]];
////            cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
////        }
////
////        if (indexPath.row == _achieveData.count-1) {
////            cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
////        }
////
////        return cell;
////    }
//    MyProfileTableviewCell * cell = (MyProfileTableviewCell *)[tableView dequeueReusableCellWithIdentifier:@"MyProfileTableviewCell"];
//    
//    return cell;
//}

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
            
//            self.uploadAvatarReminderViewHeight.constant = [profileData.mobile isEqualToString:@""] || !profileData.isupload_avatar ? UPLOAD_AVATAR_REMINDER_DEFAULT_HEIGHT : 0;
            if ([profileData.mobile isEqualToString:@""]) {
//                [self switchReminderView:true];
            } else if (!profileData.isupload_avatar) {
//                [self switchReminderView:false];
            } else {
                [self touchUploadAvatarReminderCloseButton:nil];
            }
            
            [userDefaultManager saveUserProfileData:profileData];
            [_tabbar updateFlowerValue];
//            [self initProfile];
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
                
//                self.achievementButton.enabled = true;

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
//        [self.GBSView setHidden:NO];
        if([profileData.gsb_medal isEqualToString:@"B"])
        {
//            self.imageGBS.image = [UIImage imageNamed:NSLocalizedString(@"Icon_Flag_Bronze", )];
        }
        else if([profileData.gsb_medal isEqualToString:@"S"])
        {
//            self.imageGBS.image = [UIImage imageNamed:NSLocalizedString(@"Icon_Flag_Silver", )];
        }
        else if([profileData.gsb_medal isEqualToString:@"G"])
        {
//            self.imageGBS.image = [UIImage imageNamed:NSLocalizedString(@"Icon_Flag_Gold", )];
        }
    }
    else
    {
//        [self.GBSView setHidden:YES];
    }
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
//            [_tableView reloadData];
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
//                [_tableView reloadData];
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
//            [_tableView reloadData];
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
//            [self.tableView reloadData];
        } else {
            [Support addErrorMessage:response.message intoView:self.view];
        }
        [spinner stopAnimating];
        
    } ErrorHandlure:^(NSError *error) {
        [spinner stopAnimating];
    }];
}

#pragma achievement

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

    postID = @"";
    
    [self loadProfileMeUsingAPI];
    [self loadMembershipAPI];
    
//    [_tableView.pullToRefreshView stopAnimating];
}

- (void)bellNotification_didSelect{
    NotificationViewController *view = [[NotificationViewController alloc] initWithNibName:@"NotificationViewController" bundle:nil];
    
    view.hidesBottomBarWhenPushed = TRUE;
    [self.navigationController pushViewController:view animated:TRUE];
}

- (void)touchSettingsButton
{

    BloomerActionSheet* menuSetting = [BloomerActionSheet createInView: [[[UIApplication sharedApplication] delegate] window] data:[NSArray arrayWithObjects: [AppHelper getLocalizedString:@"menuSetting.albumCollection"], [AppHelper getLocalizedString:@"menuSetting.setting"], [AppHelper getLocalizedString:@"menuSetting.terms"], [AppHelper getLocalizedString:@"menuSetting.policy"], nil] selectIndex:^(NSInteger index) {
        switch (index) {
            case 0:
                NSLog(@"Select Album Collection");
                break;
            case 1:
                [self touchItemSetting];
                break;
            case 2:
                [self touchItemTerms];
                break;
            case 3:
                [self touchItemPolicy];
                break;
            default:
                break;
        }
    }];
    [menuSetting showWithAnimation:TRUE];
}


- (IBAction)onSwitchAlbumsAndAchievements:(id)sender{
    currentIndex = ((UIButton*)sender).tag;
//    [_tableView reloadData];
    
}


- (IBAction)touchUploadButton:(id)sender
{
    if([profileData.city.city_short_name isEqualToString:k_UNKNOWN_LOCATION]) {
        SelectCityViewController *view = [[SelectCityViewController alloc] initWithNibName:@"SelectCityViewController" bundle:nil];
        view.hidesBottomBarWhenPushed = YES;
        __weak MyProfileViewController *weakSelf = self;
        view.complete = ^{
            weakSelf.profileData = [userDefaultManager getUserProfileData];
            [weakSelf pushUpdateAvatarVC];
        };
        [self.navigationController pushViewController:view animated:YES];
    }
    else if (!profileData.isupload_avatar)
    {
        [self btnEditAvatar_Pressed];
    }
    else
    {
        imagePickerPopup = [[ImagePickerPopUpViewController alloc] initWithNibName:@"ImagePickerPopUpViewController" bundle:nil];
        imagePickerPopup.parentView = self;
        imagePickerPopup.isUploadAvatar = false;
        [imagePickerPopup showInView:[[[UIApplication sharedApplication] delegate] window] animated:true];
    }
}

- (IBAction)touchActiveRaces:(id)sender {
    activeRaces = TRUE;
    //    [_activeRacesButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    //    [_closeRacesButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    _achieveData = _activeAchieveData;
//    [_tableView reloadData];
}

- (IBAction)touchCloseRaces:(id)sender {
    activeRaces = FALSE;
    //    [_activeRacesButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [_closeRacesButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _achieveData = _closedAchieveData;
//    [_tableView reloadData];
}

- (IBAction)touchCurrentRank:(id)sender {
//    [_currentRankButton setTitleColor:[UIColor colorWithRed:0.612 green:0 blue:0.078 alpha:1.0] forState:UIControlStateNormal];
//    [_bestResultButton setTitleColor:[UIColor colorWithRed:0.682 green:0.682 blue:0.682 alpha:1.0] forState:UIControlStateNormal];
//    _currentRankButton.titleLabel.font = [UIFont fontWithName:@"SFUIDisplay-Semibold" size:14];
//    _bestResultButton.titleLabel.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:14];
    
    activeRaces = TRUE;
    _achieveData = _activeAchieveData;
//    [_tableView reloadData];
    
}

- (IBAction)touchBestResult:(id)sender {
//    [_currentRankButton setTitleColor:[UIColor colorWithRed:0.682 green:0.682 blue:0.682 alpha:1.0] forState:UIControlStateNormal];
//    [_bestResultButton setTitleColor:[UIColor colorWithRed:0.612 green:0 blue:0.078 alpha:1.0] forState:UIControlStateNormal];
//    _currentRankButton.titleLabel.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:14];
//    _bestResultButton.titleLabel.font = [UIFont fontWithName:@"SFUIDisplay-Semibold" size:14];
    
    activeRaces = FALSE;
    _achieveData = _closedAchieveData;
    //    _achieveData = _activeAchieveData;
//    [_tableView reloadData];
}

#pragma mark - More Functions
//- (void)swingNotiBellView:(NSTimer *)_timer {
//    UIButton *btnNoti = (UIButton *) _timer.userInfo;
//    if (btnNoti) {
//        [btnNoti swing:nil];
//    }
//}

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

- (IBAction)TouchFlowerButton:(id)sender {
    
    FlowerGardenViewController *view;
    
    view = [[FlowerGardenViewController alloc] initWithNibName:@"FlowerGardenViewController" bundle:nil];
    [_tabbar snapbackFlowerIconToTabbar];
    view.hidesBottomBarWhenPushed = TRUE;
    [self.navigationController pushViewController:view animated:TRUE];
    
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
//    self.uploadAvatarReminderViewHeight.constant = 0;
//    topFrame = CGRectMake(0, 0, self.view.bounds.size.width, TOPVIEW_DEFAULT_HEIGHT);
//    [_topView setFrame:topFrame];
//    _tableView.tableHeaderView = _topView;
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

// MARK: - Selectors
- (void)updateAboutMe:(NSNotification*)notification
{
    NSString* aboutMe = [[notification userInfo] objectForKey:[NotificationKey AboutMe]];
    [self initAboutMe:aboutMe];
}

- (void)updateProfileName:(NSNotification*)notification
{
    NSString* name = [[notification userInfo] objectForKey:[NotificationKey ProfileName]];
//    self.name.text = name;
}

- (void)updateProfileUsername:(NSNotification*)notification
{
    NSString* username = [[notification userInfo] objectForKey:[NotificationKey ProfileUsername]];
    self.username.text = username;
    self.navigationItem.title = username;
}


@end

