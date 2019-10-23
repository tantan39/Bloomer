//
//  RaceListsViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 1/26/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "RaceListsViewController.h"
#import "AppHelper.h"
#import "RaceListView.h"
#import "JoinRaceByTopicView.h"
#import "JoinInfoPopupViewController.h"
#import "BrowserViewController.h"
#import "API_BannerMarketing.h"
#import "BannerView.h"
#import "RaceAlertView.h"
#import "Popup_InvteToGsb.h"
#import <CoreSpotlight/CoreSpotlight.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "API_PopUpTopWinners.h"
#import "PopUpTopWinners.h"
#import "RaceInfoPopUpView.h"

@interface RaceListsViewController ()
{
    BOOL isAvailable;
    NSMutableArray *listCategory;
    NSMutableDictionary *maleRacesByCategory;
    NSMutableDictionary *femaleRacesByCategory;
    UserDefaultManager *userDefaultManager;
    NSString* currentLocation;
    NSInteger currentGender;
    NSInteger currentPopUp;
    NSString *needToPushRaceKey;
    out_profile_fetch *profileData;
    JoinInfoPopupViewController *joinPopup;
    JoinRaceByTopicView *joinRaceView;
    
    NSMutableArray* dataFormaketing;
    NSUInteger currentMaketingPopup;
    NSInteger PopupMaketingCount;
    NSMutableArray* arrayMaketingPopup;
    
    NSMutableArray* popupArray;
    races_list* lastSelectedRace;
    
    Popup_InvteToGsb *popup_invite_gsb;
}

@property (strong, nonatomic) NSMutableArray *marketingBanners;

@end

@implementation RaceListsViewController
@synthesize badgeNumber, chatBadgeNumber;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.marketingBanners = [[NSMutableArray alloc] init];
    arrayMaketingPopup = [[NSMutableArray alloc] init];
    PopupMaketingCount = 0;
    currentMaketingPopup = 0;
    
    // Do any additional setup after loading the view from its nib.
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    profileData = [userDefaultManager getUserProfileData];
    
    listCategory = [[NSMutableArray alloc] init];
    femaleRacesByCategory = [[NSMutableDictionary alloc]init];
    maleRacesByCategory = [[NSMutableDictionary alloc]init];
    currentGender = FEMALE;
    [self setupCollectionView];
    [self initNavigationBar];
//    [self ConnectChatServer];
    [self loadBannerMarketing];
    
    
    out_profile_fetch * user = [userDefaultManager getUserProfileData];
    if([user.city.city_short_name isEqualToString:k_UNKNOWN_LOCATION])
    {
        SelectCityViewController *view = [[SelectCityViewController alloc] initWithNibName:@"SelectCityViewController" bundle:nil];
        view.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:view animated:YES];
    }
    
//     [self loadAllRaceList];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSwitchLocationContest:) name:[NotificationNames SwitchLocationContest] object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupLanguage];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[NotificationNames CompleteConfirmingJoiningRace] object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[NotificationNames GoToSpecificRace] object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[NotificationNames TouchJoinButton] object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(completingConfirmingJoiningRace:) name:[NotificationNames CompleteConfirmingJoiningRace] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToSpecificRace:) name:[NotificationNames GoToSpecificRace] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchJoinButton:) name:[NotificationNames TouchJoinButton] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openVideo:) name:[NotificationNames OpenVideo] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openRaceInfoLink:) name:[NotificationNames OpenRaceInfoLink] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openGift:) name:[NotificationNames OpenGift] object:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Top_bar_base"] forBarMetrics:UIBarMetricsDefault];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[NotificationNames OpenVideo] object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[NotificationNames OpenRaceInfoLink] object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[NotificationNames OpenGift] object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[NotificationNames TouchJoinButton] object:nil];
}

- (void)setupLanguage
{
    [self.buttonFemale setTitle:[AppHelper getLocalizedString:@"RaceList.buttonFemale"] forState:UIControlStateNormal];
    [self.buttonMale setTitle:[AppHelper getLocalizedString:@"RaceList.buttonMale"] forState:UIControlStateNormal];
}

- (void)initNavigationBar
{
    [AppHelper setTitleViewForNavigationBar:self.navigationItem title:NSLocalizedString(@"Contests", "")];
    
}

-(void) loadPopupCountry
{
    API_PopupMembership *request = [[API_PopupMembership alloc] initWithAccessToken:[userDefaultManager getAccessToken] deviceId:[userDefaultManager getDeviceToken]];
    [request getRequest:^(BaseJSON *json, RestfulResponse *data) {
        if(data.status)
        {
            JSON_PopupMembership *model = (JSON_PopupMembership*)json;
            
            if(model.hasInvitation)
            {
                popup_invite_gsb = [[Popup_InvteToGsb alloc] initWithNibName:@"Popup_InvteToGsb" bundle:nil];
                [popup_invite_gsb loadPopupWithImageLink:model.imgInviteLink message:model.msgInvite];
                popup_invite_gsb.view.frame = [UIScreen mainScreen].bounds; // Get device's bounds
                [popup_invite_gsb showInView:[[[UIApplication sharedApplication] delegate] window] animated:YES];
            }
        }
    } ErrorHandlure:^(NSError *error) {
        
    }];
    
    API_PopUpTopWinners *apiTopWinners = [[API_PopUpTopWinners alloc] initWithAccessToken:[userDefaultManager getAccessToken] deviceToken:[userDefaultManager getDeviceToken]];
    [apiTopWinners request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        if (response.status)
        {
            JSON_TopWinners *topWinners = (JSON_TopWinners*)jsonObject;
            if (topWinners.topWinners.count > 0)
            {
                PopUpTopWinners *popUp = [PopUpTopWinners createInView:[UIApplication sharedApplication].keyWindow topWinners:topWinners.topWinners flowers:topWinners.flower navigation:self.navigationController];
                [popUp showWithAnimated:true];
            }
        }
    } ErrorHandlure:^(NSError *error) {
        
    }];
}

- (void)setupCollectionView
{
    __weak RaceListsViewController *weakSelf = self;
    [self.femaleCollectionView addPullToRefreshWithActionHandler:^{
//        [weakSelf loadFemaleRaceList];
        [weakSelf loadBannerMarketing];
    }];
    
    [self.maleCollectionView addPullToRefreshWithActionHandler:^{
//        [weakSelf loadMaleRaceList];
        [weakSelf loadBannerMarketing];
    }];
    
    [self.femaleCollectionView registerNib:[UINib nibWithNibName:[RaceListHeaderView nibName] bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[RaceListHeaderView viewIdentifier]];
    [self.maleCollectionView registerNib:[UINib nibWithNibName:[RaceListHeaderView nibName] bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[RaceListHeaderView viewIdentifier]];
    [self.femaleCollectionView registerNib:[UINib nibWithNibName:[RaceListCell nibName] bundle:nil] forCellWithReuseIdentifier:[RaceListCell cellIdentifier]];
    [self.maleCollectionView registerNib:[UINib nibWithNibName:[RaceListCell nibName] bundle:nil] forCellWithReuseIdentifier:[RaceListCell cellIdentifier]];
}

- (void)reloadAllRaceLists {
    [self loadAllRaceList];
}

- (NSString *)daySuffixForDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //    if(YSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO)
    calendar.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSInteger dayOfMonth = [calendar component:NSCalendarUnitDay fromDate:date];
    switch (dayOfMonth) {
        case 1:
        case 21:
        case 31: return @"st";
        case 2:
        case 22: return @"nd";
        case 3:
        case 23: return @"rd";
        default: return @"th";
    }
}

- (void)ConnectChatServer
{
    if ([userDefaultManager getAuthSession] == nil) {
        NSString *secret_ejab = [userDefaultManager generateSecretClient];
        NSString *encryptedCredentialEjab = [userDefaultManager encryptDESByKey:[userDefaultManager getAppKey]
                                                                           data:[userDefaultManager getCredentialEjab]
                                                                             iv:secret_ejab];
        NSString *encryptedSecretEjab = [userDefaultManager encryptDESByKey:[userDefaultManager getAppKey]
                                                                       data:secret_ejab iv:[userDefaultManager getAppSecret]];
        
        API_Message_Connect *messageConnectAPI = [[API_Message_Connect alloc] initWithSecret_Ejab:encryptedSecretEjab
                                                                                      credential_ejab:encryptedCredentialEjab
                                                                                         device_token:[userDefaultManager getDeviceToken]];
        [messageConnectAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            out_message_connect * data = (out_message_connect *) jsonObject;
            if (response.status)
            {
                [userDefaultManager saveAuthSession:data.auth_session];
                [self initPullNotification];
            }
            
        } ErrorHandlure:^(NSError *error) {
            
        }];
    }
    else
    {
        [self initPullNotification];
    }
}

- (void)initPullNotification
{
//    _notificationPullAPI = [[API_Notification_Pull alloc] initWithAuth_Session:[userDefaultManager getAuthSession]
//                                                                    device_token:[userDefaultManager getDeviceToken]];
//    _notificationPullAPI.delegate = self;
//    [_notificationPullAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
//        out_notification_pull * data = (out_notification_pull *) jsonObject;
//        if (response.status)
//        {
//            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//
//            if(data.isFreshRace == HAS_NEW_UPDATES){
//                [self getTopViewController];
//            }
//
//            if (appDelegate.pullNotificationAPI != _notificationPullAPI)
//            {
//                _notificationPullAPI = appDelegate.pullNotificationAPI;
//            }
//
//            if (data.redirect_url != nil ){
//
//                [appDelegate.pullAPITimer invalidate];
//
//                if ([userDefaultManager getAccessToken]) {
//                    API_Message_RefreshToken *refreshAPI = [[API_Message_RefreshToken alloc] initWithAddressLink:data.redirect_url
//                                                                                                    access_token:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken]];
//                    [refreshAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
//                        out_message_refresh_token * data = (out_message_refresh_token *) jsonObject;
//                        if (response.status)
//                        {
//                            [userDefaultManager saveAuthSession:data.auth_session];
//                            [self initPullNotification];
//                        }
//                        else
//                        {
//
//                        }
//
//                    } ErrorHandlure:^(NSError *error) {
//
//                    }];
//                }
//            }
//            else
//            {
//                // save notification number and chat notification number
//                [userDefaultManager saveNotificationNumber:data.notification];
//                [userDefaultManager saveChatNotificationNumber:data.message];
//
//                [self forceMyProfileUpdateChatNotificationNumber];
//                [appDelegate updateShowingNofitication];
//            }
//        }
//
//    } ErrorHandlure:^(NSError *error) {
//
//    }];
//
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    appDelegate.pullNotificationAPI = _notificationPullAPI;
//    appDelegate.pullAPITimer = [NSTimer scheduledTimerWithTimeInterval:NOTIFICATION_PULL_DURATION
//                                                                target:[WeakLinkObj weakObjectWithRealTarget:self]
//                                                              selector:@selector(pullNotification) userInfo:nil repeats:YES];
}

- (void)pullNotification
{
    [_notificationPullAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        out_notification_pull *data = (out_notification_pull *)jsonObject;
        if (response.status)
        {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            
            if(data.isFreshRace == HAS_NEW_UPDATES){
                [self getTopViewController];
            }
            
//            if (appDelegate.pullNotificationAPI != _notificationPullAPI)
//            {
//                _notificationPullAPI = appDelegate.pullNotificationAPI;
//            }
            
            if (data.redirect_url != nil )
            {
//                [appDelegate.pullAPITimer invalidate];
//                appDelegate.pullAPITimer = nil;
                
                if ([userDefaultManager getAccessToken].length) {
                    API_Message_RefreshToken *refreshAPI = [[API_Message_RefreshToken alloc] initWithAddressLink:data.redirect_url
                                                                                                    access_token:[userDefaultManager getAccessToken]
                                                                                                    device_token:[userDefaultManager getDeviceToken]];
                    [refreshAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                        out_message_refresh_token * data = (out_message_refresh_token *) jsonObject;
                        if (response.status)
                        {
                            [userDefaultManager saveAuthSession:data.auth_session];
                            [self initPullNotification];
                        }
                        else
                        {
                            
                        }
                    } ErrorHandlure:^(NSError *error) {
                        
                    }];
                }
            }
            else
            {
                // save notification number and chat notification number
                [userDefaultManager saveNotificationNumber:data.notification];
                [userDefaultManager saveChatNotificationNumber:data.message];
                [self forceMyProfileUpdateChatNotificationNumber];
                [appDelegate updateShowingNofitication];
            }
        }
        
    } ErrorHandlure:^(NSError *error) {
        
    }];
}

- (void)indexLeaderboardsToSpotlightSearchWithGender:(NSInteger)gender leaderboardListInfo:(JSON_RaceList*)leaderboardListInfo
{
    NSMutableArray *needIndexItems = [[NSMutableArray alloc] init];
    
    for (NSString* category in leaderboardListInfo.categoryList)
    {
        for (races_list* leaderboard in [leaderboardListInfo.racesByCategory objectForKey:category])
        {
//            NSString *objectID = [NSString stringWithFormat:@"Bloomer_%@_%@", leaderboard.key, gender == 0 ? @"Female" : @"Male"];
//            NSLog(@"ID: %@", objectID);
//
//            NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:kSpotlightSearchLeaderboard];
//            [userActivity setEligibleForSearch:true];
//            [userActivity setEligibleForHandoff:true];
//            [userActivity setEligibleForPublicIndexing:true];
//            userActivity.title = [NSString stringWithFormat:@"Bloomer_%@_%@", leaderboard.key, gender == 0 ? @"Female" : @"Male"];
//            userActivity.userInfo = @{k_RACEKEY: leaderboard.key, k_GENDER: [NSNumber numberWithInteger:gender]};
//            userActivity.contentAttributeSet = [leaderboard searchableItemAttributeSetWithGender:gender];
//            userActivity.needsSave = true;
//
//            self.userActivity = userActivity;
//            [self.userActivity becomeCurrent];
            
            [needIndexItems addObject:[leaderboard searchableItemItemWithGender:gender]];
        }
    }
    
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:needIndexItems completionHandler:^(NSError * _Nullable error) {
    }];
}

//MARK: - Handle API_NotificationPull_Delegate
- (void)getDataNotification_Pull:(out_notification_pull *)data Response:(RestfulResponse *)response{
    if (response.status)
    {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        appDelegate.pullNotificationAPI = _notificationPullAPI;
//        appDelegate.pullAPITimer = [NSTimer scheduledTimerWithTimeInterval:NOTIFICATION_PULL_DURATION
//                                                                    target:[WeakLinkObj weakObjectWithRealTarget:self]
//                                                                  selector:@selector(pullNotification) userInfo:nil repeats:YES];
        if(data.isFreshRace == HAS_NEW_UPDATES){
            [self getTopViewController];
        }
        
//        if (appDelegate.pullNotificationAPI != _notificationPullAPI)
//        {
//            _notificationPullAPI = appDelegate.pullNotificationAPI;
//        }
        
        if (data.redirect_url != nil )
        {
//            [appDelegate.pullAPITimer invalidate];
//            appDelegate.pullAPITimer = nil;
            if ([userDefaultManager getAccessToken].length) {
                API_Message_RefreshToken *refreshAPI = [[API_Message_RefreshToken alloc] initWithAddressLink:data.redirect_url
                                                                                                access_token:[userDefaultManager getAccessToken]
                                                                                                device_token:[userDefaultManager getDeviceToken]];
                [refreshAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                    out_message_refresh_token * data = (out_message_refresh_token *) jsonObject;
                    if (response.status)
                    {
                        [userDefaultManager saveAuthSession:data.auth_session];
                        [self initPullNotification];
                    }
                    else
                    {
                        
                    }
                } ErrorHandlure:^(NSError *error) {
                    
                }];
            }
            
        }
        else
        {
            // save notification number and chat notification number
            [userDefaultManager saveNotificationNumber:data.notification];
            [userDefaultManager saveChatNotificationNumber:data.message];
             [self forceMyProfileUpdateChatNotificationNumber];
            [appDelegate updateShowingNofitication];
        }
    }

}

- (UIViewController *)getTopViewController
{
    NSArray *viewContrlls=[[self navigationController] viewControllers];
    UIViewController *topViewController = [viewContrlls lastObject];
    
    if([topViewController isKindOfClass:[RacesViewController class]])
    {
        [(RacesViewController*)topViewController showUpdateRace];
    }
    
    return topViewController;
}

-(void)didConfirmationPopupOK:(NSInteger) locID
{
    UserDefaultManager *userManager = [(AppDelegate *)[UIApplication sharedApplication].delegate getUserManager];
    location *param = [[location alloc] initWithAccess_Token:[userManager getAccessToken] device_token:[userManager getDeviceToken] locationID:locID];
    if (param) {
        API_Profile_Location *api = [[API_Profile_Location alloc] initWithParams:param];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
            
            if (response.status)
            {
                [self loadAllRaceList];
                RacesViewController *view = [[RacesViewController alloc] initWithNibName:@"RacesViewController" bundle:nil];
                view.key = needToPushRaceKey;
                view.gender = profileData.gender;
                __weak RaceListsViewController* weakSelf = self;
                view.OnRaceJoined = ^{
                    [weakSelf loadAllRaceList];
                };
                [self.navigationController pushViewController:view animated:YES];
            }
        } ErrorHandlure:^(NSError *error) {
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        }];
        
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
    }

}

-(NSString *)getCurrentDay
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSString* day = [NSString stringWithFormat: @"%ld", (long)[components day]];
    NSString* month = [NSString stringWithFormat: @"%ld", (long)[components month]];
    NSString* currentYear = [NSString stringWithFormat: @"%ld", (long)[components year]];
    NSString* result = [[day stringByAppendingString:month] stringByAppendingString:currentYear];
    return result;
}

// MARK: - Functions
- (void)animateLine:(CGFloat)x
{
    self.animatedLineLeftMargin.constant = x;
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.animatedLine layoutIfNeeded];
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)changeStyleForTabBarButton:(UIButton*)button enabled:(BOOL)enabled
{
    if (enabled)
    {
        button.titleLabel.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:13];
    }
    else
    {
        button.titleLabel.font = [UIFont fontWithName:@"SFUIDisplay-Bold" size:13];
    }
    
    button.enabled = enabled;
}

// MARK: - API Functions

- (void)loadBannerMarketing
{
    __weak typeof(self) weakSelf = self;
    API_BannerMarketing *request = [[API_BannerMarketing alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken]];
    [request getRequest:^(BaseJSON *json, RestfulResponse *data) {
        if(data.status) {
            Json_BannerMarketing *model = (Json_BannerMarketing *)json;
            if (weakSelf) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                strongSelf.marketingBanners = model.banners;
                [strongSelf.maleCollectionView reloadData];
                [strongSelf.femaleCollectionView reloadData];
            }
        }
        [self loadAllRaceList];
    } ErrorHandlure:^(NSError *error) {
        [weakSelf.femaleCollectionView.pullToRefreshView stopAnimating];
        [weakSelf.maleCollectionView.pullToRefreshView stopAnimating];
    }];
}

- (void)loadFemaleRaceList
{
    __weak typeof(self) weakSelf = self;
    API_RaceList *request = [[API_RaceList alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] gender:0];
    [request getRequest:^(BaseJSON *json, RestfulResponse *data) {
        if(data.status)
        {
            JSON_RaceList *model = (JSON_RaceList *)json;
            
            if (SYSTEM_VERSION_GREATER_THAN(@"8"))
            {
                [weakSelf indexLeaderboardsToSpotlightSearchWithGender:0 leaderboardListInfo:model];
            }
            
            if (weakSelf)
            {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                listCategory = [model categoryList];
                femaleRacesByCategory = [model racesByCategory];
                [strongSelf.femaleCollectionView reloadData];
            }
        }
        [[weakSelf.femaleCollectionView pullToRefreshView] stopAnimating];
        [self loadMaleRaceList];
    } ErrorHandlure:^(NSError *error) {
        [[weakSelf.femaleCollectionView pullToRefreshView] stopAnimating];
    }];
}

- (void)loadMaleRaceList
{
    __weak typeof(self) weakSelf = self;
    API_RaceList *request = [[API_RaceList alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] gender:1];
    [request getRequest:^(BaseJSON *json, RestfulResponse *data) {
        if(data.status)
        {
            JSON_RaceList *model = (JSON_RaceList*)json;
            
            if (SYSTEM_VERSION_GREATER_THAN(@"8"))
            {
                [self indexLeaderboardsToSpotlightSearchWithGender:1 leaderboardListInfo:model];
            }
            
            if (weakSelf)
            {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                listCategory = [model categoryList];
                maleRacesByCategory = [model racesByCategory];
                [strongSelf.maleCollectionView reloadData];
            }
        }
        [[weakSelf.maleCollectionView pullToRefreshView] stopAnimating];
        [AppHelper showPopUpMarketing];
        [self loadPopupCountry];
        
    } ErrorHandlure:^(NSError *error) {
        [[weakSelf.maleCollectionView pullToRefreshView] stopAnimating];
    }];
}

- (void)loadAllRaceList
{
    [[CSSearchableIndex defaultSearchableIndex] deleteSearchableItemsWithDomainIdentifiers:@[kSpotlightSearchLeaderboard] completionHandler:^(NSError * _Nullable error) {
    }];
    
    [self loadFemaleRaceList];
//    [self loadMaleRaceList];
}

// MARK: - UICollectionViewDelegate, FlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGFloat bannerViewHeight = self.marketingBanners.count != 0 ? 0 : -114;
    
    if (listCategory.count > 0)
    {
        NSString *sponsoredCategory = [listCategory objectAtIndex:3];
        NSMutableArray *sponsoredRaces = [femaleRacesByCategory objectForKey:sponsoredCategory];
        NSString *specialityCategory = [listCategory objectAtIndex:2];
        NSMutableArray *themedRaces = [femaleRacesByCategory objectForKey:specialityCategory];
        NSString *exclusiveCategory = [listCategory objectAtIndex:4];
        NSMutableArray *exclusiveRaces = [femaleRacesByCategory objectForKey:exclusiveCategory];
        
        if (collectionView == self.maleCollectionView)
        {
            sponsoredRaces = [maleRacesByCategory objectForKey:sponsoredCategory];
            exclusiveRaces = [maleRacesByCategory objectForKey:exclusiveCategory];
        }
        
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        
        CGFloat sponsoredViewHeight = 0;
        for (races_list *race in sponsoredRaces) {
            sponsoredViewHeight += race.logo.length ? screenWidth * 23 / 31 : screenWidth;
        }
        
        return CGSizeMake(screenWidth, bannerViewHeight + 684 + (sponsoredRaces.count > 0 ? sponsoredViewHeight : 0) + (exclusiveRaces.count > 0 ? 30 + screenWidth * exclusiveRaces.count : 0) + (themedRaces.count > 0 ? -10 : -30) + (exclusiveRaces.count > 0 ? 10 : 0) + (sponsoredRaces.count > 0 ? 10 : 0) );
    }
    else
    {
//        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//        return CGSizeMake(screenWidth, 10 + (screenWidth * 23 / 31) + 200 + 10 + 30 + bannerViewHeight);
        return CGSizeZero;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    RaceListHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[RaceListHeaderView viewIdentifier] forIndexPath:indexPath];
    view.themeTopSpace.constant = 0;
    view.themedViewHeight.constant = 0;
    
    if (listCategory.count > 0)
    {
        NSString *countryCategory = [listCategory objectAtIndex:0];
        NSString *specialityCategory = [listCategory objectAtIndex:2];
        NSString *locationCategory = [listCategory objectAtIndex:1];
        NSString *sponsoredCategory = [listCategory objectAtIndex:3];
        NSString *exclusiveCategory = [listCategory objectAtIndex:4];
        NSMutableArray *countryRaces = [femaleRacesByCategory objectForKey:countryCategory];
        NSMutableArray *locationRaces = [femaleRacesByCategory objectForKey:locationCategory];
        NSMutableArray *sponsoredRaces = [femaleRacesByCategory objectForKey:sponsoredCategory];
        NSMutableArray *themedRaces = [femaleRacesByCategory objectForKey:specialityCategory];
        NSMutableArray *exclusiveRaces = [femaleRacesByCategory objectForKey:exclusiveCategory];
        
        if(themedRaces.count > 0) {
            view.themeTopSpace.constant = 10;
            view.themedViewHeight.constant = 30;
        }
        
        view.gender = 0;
        
        if (collectionView == self.maleCollectionView)
        {
            countryRaces = [maleRacesByCategory objectForKey:countryCategory];
            locationRaces = [maleRacesByCategory objectForKey:locationCategory];
            sponsoredRaces = [maleRacesByCategory objectForKey:sponsoredCategory];
            exclusiveRaces = [maleRacesByCategory objectForKey:exclusiveCategory];
            view.gender = 1;
        }
        
        races_list *countryRace = (races_list*)[countryRaces objectAtIndex:indexPath.row];
        [view initSliderCountryView:countryRace.countryAvatarList];
        
        races_list *firstLocationRace = (races_list*)[locationRaces firstObject];
        
        view.labelCountryTitle.text = countryRace.name;
        view.labelLocationTitle.text = firstLocationRace.name;
        
        if (countryRace.avatar != nil)
        {
            [view.countryAvatar setImageWithURL:[NSURL URLWithString:countryRace.avatar]];
        }
        else
        {
            view.countryAvatar.image = [UIImage imageNamed:@"Image_Empty_Race"];
        }
        
        if (firstLocationRace.avatar != nil)
        {
            [view.locationAvatar setImageWithURL:[NSURL URLWithString:firstLocationRace.avatar]];
        }
        else
        {
            view.locationAvatar.image = [UIImage imageNamed:@"Image_Empty_Race"];
        }
        
        if([firstLocationRace.gift isEqualToString:@""])
        {
            [view.buttonFirstGift setHidden:YES];
        }
        else
        {
            [view.buttonFirstGift setHidden:NO];
        }
        
        if (firstLocationRace.isClosed)
        {
            [view switchActionView:Closed];
        }
        else
        {
            if (firstLocationRace.is_join == RACE_NOT_ALLOW_TO_JOIN )
            {
                [view switchActionView:Closed];
            }
            else
            {
                if (firstLocationRace.is_join == RACE_NOT_JOINED)
                {
                    if (firstLocationRace.category == RACECATEGORY_LOCATION)
                    {
                        [view switchActionView:Switch];
                    }
                    else
                    {
                        [view switchActionView:NotJoined];
                    }
                }
                else // RACE_JOINED
                {
                    [view switchActionView:Joined];
                }
            }
        }
        
        if (locationRaces.count > 1)
        {
            if (locationRaces.count == 2)
            {
                view.moreLocationView.hidden = true;
                view.secondLocationView.hidden = false;
                
                races_list *secondLocationRace = (races_list*)[locationRaces objectAtIndex:1];
                view.secondLabelLocationTitle.text = secondLocationRace.name;
                
                if (secondLocationRace.avatar != nil)
                {
                    [view.secondLocationAvatar setImageWithURL:[NSURL URLWithString:secondLocationRace.avatar]];
                }
                else
                {
                    view.secondLocationAvatar.image = [UIImage imageNamed:@"Image_Empty_Race"];
                }
                
                if([secondLocationRace.gift isEqualToString:@""])
                {
                    [view.buttonSecondGift setHidden:YES];
                }
                else
                {
                    [view.buttonSecondGift setHidden:NO];
                }
                
                if (secondLocationRace.isClosed)
                {
                    [view switchSecondActionView:Closed];
                }
                else
                {
                    if (secondLocationRace.is_join == RACE_NOT_ALLOW_TO_JOIN )
                    {
                        [view switchSecondActionView:Closed];
                    }
                    else
                    {
                        if (secondLocationRace.is_join == RACE_NOT_JOINED)
                        {
                            if (secondLocationRace.category == RACECATEGORY_LOCATION)
                            {
                                [view switchSecondActionView:Switch];
                            }
                            else
                            {
                                [view switchSecondActionView:NotJoined];
                            }
                        }
                        else // RACE_JOINED
                        {
                            [view switchSecondActionView:Joined];
                        }
                    }
                }
            }
            else
            {
                view.labelMoreLocationTitle.text = [NSString stringWithFormat:@"+%ld %@", (long)locationRaces.count, [AppHelper getLocalizedString:@"RaceList.moreLocations"]];
                view.moreLocationView.hidden = false;
                view.secondLocationView.hidden = true;
            }
        }
        else
        {
            view.moreLocationView.hidden = true;
        }
        
        if (themedRaces.count > 0)
        {
            view.themedViewHeight.constant = 30;
        }
        else
        {
            view.themedViewHeight.constant = 0;
        }
        
        view.countryRaceKey = countryRace.key;
        view.giftForCountry = countryRace.gift;
        if([countryRace.gift isEqualToString:@""])
        {
            [view.buttonCountryGift setHidden:YES];
        }
        else
        {
            [view.buttonCountryGift setHidden:NO];
        }
        view.locationRaces = locationRaces;
        view.sponsoredRaces = sponsoredRaces;
        view.exclusiveRaces = exclusiveRaces;
        view.navigationController = self.navigationController;
        view.parentView = self;
        
        [view setupExclusiveLeaderboards];
        [view setupSponsoredLeaderboards];
        
        view.marketingBanners = self.marketingBanners;
        [view setupMarketingBannersView];
    }
    
    return view;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    return CGSizeMake(screenWidth / 2, [RaceListCell cellHeight]);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (listCategory.count != 0)
    {
        NSString *specialityCategory = [listCategory objectAtIndex:2];
        NSMutableArray *raceList = [femaleRacesByCategory objectForKey:specialityCategory];
        
        if (collectionView == self.maleCollectionView)
        {
            raceList = [maleRacesByCategory objectForKey:specialityCategory];
        }
        
        return raceList.count;
    }
    else
    {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    RaceListCell *cell = (RaceListCell*)[collectionView dequeueReusableCellWithReuseIdentifier:[RaceListCell cellIdentifier] forIndexPath:indexPath];
    
    if (indexPath.row % 2) // odd
    {
        cell.mainViewLeftMargin.constant = 2.5;
    }
    else // even
    {
        cell.mainViewRightMargin.constant = 2.5;
    }
    
    NSString *specialityCategory = [listCategory objectAtIndex:2];
    NSMutableArray *raceList = [femaleRacesByCategory objectForKey:specialityCategory];
    
    if (collectionView == self.maleCollectionView)
    {
        raceList = [maleRacesByCategory objectForKey:specialityCategory];
    }
    
    races_list *race = (races_list*)[raceList objectAtIndex:indexPath.row];
    cell.labelTitle.text = race.name;
    
    if (race.avatar != nil)
    {
        [cell.avatar setImageWithURL:[NSURL URLWithString:race.avatar]];
    }
    else
    {
        cell.avatar.image = [UIImage imageNamed:@"Image_Empty_Race"];
    }
    
    if([race.gift isEqualToString:@""])
    {
        [cell.buttonGift setHidden:YES];
    }
    else
    {
        [cell.buttonGift setHidden:NO];
    }
    
    if (race.isClosed)
    {
        [cell switchActionView:Closed];
        
        cell.labelTime.text = NSLocalizedString(@"Closed",);
    }
    else
    {
        if (race.is_join == RACE_NOT_ALLOW_TO_JOIN )
        {
            [cell switchActionView:Closed];
        }
        else
        {
            if (race.is_join == RACE_NOT_JOINED)
            {
                if (race.category == RACECATEGORY_LOCATION)
                {
                    [cell switchActionView:Switch];
                }
                else
                {
                    [cell switchActionView:NotJoined];
                }
            }
            else // RACE_JOINED
            {
                [cell switchActionView:Joined];
            }
        }
        
        cell.raceData = race;
        
        if (collectionView == self.maleCollectionView)
        {
            cell.gender = MALE;
        }
        else
        {
            cell.gender = FEMALE;
        }
        if (race.category > RACECATEGORY_LOCATION)
        {
            cell.labelTime.text = [NSString stringWithFormat:@"%@", race.endDate];
        }
        else
        {
            cell.labelTime.text =@"";
            
        }
    }
    
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *specialityCategory = [listCategory objectAtIndex:2];
    NSMutableArray *raceList = [femaleRacesByCategory objectForKey:specialityCategory];
    
    if (collectionView == self.maleCollectionView)
    {
        raceList = [maleRacesByCategory objectForKey:specialityCategory];
    }
    
    races_list *race = (races_list*)[raceList objectAtIndex:indexPath.row];
    
    if (!race.isClosed)
    {
        RacesViewController *view = [[RacesViewController alloc] initWithNibName:@"RacesViewController" bundle:nil];
        view.key = race.key;
        view.gender = currentGender;
        view.avatarRace = race.avatar;
        __weak RaceListsViewController* weakSelf = self;
        view.OnRaceJoined = ^{
            [weakSelf loadAllRaceList];
        };
        [self.navigationController pushViewController:view animated:YES];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:race.closedURL]];
    }
}

// MARK: - Actions
- (IBAction)touchButtonFemale:(id)sender {
    [self animateLine:self.buttonFemale.frame.origin.x];
    [self.scrollView scrollRectToVisible:CGRectMake(self.femaleCollectionView.frame.origin.x, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:true];
    currentGender = FEMALE;
    [self changeStyleForTabBarButton:self.buttonFemale enabled:false];
    [self changeStyleForTabBarButton:self.buttonMale enabled:true];
}

- (IBAction)touchButtonMale:(id)sender {
    [self animateLine:self.buttonMale.frame.origin.x];
    [self.scrollView scrollRectToVisible:CGRectMake(self.maleCollectionView.frame.origin.x, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:true];
    currentGender = MALE;
    [self changeStyleForTabBarButton:self.buttonFemale enabled:true];
    [self changeStyleForTabBarButton:self.buttonMale enabled:false];
}

// MARK: - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView)
    {
        CGFloat offsetX = scrollView.contentOffset.x;
        [self animateLine:offsetX / 2];
        
        if (offsetX == self.femaleCollectionView.frame.origin.x)
        {
            [self changeStyleForTabBarButton:self.buttonFemale enabled:false];
            [self changeStyleForTabBarButton:self.buttonMale enabled:true];
            currentGender = 0;
        }
        else
        {
            if (offsetX == self.maleCollectionView.frame.origin.x)
            {
                [self changeStyleForTabBarButton:self.buttonFemale enabled:true];
                [self changeStyleForTabBarButton:self.buttonMale enabled:false];
                currentGender = 1;
            }
        }
    }
}

// MARK: - Selectors
//- (void)needToReloadRaceList:(NSNotification*)notification
//{
//    [self loadAllRaceList];
//}

- (void)completingConfirmingJoiningRace:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSInteger locationID = [[userInfo objectForKey:[NotificationKey LocationID]] integerValue];
    NSString *key = [userInfo objectForKey:[NotificationKey Key]];
    needToPushRaceKey = key;
    
    UserDefaultManager *userManager = [(AppDelegate *)[UIApplication sharedApplication].delegate getUserManager];
    location *param = [[location alloc] initWithAccess_Token:[userManager getAccessToken] device_token:[userManager getDeviceToken] locationID:locationID];
    if (param) {
        __weak typeof(self) weakSelf = self;
        API_Profile_Location *api = [[API_Profile_Location alloc] initWithParams:param];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
            
            if (response.status) {
                if (weakSelf) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    [strongSelf loadAllRaceList];
                    RacesViewController *view = [[RacesViewController alloc] initWithNibName:@"RacesViewController" bundle:nil];
                    view.key = needToPushRaceKey;
                    view.gender = profileData.gender;
                    __weak RaceListsViewController* weakSelf = self;
                    view.OnRaceJoined = ^{
                        [weakSelf loadAllRaceList];
                    };
                    [strongSelf.navigationController pushViewController:view animated:YES];
                }
            }
        } ErrorHandlure:^(NSError *error) {
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        }];
        
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
    }

}

- (void)goToSpecificRace:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSInteger gender = [[userInfo objectForKey:[NotificationKey Gender]] integerValue];
    NSString *key = [userInfo objectForKey:[NotificationKey Key]];
    NSString *timeStamp = [userInfo objectForKey:[NotificationKey TimeStampKey]];
    NSInteger gsb = [[userInfo objectForKey:[NotificationKey Gsb]] integerValue];

    RacesViewController *raceViewController = [[RacesViewController alloc] initWithNibName:@"RacesViewController" bundle:nil];
    raceViewController.gsb = gsb;
    raceViewController.key = key;
    raceViewController.gender = gender;
    raceViewController.timeStamp = timeStamp;
    __weak RaceListsViewController* weakSelf = self;
    raceViewController.OnRaceJoined = ^{
        [weakSelf loadAllRaceList];
    };
    
    [self.navigationController pushViewController:raceViewController animated:YES];
}

- (void)touchJoinButton:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    races_list *raceData = (races_list*)[userInfo objectForKey:[NotificationKey RaceData]];
    lastSelectedRace = raceData;
    NSInteger gender = [[userInfo objectForKey:[NotificationKey Gender]] integerValue];
    
    if (raceData.category == 3 || raceData.category == 4 || raceData.category == 5)
    {
        joinRaceView = [[JoinRaceByTopicView alloc] initWithNibName:@"JoinRaceByTopicView" bundle:nil];
        __weak RaceListsViewController* weakSelf = self;
        joinRaceView.OnRaceJoined = ^{
            [weakSelf loadAllRaceList];
        };
        joinRaceView.key = lastSelectedRace.key;
        joinRaceView.raceNames = lastSelectedRace.name;
        joinRaceView.locationID = lastSelectedRace.locationID;
        joinRaceView.categoryType = lastSelectedRace.category;
        joinRaceView.rules = lastSelectedRace.joinInfo;
        joinRaceView.sEndTime = lastSelectedRace.endDate;
        joinRaceView.gender = [userDefaultManager getUserProfileData].gender;
        joinRaceView.avatar = lastSelectedRace.avatar;
        joinRaceView.gsb = lastSelectedRace.gsb;
        joinRaceView.parentView = self;

        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate updateShowingNofitication];
        joinRaceView.hidesBottomBarWhenPushed = YES;
        joinRaceView.myNavigationController = self.navigationController;
        [self.navigationController pushViewController:joinRaceView animated:YES];
    }
    else
    {
        joinPopup = [[JoinInfoPopupViewController alloc] initWithNibName:@"JoinInfoPopupViewController" bundle:nil];
        
        __weak RaceListsViewController* weakSelf = self;
        joinPopup.OnRaceJoined = ^{
            [weakSelf loadAllRaceList];
        };
        
        joinPopup.key = raceData.key;
        joinPopup.raceNames = raceData.name;
        joinPopup.locationID = raceData.locationID;
        joinPopup.categoryType = raceData.category;
        joinPopup.rules = raceData.joinInfo;
        joinPopup.sEndTime = raceData.endDate;
        joinPopup.parentView = self;
        
        joinPopup.view.frame = [UIScreen mainScreen].bounds; // Get device's bounds
        [joinPopup showInView:[[[UIApplication sharedApplication] delegate] window] animated:TRUE];
        [joinPopup showInView:nil withCompletionHandler:^(NSString *buttonTitle, NSInteger locationID) {
            [NotificationHelper postNotificationForCompletingConfirmingJoiningRace:gender key:raceData.key];
        }];
    }
}

- (void) handleSwitchLocationContest:(NSNotification *) noti{
    [self loadAllRaceList];
}

- (void)forceMyProfileUpdateChatNotificationNumber
{
    UINavigationController *navigationController = (UINavigationController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
    
    for (UIViewController* viewController in navigationController.visibleViewController.navigationController.viewControllers)
    {
        if ([viewController isKindOfClass:[TabBarViewController class]])
        {
            TabBarViewController* tabBarViewController = (TabBarViewController*)viewController;
            UINavigationController* profileNavigationViewController = tabBarViewController.viewControllers[kTabBarProfileIndex];
            MyProfileViewController* profileViewController = profileNavigationViewController.viewControllers.firstObject;
            [profileViewController updateNotificationNumber];
            break;
        }
    }
}

- (void)openVideo:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSString *videoLink = [userInfo objectForKey:[NotificationKey VideoLink]];
    
    BrowserViewController *browserViewController = [[BrowserViewController alloc] initWithNibName:@"BrowserViewController" bundle:nil];
    browserViewController.urlString = videoLink;
    browserViewController.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:browserViewController animated:true];
}

- (void)openGift:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSString *GiftLink = [userInfo objectForKey:[NotificationKey GiftLink]];
    
    BrowserViewController *browserViewController = [[BrowserViewController alloc] initWithNibName:@"BrowserViewController" bundle:nil];
    browserViewController.urlString = GiftLink;
    browserViewController.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:browserViewController animated:true];
}

- (void)openRaceInfoLink:(NSNotification*)notification
{
//    if (popupInfo != nil) {
//        [popupInfo removeAnimate];
//    }
    NSDictionary *userInfo = [notification userInfo];
    NSString *raceInfoLink = [userInfo objectForKey:[NotificationKey RaceInfoLink]];
    NSString *raceName = [userInfo objectForKey:[NotificationKey RaceName]];
    
    RaceInfoPopupView *popupView = [RaceInfoPopupView createInView:UIApplication.sharedApplication.delegate.window raceContent:raceInfoLink raceName:raceName endTime:@""];
    [popupView showWithAnimated:true];
}



@end
