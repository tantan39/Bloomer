//
//  RacesViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 1/26/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#define RACE_SEARCH_LIMIT 20

#import "RacesViewController.h"
#import "AppDelegate.h"
#import "UIColor+Extension.h"
#import "AppHelper.h"
#import "UploadAvatarPopUpView.h"
#import "UIShadeView.h"
#import "RaceSlideShowItemView.h"

#define IMAGE_EXPAND_WIDTH 9
#define IMAGE_EXPAND_HEIGHT 5
#define DEFAULT_BUTTON_VIEW_ALL_WIDTH 66
#define HEIGHT_SCREEN [[UIScreen mainScreen] bounds].size.height

@interface RacesViewController () {
    MenuRacePopupController *popup;
    MenuRaceViewJoinViewController *popupJoin;
    CGFloat lastContentOffset;
    UserDefaultManager *userDefaultManager;
    NSInteger rankRace;
    NSInteger lastRankRace;
    NSString *ckey;
    NSMutableArray *userList;
    NSMutableArray *bannerList;
    NSMutableArray *searchList;
    BOOL isRefresh;
    NSInteger loadedItemIndex;
    NSTimer *timer;
    NSTimer *delay;
    NSInteger pageIndex;
    NSInteger offset;
    BOOL scroll;
    NSInteger model;
    out_profile_fetch *profileData;
    BOOL isLoadSearch;
    NSInteger rankSelected;
    BOOL isSurprise;
    UIRefreshControl *refreshControl;
    BOOL touchTop;
    BOOL isLoadScroll;
    FlowerMenuPostPopupViewController *flowerPopup;
    BOOL isViewRaceTop;
    NSString *sEndDate;
    
    NSInteger currentPopUp;
    
    ThankYou *thankyou;
    NSIndexPath *draggedCellIndex;
    BOOL isFetchingRace;
    
    BOOL isBeingSurprise;
    NSInteger numberRandom;
    BOOL isSurpriseCellLoaded;
    
    NSString* currentYear;
    CGRect frameSearchView;
    
    BOOL hidingkeyBoard;
    
    BOOL isBeingGiveFlower;
    NSInteger numberGiverFlower;
    BOOL isGivedFlowerCellLoad;
    AwesomeMenu *resultMenu;
    
    BOOL isfindingRow;
    int indexFinding;
    BOOL isFindingCellLoad;
    BOOL IsOutOfScreen;
    
    ImagePickerPopUpViewController *imagePickerPopUp;
    
    UIButton *raceTitleButton;
    UIImageView *imageExpand;
    
    UIFont *myFont;
    NSInteger myRank;
    BOOL rankReloadView;
    NSInteger searchPage;
    
    UIShadeView *shadeView;
    
    NSInteger adjusmentValue;
}

@property (strong, nonatomic) NSMutableArray *slideShowItems;

@end

@implementation RacesViewController
@synthesize isHideSearchBar = isHideSearchBar;

@synthesize circularMenu, isViewRaceTop,categoryType, gender = gender;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    userDefaultManager = [[UserDefaultManager alloc] init];
    [userDefaultManager setCurrentRaceGsb:self.gsb];
    profileData = [userDefaultManager getUserProfileData];
    _currentIndex = 0;
    
    searchPage = 0;
    
    lastRankRace = 1000;
    rankRace = 0;
    loadedItemIndex = 0;
    userList = [[NSMutableArray alloc] init];
    bannerList = [[NSMutableArray alloc] init];
    searchList = [[NSMutableArray alloc] init];
    isRefresh = TRUE;
    isLoadSearch = TRUE;
    isFetchingRace = FALSE;
    hidingkeyBoard = false;
    
    isBeingSurprise = false;
    isSurpriseCellLoaded = false;
    
    isBeingGiveFlower = false;
    isGivedFlowerCellLoad = false;
    
    isHideSearchBar = true;
    
    isfindingRow = false;
    isFindingCellLoad = false;
    
    [_dailyButton setEnabled:FALSE];
    [_dailyButton setTitleColor:[UIColor colorWithRed:0.125 green:0.125 blue:0.129 alpha:1.0] forState:UIControlStateDisabled];
    [_dailyButton.titleLabel setFont:[UIFont fontWithName:@"SFUIDisplay-Semibold" size:11]];
    [_dailyButton setBackgroundColor:[UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1.0]];
    _dailyButton.layer.borderWidth = 1;
    _dailyButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.viewAllButton.layer.cornerRadius = self.viewAllButton.frame.size.height / 2;
    self.viewAllButton.clipsToBounds = true;
    //    self.buttonSurprise.layer.borderColor = [UIColor colorFromHexString:@"#B22225"].CGColor;
    //    self.buttonSurprise.layer.borderWidth = 1.3;
    
    self.selectedView.layer.borderWidth = 0;
    self.selectedView.layer.borderColor = [UIColor colorFromHexString:@"#D3D3D3"].CGColor;
    self.selectedView.hidden = true;
    
    self.dailyButton.layer.cornerRadius = self.dailyButton.frame.size.height / 2;
    self.weeklyButton.layer.cornerRadius = self.weeklyButton.frame.size.height / 2;
    self.monthlyButton.layer.cornerRadius = self.monthlyButton.frame.size.height / 2;
    self.yearlyButton.layer.cornerRadius = self.yearlyButton.frame.size.height / 2;
    
    _weeklyButton.layer.borderWidth = 1;
    _weeklyButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _monthlyButton.layer.borderWidth = 1;
    _monthlyButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _yearlyButton.layer.borderWidth = 1;
    _yearlyButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.dailyButton.clipsToBounds = true;
    self.weeklyButton.clipsToBounds = true;
    self.monthlyButton.clipsToBounds = true;
    self.yearlyButton.clipsToBounds = true;
    
    self.cornerView.layer.cornerRadius = self.cornerView.frame.size.height * 2;
    self.cornerView.clipsToBounds = true;
    
    self.topBar.layer.masksToBounds = NO;
    self.topBar.layer.shadowOffset = CGSizeMake(0, 1);
    self.topBar.layer.shadowRadius = 2;
    self.topBar.layer.shadowOpacity = 0.5;
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshDoneLoading:) forControlEvents:UIControlEventValueChanged];
    [refreshControl setTintColor:[UIColor redColor]];
    [refreshControl setAutoresizingMask:(UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin)];
    [refreshControl setFrame:CGRectMake(0, 0, 320, 30)];
    [_tableView addSubview:refreshControl];
    
    __weak RacesViewController *weakSelf = self;
    [self.emptyScrollView addPullToRefreshWithActionHandler:^{
        [weakSelf pullToRefresh];
    }];
    
    [_tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf infiniteScrolling];
    }];
    
    [_searchResultTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf searchTableInfiniteScrolling];
    }];
    
    [self getCurrentDay];
    
    [_yearlyButton setTitle:currentYear forState:UIControlStateNormal];
    
    _listDraggableLocatioinList = [[NSMutableArray alloc] init];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _tabbar = appDelegate.tabbar;
    
    if(_draggableLocation!= nil)
    {
        [self configureDraggableLocation:_draggableLocation makeCircle:FALSE];
        _draggableLocation.delegate = self;
        [_tabbar.draggableButton addAllowedDropLocation:_draggableLocation];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //custom SearchView
    _searchResultTableView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    //Tu L: Add placeholder for search bar
    //    self.searchBar.placeholder = [AppHelper getLocalizedString:@"Leaderboard.searchPlaceholder"];
    
    myFont = [UIFont fontWithName:@"SFUIDisplay-Regular" size:16];
    [self setupLanguage];
    [self loadRaceInfo];
    
    shadeView = [[UIShadeView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.searchBar setupSearchBar];
    
    adjusmentValue = 50;//[UIScreen mainScreen].bounds.size.height - ([UIScreen mainScreen].bounds.size.height/8.12) * 7;
    [self setLoadPreviousView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[self loadRaceInfo];
    
    IsOutOfScreen = FALSE;
    
    [_tableView setDelegate:self];
    
    [_tabbar.draggableButton removeAllAllowedDropLocations];
    [_tableView reloadData];
    [self.view layoutIfNeeded];
    [AppHelper changeNavigationBarToRed:self.navigationController];
    
    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //reload banner
    [self initSlideShow];
    
    if(_draggableLocation!= nil)
    {
        if (![_tabbar.draggableButton.droppableLocations containsObject:_draggableLocation])
        {
            [_tabbar.draggableButton addAllowedDropLocation:_draggableLocation];
        }
        
        for (SEDraggableLocation *location in _listDraggableLocatioinList)
        {
            [_tabbar.draggableButton addAllowedDropLocation:location];
        }
    }
    
//    if (_tableView.contentOffset.y < [UIScreen mainScreen].bounds.size.height - 70 && _btnUpdateRace.isHidden) {
//        [_backToTopButton setHidden:TRUE];
//        [self.navigationController setNavigationBarHidden:FALSE];
//        _heightOfSpace.constant = 0;
//    }
//    [self handelBtnPrevious];
     _heightOfSpace.constant = 0;
    [self.view layoutIfNeeded];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:false];
    
    [_tableView setDelegate:nil];
    
    [timer invalidate];
    if (circularMenu != nil) {
        [circularMenu removeFromSuperview];
    }
    if(_draggableLocation!= nil)
    {
        
        [_tabbar.draggableButton removeAllowedDropLocation:_draggableLocation];
        
        for (SEDraggableLocation *location in _listDraggableLocatioinList)
        {
            [_tabbar.draggableButton removeAllowedDropLocation:location];
        }
    }
}

- (void)setupLanguage
{
    [self.viewAllButton setTitle:[AppHelper getLocalizedString:@"Leaderboard.buttonViewAll"] forState:UIControlStateNormal];
    self.labelEmptyTitle.text = [AppHelper getLocalizedString:@"Leaderboard.labelEmptyView"];
    [_dailyButton setTitle:NSLocalizedString(@"DailyButton.title", ) forState:UIControlStateNormal];
    [_weeklyButton setTitle:NSLocalizedString(@"WeekButton.title", ) forState:UIControlStateNormal];
    [_monthlyButton setTitle:NSLocalizedString(@"MonthButton.title", ) forState:UIControlStateNormal];
    
    [_backToTopButton setTitle:NSLocalizedString(@"BackToTopLeaderBoard.title", ) forState:UIControlStateNormal];
    [_btnUpdateRace setTitle:NSLocalizedString(@"SeeMoreUpdateLeaderBoard.title", ) forState:UIControlStateNormal];
    
    _swipeLabel.text = NSLocalizedString(@"SwipeLabelLeaderBoard.title", );
    
    _notFoundLabel.text = NSLocalizedString(@"LeaderboardNotFoundSearchList.title", );
    
    [self.searchBar setPlaceholder:NSLocalizedString(@"Leaderboard.searchPlaceholder", )];
}

- (void)refreshDoneLoading:(UIRefreshControl *)refresh
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //        [NSThread sleepForTimeInterval:1];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self pullToRefresh];
            [refreshControl endRefreshing];
        });
    });
}

- (void)pullToRefresh {
    isRefresh = TRUE;
    rankRace = 0;
    loadedItemIndex = 0;
    self.loadPreviousView.hidden = true;
    
    @try {
        isViewRaceTop = NO;
        [self loadRacesList];
        [self loadBanner];
    } @catch(NSException *e) {
        NSLog(@"%@", e.description);
    }
    
    [self.tableView.pullToRefreshView stopAnimating];
    [self.emptyScrollView.pullToRefreshView stopAnimating];
}

- (void)infiniteScrolling {
    if (userList.count != 0) {
        rankRace = [(RacesObj *)([userList objectAtIndex:userList.count - 1]) rank];
    } else {
        rankRace = 0;
    }
    
    if (!isSurprise && !IsOutOfScreen) {
        isRefresh = true;
        @try {
            [self loadRacesList];
        } @catch (NSException *e) {
            NSLog(@"%@", e.description);
        }
        lastRankRace = rankRace;
    }
    
    [self.tableView.infiniteScrollingView stopAnimating];
}

- (void)searchTableInfiniteScrolling {
    searchPage++;
    API_RaceSearch *api = [[API_RaceSearch alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                         device_token:[userDefaultManager getDeviceToken]
                                                                  key:_key ckey:ckey
                                                               gender:gender
                                                                 term:_searchBar.text
                                                                 page:searchPage
                                                                 size:RACE_SEARCH_LIMIT];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        [self getDataRacesSearch_fetches:jsonObject response:response];
    } ErrorHandlure:^(NSError *error) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];
    [_searchResultTableView.infiniteScrollingView stopAnimating];
}

- (void)loadRaceInfo {
    API_RacesNameFetch *api = [[API_RacesNameFetch alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                                 device_token:[userDefaultManager getDeviceToken]
                                                                          key:self.key];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        if (response.status) {
            JSON_RacesNameFetch *racesNameJSON = (JSON_RacesNameFetch *)jsonObject;
            //        RacesViewController *view = [[RacesViewController alloc] initWithNibName:@"RacesViewController" bundle:nil];
            
            _key = racesNameJSON.key;
            _ckeyList = racesNameJSON.childsList;
            _raceName = racesNameJSON.name;
            _startTime = racesNameJSON.start;
            _endTime = racesNameJSON.end;
            _isJoin = racesNameJSON.isJoin;
            _isClosed = racesNameJSON.isClosed;
            _isComingSoon = racesNameJSON.isComingSoon;
            _rules = racesNameJSON.rules;
            categoryType = racesNameJSON.category;
            _endDate = racesNameJSON.endDate;
            _raceInfo = racesNameJSON.raceInfo;
            _joinInfo = racesNameJSON.joinInfo;
            _leaveInfo = racesNameJSON.leaveInfo;
            _locationID = racesNameJSON.locationID;
            //        ckey = _ckeyList[0];
            
            if (categoryType > RACECATEGORY_LOCATION) // not VietNam & Locaiton Race
            {
                // hide timebar
                
                [self selectedRaceTimeStampByKey:-1];
            } else {
                //set cKey is default-Monthly
                //            NSLog(@"timestamp %@",self.timeStamp);
                if (self.timeStamp) {
                    // Country Race
                    if ([self.timeStamp isEqualToString:@"y"]) {
                        [self selectedRaceTimeStampByKey:0];
                    } else if ([self.timeStamp isEqualToString:@"m"]) {
                        [self selectedRaceTimeStampByKey:1];
                    } else if ([self.timeStamp isEqualToString:@"w"]) {
                        [self selectedRaceTimeStampByKey:2];
                    } else {
                        [self selectedRaceTimeStampByKey:3];
                    }
                } else {
                    //Location Race
                    [self selectedRaceTimeStampByKey:1];
                }
            }
            
            rankRace = 0;
            loadedItemIndex = 0;
            [self loadRacesList];
            [self loadBanner];
            [self initNavigationBar];
        } else {
            [AppHelper showMessageBox:nil message:response.message];
        }
        
    } ErrorHandlure:^(NSError *error) {
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];
}

- (void)loadRacesList {
    if (isFetchingRace) {
        isBeingGiveFlower = false;
        return;
    }
    [resultMenu removeFromSuperview];
    isFetchingRace = true;
    
    API_RacesFetch *api = [[API_RacesFetch alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                         device_token:[userDefaultManager getDeviceToken]
                                                                  key:self.key ckey:ckey
                                                                 rank:rankRace
                                                            isRefresh:isRefresh
                                                               gender:gender];
    
    [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner startAnimating];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        isFetchingRace = false;
        
        if (response.status) {
            isRefresh = false;
            JSON_RacesFetch *racesJSON = (JSON_RacesFetch *)jsonObject;
            
            if (racesJSON.racesList.count != 0 || loadedItemIndex > 0)
            {
                [self.emptyScrollView setHidden:YES];
                [self.tableView setHidden:NO];
                self.tableView.scrollEnabled = true;
            } else {
                [self.emptyScrollView setHidden:NO];
                [self.tableView setHidden:YES];
                //            self.tableView.scrollEnabled = false;
            }
            
            if (loadedItemIndex == 0) {
                userList = racesJSON.racesList;
                [_tabbar.draggableButton removeAllAllowedDropLocations];
                [_tableView reloadData];
                
                [_tableView setContentOffset:CGPointZero animated:true]; // scroll to top
                loadedItemIndex += 12;
                isBeingGiveFlower = false;
            } else {
                if (racesJSON.racesList.count != 0) {
                    [self.tableView setContentOffset:self.tableView.contentOffset animated:false];
                    isBeingGiveFlower = true;
                    isGivedFlowerCellLoad = false;
                    [userList addObjectsFromArray:racesJSON.racesList];
                    [_tabbar.draggableButton removeAllAllowedDropLocations ];
                    [_tableView reloadData];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (showThankYou) {
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:focusIndexInRace inSection:0];
                            [self disableTopBar];
                            [self.tableView scrollToRowAtIndexPath:indexPath
                                                  atScrollPosition:UITableViewScrollPositionMiddle
                                                          animated:true];
                            
                        } else {
                            isBeingGiveFlower = false;
                        }
                        
                        if ([racesJSON racesList].count != 12) {
                            loadedItemIndex -= 12 - [racesJSON racesList].count;
                        }
                        loadedItemIndex += 12;
                    });
                    
                } else {
                    isBeingGiveFlower = false;
                    [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
                }
            }
            [self loadMyRank:false];
        } else {
            isBeingGiveFlower = false;
            [AppHelper showMessageBox:nil message:response.message];
        }
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        
    } ErrorHandlure:^(NSError *error) {
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];
}


- (void)loadPrevousRacesList {
    if (isFetchingRace) {
        return;
    }
    isFetchingRace = true;
    RacesObj *temp = (RacesObj *)[userList firstObject];

    API_LoadPrevousRace *api = [[API_LoadPrevousRace alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                                   device_token:[userDefaultManager getDeviceToken]
                                                                            key:self.key ckey:ckey
                                                                           rank:temp.rank
                                                                         gender:gender
                                                                         scroll:0];
    
    [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner startAnimating];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        isFetchingRace = false;
        
        if (response.status) {
            JSON_RacesFetch *racesJSON = (JSON_RacesFetch *)jsonObject;
            if (racesJSON.racesList.count != 0) {
                if ([racesJSON.racesList firstObject].rank == 1) {
                    self.loadPreviousView.hidden = true;
                } else {
                    self.loadPreviousView.hidden = false;
                }
                [self.tableView setContentOffset:self.tableView.contentOffset animated:false];
                [racesJSON.racesList addObjectsFromArray: userList];
                userList = racesJSON.racesList;
                [_tabbar.draggableButton removeAllAllowedDropLocations ];
                [_tableView reloadData];
                
            } else {
                [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
            }
            [self loadMyRank:false];
        } else {
            [AppHelper showMessageBox:nil message:response.message];
        }
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        
    } ErrorHandlure:^(NSError *error) {
        isFetchingRace = false;
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];
}

- (NSString *) getCurrentDay
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSString* day = [NSString stringWithFormat: @"%ld", (long)[components day]];
    NSString* month = [NSString stringWithFormat: @"%ld", (long)[components month]];
    currentYear = [NSString stringWithFormat: @"%ld", (long)[components year]];
    NSString* result = [[day stringByAppendingString:month] stringByAppendingString:currentYear];
    return result;
}

- (void)loadSurprise {
    [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner startAnimating];
    [self.tableView setContentOffset:self.tableView.contentOffset animated:NO];
    
    API_RacesSurprise *api = [[API_RacesSurprise alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                               device_token:[userDefaultManager getDeviceToken]
                                                                        key:self.key ckey:ckey gender:gender];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        if (response.status) {
            JSON_RacesFetch *racesJSON = (JSON_RacesFetch *)jsonObject;
            userList = racesJSON.racesList;
            
            if (userList.count > 0) {
                [self.tableView setContentOffset:self.tableView.contentOffset animated:false];
                isBeingSurprise = true;
                isSurpriseCellLoaded = false;
                numberRandom = arc4random() % userList.count;
                [_tableView reloadData];
                
                NSIndexPath *path =[NSIndexPath indexPathForRow:numberRandom inSection:0];
                [_tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            } else {
                isBeingSurprise = false;
            }
            
        } else {
            [AppHelper showMessageBox:nil message:response.message];
        }
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        
    } ErrorHandlure:^(NSError *error) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];
}

- (void)loadMyRank:(BOOL)reloadView {
    rankReloadView = reloadView;
    [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner startAnimating];
    
    API_RacesMyRank *api = [[API_RacesMyRank alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                           device_token:[userDefaultManager getDeviceToken]
                                                                    key:self.key ckey:ckey];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        if (response.status) {
            JSON_RacesFetch *racesJSON = (JSON_RacesFetch *)jsonObject;
            myRank = racesJSON.myrank;
            if (rankReloadView && racesJSON.racesList.count > 0) {
                userList = racesJSON.racesList;
                if ([racesJSON.racesList firstObject].rank == 1) {
                    self.loadPreviousView.hidden = true;
                } else {
                    self.loadPreviousView.hidden = false;
                }
                isViewRaceTop = true;
                [_tableView reloadData];
        
                for (RacesObj *item in userList) {
                    if (item.uid == [userDefaultManager getUserProfileData].uid) {
                        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[userList indexOfObject:item] inSection:0]
                                          atScrollPosition:UITableViewScrollPositionMiddle
                                                  animated:true];
                    }
                }
            }
            
        } else {
            [AppHelper showMessageBox:nil message:response.message];
        }
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        
    } ErrorHandlure:^(NSError *error) {
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];
}

- (void)loadRaceTop {
    //    [_tableView setContentOffset:CGPointZero animated:YES];
    [self pullToRefresh];
}


- (void)loadBanner {
    API_Races_BannerFetches *api = [[API_Races_BannerFetches alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                                           device_token:[userDefaultManager getDeviceToken]
                                                                                 gender:gender
                                                                                    key:self.key
                                                                                   cKey:ckey];
    
    [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner startAnimating];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        
        if (response.status) {
            JSON_BannerFetch *data = (JSON_BannerFetch *)jsonObject;
            bannerList = data.bannerList;
            [self initSlideShow];
        } else {

            [AppHelper showMessageBox:nil message:response.message];
        }
        
    } ErrorHandlure:^(NSError *error) {
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];
}

- (void)showUpdateRace{
    [_btnUpdateRace setHidden:FALSE];
    [_backToTopButton setHidden:TRUE];
}

- (void)initSlideShow
{
    [timer invalidate];
    scroll = false;
    self.slideShowItems = [[NSMutableArray alloc] init];
    [self.slideShowContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    __weak RacesViewController *weakSelf = self;
    
    for (NSInteger i = 0; i < bannerList.count + 1; i++)
    {
        BannerObj *banner = (i == bannerList.count ? nil : (BannerObj *)[bannerList objectAtIndex:i]);
        RaceSlideShowItemView *itemView = (RaceSlideShowItemView*)[[[NSBundle mainBundle] loadNibNamed:@"RaceSlideShowItemView" owner:self options:nil] objectAtIndex:0];
        itemView.translatesAutoresizingMaskIntoConstraints = false;
        
        if (i == bannerList.count) // View All Button
        {
            itemView.viewAllView.hidden = false;
            itemView.viewAllLabel.text = bannerList.count == 0 ? [AppHelper getLocalizedString:@"Be the first person\nto join this contest!"] : [AppHelper getLocalizedString:@"View all photos of this contest"];
            itemView.touchItemView = ^{
                [weakSelf touchViewAll:nil];
            };
        }
        else
        {
            itemView.viewAllView.hidden = true;
//            [itemView.imageView setImageWithURL:[NSURL URLWithString:banner.photo_url]];
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:banner.photo_url] options:SDWebImageRefreshCached progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                CGRect offSet = CGRectMake(banner.x1, banner.y1, image.size.width, image.size.height);
                UIImage * cropImage = [AppHelper cropToBounds:image rect:offSet];
                itemView.imageView.image = cropImage;
                [itemView.imageView clipsToBounds];
            }];
            itemView.rankLabel.text = @(banner.rank + 1).stringValue;
            itemView.touchItemView = ^{
                [weakSelf touchBanner:nil];
            };
        }
        
        [self.slideShowContentView addSubview:itemView];
        
        if (i == 0)
        {
            [AppHelper setupConstraintsForHorizontalView:itemView previousView:nil isFirstView:true parentView:self.slideShowContentView width:UIScreen.mainScreen.bounds.size.width spacing:0];
        }
        else
        {
            RaceSlideShowItemView *previousView = (RaceSlideShowItemView*)self.slideShowItems[self.slideShowItems.count - 1];
            [AppHelper setupConstraintsForHorizontalView:itemView previousView:previousView isFirstView:false parentView:self.slideShowContentView width:UIScreen.mainScreen.bounds.size.width spacing:0];
        }
        
        [self.slideShowItems addObject:itemView];
    }
    
    self.slideShowContentViewWidth.constant = UIScreen.mainScreen.bounds.size.width * (bannerList.count + 1);
    
    pageIndex = 1;
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(slideImage) userInfo:nil repeats:YES];
    [self.slideshow setContentOffset:CGPointMake(0, 0) animated:YES];
    
    if (bannerList.count == 0)
    {
        [self.swipeLabel setHidden:TRUE];
    }
    else
    {
        [self.swipeLabel setHidden:FALSE];
    }
}

- (void)slideImage {
    _currentIndex++;
    offset = UIScreen.mainScreen.bounds.size.width * _currentIndex;
    [_slideshow setContentOffset:CGPointMake(offset, _slideshow.contentOffset.y) animated:YES];
    
    if (_currentIndex > bannerList.count)
    {
        [self scrollToFirstPage];
    }
}

- (void)openGalleryPopUp
{
    imagePickerPopUp = [[ImagePickerPopUpViewController alloc] initWithNibName:@"ImagePickerPopUpViewController" bundle:nil];
    imagePickerPopUp.parentView = self;
    imagePickerPopUp.isUploadAvatar = false;
    imagePickerPopUp.tag = self.key;
    imagePickerPopUp.raceName = self.raceName;
    [imagePickerPopUp showInView:[[[UIApplication sharedApplication] delegate] window] animated:TRUE];
}

- (void)openUploadAvatarPopUp
{
    UploadAvatarPopUpView *uploadAvatarPopUp = [UploadAvatarPopUpView createInView:[UIApplication sharedApplication].keyWindow parentView:self raceKey:self.key category:self.categoryType];
    uploadAvatarPopUp.OnRaceJoined = ^{
        self.OnRaceJoined();
    };
    [uploadAvatarPopUp showWithAnimated:true];
}

-(void) handelBtnPrevious {
//    if (( _tableView.frame.size.height + _tableView.contentOffset.y) > _tableView.contentSize.height) {
//        return;
//    }
    if (_tableView.contentOffset.y > adjusmentValue && _btnUpdateRace.isHidden)
    {
        [_backToTopButton setHidden:FALSE];
        if (self.tableView.contentSize.height > (self.tableView.frame.size.height + 50)) {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            
            if (@available(iOS 11.0, *)) {
                _heightOfSpace.constant = self.view.safeAreaInsets.top;
            }
            else
            {
                _heightOfSpace.constant = 20;
            }
            
            if(![self.navigationController isNavigationBarHidden]) {
                [self LeftRevealToggle];
            }
        }
        
    }
    
    if (_tableView.contentOffset.y < 1) {
        [self showNavicontroller];
    }
}

-(void) showNavicontroller {
    [_backToTopButton setHidden:TRUE];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    _heightOfSpace.constant = 0;
}

- (void)setLoadPreviousView {
    self.loadPreviousView.layer.cornerRadius = self.loadPreviousView.frame.size.height / 2;
    self.loadPreviousView.layer.masksToBounds = NO;
    
    self.loadPreviousView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.loadPreviousView.layer.shadowOffset = CGSizeMake(0, 5.0f);
    self.loadPreviousView.layer.shadowRadius = 1.5f;
    self.loadPreviousView.layer.shadowOpacity = 0.2;
    self.loadPreviousView.hidden = true;
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadPreviousTapper)];
    [singleFingerTap setNumberOfTapsRequired:1];
    
    [self.loadPreviousView addGestureRecognizer:singleFingerTap];
}

- (void) loadPreviousTapper {
    if ([userList count] > 0) {
        [self loadPrevousRacesList];
    }
}

#pragma mark - Scrollview Delegate
- (void)scrollToFirstPage {
    _currentIndex = 0;
    offset = 320 * _currentIndex;
    [_slideshow setContentOffset: CGPointMake(offset, _slideshow.contentOffset.y) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _slideshow) {
        
        if ((NSInteger)_slideshow.contentOffset.x % (NSInteger)[UIScreen mainScreen].bounds.size.width == 0) {
            _currentIndex = _slideshow.contentOffset.x / ((NSInteger)[UIScreen mainScreen].bounds.size.width);
            
            if (_currentIndex == bannerList.count)
            {
                [_swipeLabel setHidden:TRUE];
            }
            else
            {
                [_swipeLabel setHidden:FALSE];
            }
            
            if (scroll) {
                scroll = false;
                timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(slideImage) userInfo:nil repeats:YES];
            }
        }
    } else {
        [self handelBtnPrevious];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == _slideshow) {
        [timer invalidate];
        scroll = true;
    }
}

#pragma mark - Giving Flower
- (void)clearDraggableLocationList
{
    if (_listDraggableLocatioinList.count != 0)
    {
        for (int i = 0; i < _listDraggableLocatioinList.count; i++)
        {
            [_tabbar.draggableButton removeAllowedDropLocation:[_listDraggableLocatioinList objectAtIndex:i]];
        }
    }
}

- (void)draggableLocation:(SEDraggableLocation *)location didRefuseObject:(SEDraggable *)object entryMethod:(SEDraggableLocationEntryMethod)method
{
    [object setHidden:true];
    
    if (circularMenu != nil) {
        [circularMenu removeFromSuperview];
    }
    
    if (location == _draggableLocation) {
        circularMenu = [self createCircularMenuWithFrame:_draggableLocation.bounds];
        circularMenu.startPoint = CGPointMake(_draggableLocation.frame.origin.x + 155, _draggableLocation.frame.origin.y + 100);
        circularMenu.delegate = self;
        circularMenu.menuWholeAngle = 2.5f;
        circularMenu.farRadius = 60.0f;
        circularMenu.endRadius = 50.0f;
        circularMenu.nearRadius = 40.0f;
        circularMenu.animationDuration = 0.7f;
        circularMenu.rotateAngle = 5.04f;
        [circularMenu setExpanding:YES];
        
        [_pictureView addSubview:circularMenu];
    } else {
        RacesTableViewCell *cell = (RacesTableViewCell *)[self.tableView cellForRowAtIndexPath:location.index];
        circularMenu = [self createCircularCellMenuWithFrame:cell.contentView.bounds];
        circularMenu.startPoint = CGPointMake(cell.frame.origin.x + 165, cell.frame.origin.y + 80);
        circularMenu.delegate = self;
        circularMenu.menuWholeAngle = 0;//2.0f;
        circularMenu.rotateAngle = 0;
        circularMenu.farRadius = 60.0f;
        circularMenu.endRadius = 50.0;
        circularMenu.nearRadius = 40.0f;
        circularMenu.animationDuration = 0.7f;
        [circularMenu setExpanding:YES];
        
        [_tableView addSubview:circularMenu];
    }
    
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:location.index];
    model = cell.tag;
    draggedCellIndex = location.index;
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
    AwesomeMenuItem *flowerButton5 = [[AwesomeMenuItem alloc]
                                      initWithImage:[UIImage imageNamed:@"GivingFlower_Store.png"]
                                      highlightedImage:[UIImage imageNamed:@"GivingFlower_Store.png"]
                                      text:@""];
    NSArray *menus = [NSArray arrayWithObjects:flowerButton1, flowerButton2, flowerButton3, flowerButton4, flowerButton5, nil];
    
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"Btn_Flowers@3x.png"]
                                                       highlightedImage:[UIImage imageNamed:@"Btn_Flowers@3x.png"]
                                                                   text:@""];
    resultMenu = [[AwesomeMenu alloc] initWithFrame:frame startItem:startItem optionMenus:menus isCell:FALSE];
    
    return resultMenu;
}

- (AwesomeMenu *)createCircularCellMenuWithFrame:(CGRect)frame
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
    AwesomeMenuItem *flowerButton5 = [[AwesomeMenuItem alloc]
                                      initWithImage:[UIImage imageNamed:@"GivingFlower_Store.png"]
                                      highlightedImage:[UIImage imageNamed:@"GivingFlower_Store.png"]
                                      text:@""];
    NSArray *menus = [NSArray arrayWithObjects:flowerButton1, flowerButton2, flowerButton3, flowerButton4, flowerButton5, nil];
    
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:nil
                                                       highlightedImage:nil
                                                                   text:@""];
    
    resultMenu = [[AwesomeMenu alloc] initWithFrame:frame startItem:startItem optionMenus:menus isCell:TRUE];
    
    return resultMenu;
}


- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    [menu removeFromSuperview];
    //    people_random *temp = (people_random*)[_peopleData objectAtIndex:draggedCellIndex.row];
    
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
        //        RacesTableViewCell *cell = (RacesTableViewCell*)[self.tableView cellForRowAtIndexPath:draggedCellIndex];
        //        [self CreateThankYouView:CGPointMake(cell.frame.origin.x + 20, cell.frame.origin.y-45)];
        
    }
    else
    {
        if (idx == 3) {
            flowerPopup = [[FlowerMenuPostPopupViewController alloc] initWithNibName:@"FlowerMenuPopUpViewController" bundle:nil];
            flowerPopup.uid = model;
            flowerPopup.parentView = self;
            flowerPopup.isFirstRank = FALSE;
            hidingkeyBoard = false;
            [flowerPopup showInView:[[[UIApplication sharedApplication] delegate] window] animated:TRUE];
        } else if (idx == 4 || idx == -1) {
            FlowerGardenViewController *view = [[FlowerGardenViewController alloc] initWithNibName:@"FlowerGardenViewController" bundle:nil];
            [_tabbar snapbackFlowerIconToTabbar];
            view.hidesBottomBarWhenPushed = TRUE;
            [self.navigationController pushViewController:view animated:TRUE];
        }
    }
}

- (void)CreateThankYouView:(CGPoint)point
{
    [thankyou removeFromSuperview];
    if(!thankyou)
        thankyou = [[ThankYou alloc]initWithStyle:ThankYouStyleForTableViewCell atPoint:point];
    else
        [thankyou repositionToPoint:point];
}

- (void)AddThankYouView
{
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(removeThankYou) userInfo:nil repeats:NO];
    [_tableView addSubview:thankyou];
}

- (void)removeThankYou
{
    [thankyou removeFromSuperview];
}


- (void)giveFlower:(long long)flower {
    if(isBeingGiveFlower == false)
    {
        isBeingGiveFlower = true;
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
        flower_give *params = [[flower_give alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] num_flower:flower model:model key:_key ckey:ckey];
        if (params) {
            API_Flower_Give *api = [[API_Flower_Give alloc] initWithParams:params];
            [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                out_flower_give * data = (out_flower_give *) jsonObject;
                if (response.status) {
                    [userDefaultManager didTutorialGiveFlowerRace:TRUE];
                    [self processAfterGivingFlower:data];
                    [data showFlowerGivingPopupIn:[UIApplication sharedApplication].keyWindow];
                } else {
                    [AppHelper showMessageBox:nil message:response.message];
                    isBeingGiveFlower = false;
                    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
                }
            } ErrorHandlure:^(NSError *error) {
                [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
            }];
        }
        
        
    }
}

BOOL showThankYou=NO;
NSInteger focusIndexInRace;
- (void)processAfterGivingFlower:(out_flower_give *)data {
    profileData = [userDefaultManager getUserProfileData];
    profileData.your_num_flower = data.mFlower;
    [userDefaultManager saveUserProfileData:profileData];
    [_tabbar updateFlowerValue];
    
    //update info of receive model
    isRefresh = FALSE;
    //    loadedItemIndex = 0;
    rankRace = data.rank_onrace-1;
    
    //find index of new rank in userList
    NSInteger rankIndex = 0;
    for (int i =0; i < userList.count; i++) {
        if ([(RacesObj*)userList[i] rank] == rankRace) {
            rankIndex = [userList indexOfObject:(RacesObj*)userList[i]] + 1;
            break;
        }
    }
    
    // remove all user in list bellow this index
    NSRange r;
    r.location = rankIndex;
    r.length = [userList count]-rankIndex;
    
    [userList removeObjectsInRange:r];
    
    loadedItemIndex -= r.length;
    showThankYou = YES;
    focusIndexInRace = rankIndex;
    
    [self loadRacesList];
    
    if (data.bonus_flower > 0)
    {
        [AppHelper showMatchingFlowerPopUp:data.bonus_flower];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}

- (void)initNavigationBar
{
    if (categoryType > RACECATEGORY_LOCATION)
    {
        UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 180, 19)];
        titleView.textAlignment = NSTextAlignmentLeft;
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:16];
        titleView.textColor = [UIColor whiteColor];
        titleView.text = _raceName;
        
        UILabel *dateView = [[UILabel alloc] initWithFrame:CGRectMake(0, 21, 230, 13)];
        dateView.textAlignment = NSTextAlignmentLeft;
        dateView.backgroundColor = [UIColor clearColor];
        dateView.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:11];
        dateView.textColor = [UIColor whiteColor];
        dateView.text = _endDate;
        
        sEndDate = dateView.text;
        
        UIView *title = [[UIView alloc] initWithFrame:CGRectMake(60, 20, 180, 35)];
        [title addSubview:titleView];
        [title addSubview:dateView];
        
        UIBarButtonItem *leftTitle = [[UIBarButtonItem alloc] initWithCustomView:title];
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Icon_Back_White"] style:UIBarButtonItemStylePlain target:self action:@selector(touchBackButton)];
        
        //        self.navigationItem.leftItemsSupplementBackButton = true;
        [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects: backButton, leftTitle, nil]];
        
        self.navigationController.interactivePopGestureRecognizer.enabled = true;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        
        [title sizeToFit];
    }
    else
    {
        NSString *timeString;
        if (self.timeStamp) {
            if ([self.timeStamp isEqualToString:@"y"]) {
                timeString = currentYear;
            } else if ([self.timeStamp isEqualToString:@"m"]) {
                timeString = NSLocalizedString(@"MonthButton.title", nil);
            } else if ([self.timeStamp isEqualToString:@"w"]) {
                timeString = NSLocalizedString(@"WeekButton.title", nil);
            } else {
                timeString = NSLocalizedString(@"DailyButton.title", nil);
            }
        } else {
            timeString = NSLocalizedString(@"MonthButton.title", nil);
        }
        NSString *myString = [NSString stringWithFormat:@"%@/ %@", self.raceName, timeString];
        
        CGFloat length = [self widthOfString:myString withFont:myFont];
        
        UIView *leftButtonView = [[UIView alloc] initWithFrame:CGRectMake(-30, 0, 170, 35)];
        //        leftButtonView.bounds = CGRectInset(leftButtonView.frame, -15, 0);
        //        leftButtonView.backgroundColor = UIColor.whiteColor;
        
        raceTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [raceTitleButton addTarget:self action:@selector(LeftRevealToggle)forControlEvents:UIControlEventTouchUpInside];
        raceTitleButton.autoresizesSubviews = YES;
        raceTitleButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
        
        raceTitleButton.titleLabel.font = myFont;
        [raceTitleButton setFrame:CGRectMake(0, 0, 150, 35)];
        [raceTitleButton setTitle:myString forState:UIControlStateNormal];
        raceTitleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        raceTitleButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        imageExpand = [[UIImageView alloc] initWithFrame:CGRectMake(length + 3, 17, IMAGE_EXPAND_WIDTH, IMAGE_EXPAND_HEIGHT)];
        //        imageExpand.insets = UIEdgeInsetsMake(0, -15, 0, 0);
        [imageExpand setImage:[UIImage imageNamed:@"scoll_down"]];
        
        [leftButtonView addSubview:raceTitleButton];
        [leftButtonView addSubview:imageExpand];
        UIBarButtonItem *leftRevealButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButtonView];
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Icon_Back_White"] style:UIBarButtonItemStylePlain target:self action:@selector(touchBackButton)];
        
        //        self.navigationItem.leftItemsSupplementBackButton = true;
        [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects: backButton, leftRevealButtonItem, nil]];
        
        self.navigationController.interactivePopGestureRecognizer.enabled = true;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    NSMutableArray *rightBarButtonItemsArray = [[NSMutableArray alloc] init];
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoButton setImage:[UIImage imageNamed:@"Icon_Leaderboard_More"] forState:UIControlStateNormal];
    infoButton.frame = CGRectMake(0, 0, 35, 40);
    [infoButton addTarget:self action:@selector(touchInfoButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *infoButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    [rightBarButtonItemsArray addObject:infoButtonItem];
    
    if ((gender == [userDefaultManager getUserProfileData].gender || gender == 2)
        && ((self.categoryType != RACECATEGORY_LOCATION && self.categoryType != RACECATEGORY_EVENT && self.categoryType != RACECATEGORY_SPONSOR) || (self.isJoin == RACE_JOINED && !_isComingSoon))) {
        
        UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cameraButton setImage:[[UIImage imageNamed:@"Icon_Camera_White"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                      forState:UIControlStateNormal];
        [cameraButton addTarget:self action:@selector(touchButtonCamera) forControlEvents:UIControlEventTouchUpInside];
        cameraButton.frame = CGRectMake(0, 0, 32, 22);
//        cameraButton.backgroundColor = [UIColor blackColor];
        UIBarButtonItem *cameraButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cameraButton];
        [rightBarButtonItemsArray addObject:cameraButtonItem];
    }
    [self.navigationItem setRightBarButtonItems:rightBarButtonItemsArray];
}

- (NSString *)daySuffixForDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
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

- (void)LeftRevealToggle
{
    [_selectedView setHidden:!isHideSearchBar];
    if(isHideSearchBar == false)
    {
        [imageExpand setImage:[UIImage imageNamed:@"scoll_down"]];
    }
    else
    {
        [imageExpand setImage:[UIImage imageNamed:@"scoll_up"]];
    }
    imageExpand.frame = CGRectMake(imageExpand.frame.origin.x, 17, IMAGE_EXPAND_WIDTH, IMAGE_EXPAND_HEIGHT);
    
    isHideSearchBar = !isHideSearchBar;
}


#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tableView) {
        return userList.count;
    } else {
        return searchList.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tableView) {
        return 80;
    } else {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tableView) {
        NSString *identifier = @"RacesTableViewCell";
        RacesTableViewCell *cell = (RacesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"RacesTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureDraggableLocation:cell.draggableLocation makeCircle:NO];
        cell.draggableLocation.delegate = self;
        cell.draggableLocation.index = indexPath;
        cell.cellIndex = indexPath;
        cell.tableView = _tableView;
        [_tabbar.draggableButton addAllowedDropLocation:cell.draggableLocation];
        [_listDraggableLocatioinList addObject:cell.draggableLocation];
        
        RacesObj *temp = (RacesObj *)[userList objectAtIndex:indexPath.row];
        cell.name.text = temp.name;
        cell.username.text = temp.username;
        //[cell.avatar setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:temp.avatar] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10] placeholderImage:nil success:nil failure:nil];
        [cell.avatar setImageWithURL:[NSURL URLWithString:temp.avatar]];
        cell.avatarString = temp.avatar;
        
        cell.numFlower.text = @(temp.flower).stringValue;
        if (temp.flower > 1) {
            cell.lblFlowerText.text = NSLocalizedString(@"flowers",);
        } else {
            cell.lblFlowerText.text = NSLocalizedString(@"flower",);
        }
        cell.number.text = @(temp.rank).stringValue;
        cell.tag = temp.uid;
        cell.message = temp.aboutme;
        cell.uid = temp.uid;
        cell.MyNavigationController = self.navigationController;
        cell.parentView = self;
        
        if ([temp.aboutme isEqual:@""]) {
            [cell.statusButton setHidden:TRUE];
            [cell.statusLabel setHidden:TRUE];
            [cell.iconStatus setHidden:TRUE];
        } else {
            [cell.statusButton setHidden:FALSE];
            [cell.statusLabel setHidden:FALSE];
            [cell.iconStatus setHidden:FALSE];
        }
        
        if(isBeingSurprise == true && indexPath.row == numberRandom)
        {
            isSurpriseCellLoaded = true;
        }
        
        if(isBeingGiveFlower == true && indexPath.row == focusIndexInRace)
        {
            isGivedFlowerCellLoad = true;
        }
        
        if(isfindingRow == true && indexPath.row == indexFinding)
        {
            isFindingCellLoad = true;
        }
        
        [cell setVideoLink:temp.video_link];
        [cell switchStyleForAvatarBorderViewWithMedal:temp.gsbMedal isIcon:temp.is_icon];
        
        return cell;
    } else {
        NSString *identifier = @"RacesSearchTableViewCell";
        RacesSearchTableViewCell *cell = (RacesSearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"RacesSearchTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row < searchList.count) {
            if (![searchList[indexPath.row] isKindOfClass:[RacesObj class]]) {
                [cell.seeMoreButton setHidden:NO];
                [cell.seeMoreButton addTarget:self action:@selector(searchTableInfiniteScrolling) forControlEvents:UIControlEventTouchUpInside];
            } else {
                [cell.seeMoreButton setHidden:YES];
                RacesObj *temp = (RacesObj *)searchList[indexPath.row];
                [cell.avatar setImageWithURL:[NSURL URLWithString:temp.avatar]];
                cell.name.text = temp.name;
                cell.username.text = temp.username;
                cell.rank.text = [NSString stringWithFormat:@"#%@", @(temp.rank).stringValue];
            }
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController setNavigationBarHidden:FALSE];
    if (tableView == _searchResultTableView) {
        searchPage = 0;
        isLoadSearch = FALSE;
        hidingkeyBoard = false;
        RacesObj *temp = (RacesObj *)[searchList objectAtIndex:indexPath.row];
        rankSelected = temp.rank;
        
        NSString *searchString = [NSString stringWithFormat:@"#%@", @(temp.rank).stringValue];
        //        searchString = [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        API_RaceSearch *api = [[API_RaceSearch alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] key:_key ckey:ckey gender:gender term:searchString];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            [self getDataRacesSearch_fetches:jsonObject response:response];
        } ErrorHandlure:^(NSError *error) {
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        }];
    } else {
        hidingkeyBoard = false;
        RacesObj *temp = (RacesObj *)[userList objectAtIndex:indexPath.row];
        if (temp.uid == [userDefaultManager getUserProfileData].uid) {
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            [appDelegate.tabBarView setSelectedIndex:4];
        } else {
            UserProfileViewController *view = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
            view.uid = temp.uid;
            
            [self.navigationController pushViewController:view animated:YES];
        }
    }
}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//    if(tableView == _searchResultTableView) {
//        UIButton *loadMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [loadMoreButton setTitle:@"See more results" forState:UIControlStateNormal];
//        [loadMoreButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//        [loadMoreButton setFrame:footerView.bounds];
//        [footerView addSubview:loadMoreButton];
//    }
//    return footerView;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    if(tableView == _searchResultTableView) {
//        return 44;
//    }
//    return 0;
//}

-(void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if(isBeingSurprise == true)
    {
        NSIndexPath* path =[NSIndexPath indexPathForRow:numberRandom inSection:0];
        
        if(isSurpriseCellLoaded == true)
        {
            RacesTableViewCell *cell = (RacesTableViewCell *)[self.tableView cellForRowAtIndexPath: path];
            CGRect myFrame = [cell frame];
            myFrame = [self.tableView convertRect:myFrame toView:_topBar];
            
            if(myFrame.origin.y > 50 && myFrame.origin.y < self.view.window.frame.size.height - 190)
            {
                NSLog(@"My Frame : %f", myFrame.origin.y);
                NSLog(@"My Frame : %f", self.view.window.frame.size.height - 190);
                [cell showUpBubbleView: [self.navigationController isNavigationBarHidden]];
                [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
                isSurpriseCellLoaded = false;
                isBeingSurprise = false;
                [self.tableView setContentOffset:self.tableView.contentOffset animated:NO];
            }
        }
        
    }
    
    if(isfindingRow == true)
    {
        NSIndexPath* path =[NSIndexPath indexPathForRow:indexFinding inSection:0];
        
        if(isFindingCellLoad == true)
        {
            RacesTableViewCell *cell = (RacesTableViewCell *)[self.tableView cellForRowAtIndexPath: path];
            CGRect myFrame = [cell frame];
            //            myFrame = [self.tableView convertRect:myFrame toView:_topBar];
            
            //            if(myFrame.origin.y > 50 && myFrame.origin.y < self.view.window.frame.size.height - 190)
            //            {
            //                NSLog(@"My Frame : %f", myFrame.origin.y);
            //                NSLog(@"My Frame : %f", self.view.window.frame.size.height - 190);
            //                [cell showUpBubbleView:isHideTopBar];
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
            isfindingRow = false;
            isFindingCellLoad = false;
            [self.tableView setContentOffset:self.tableView.contentOffset animated:NO];
            //            }
            myFrame = [self.tableView convertRect:myFrame toView:[[[UIApplication sharedApplication] delegate] window]];
            [shadeView showInView:[[[UIApplication sharedApplication] delegate] window] withAnimation:YES withMaskFrame:myFrame];
        }
        
    }
    if(isBeingGiveFlower == true)
    {
        NSIndexPath* path =[NSIndexPath indexPathForRow:focusIndexInRace inSection:0];
        if(isGivedFlowerCellLoad == true)
        {
            [self enableTopBar];
            RacesTableViewCell *cell = (RacesTableViewCell*)[self.tableView cellForRowAtIndexPath: path];
            [self CreateThankYouView:CGPointMake(cell.frame.origin.x + 20, cell.frame.origin.y - 45)];
            [self AddThankYouView];
            showThankYou= NO;
            isGivedFlowerCellLoad = false;
            isBeingGiveFlower = false;
            [self.tableView setContentOffset:self.tableView.contentOffset animated:NO];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
        NSLog(@"%f %f %f ", scrollView.contentSize.height,self.tableView.frame.size.height, self.view.bounds.size.height - 40);
    if(isBeingGiveFlower == true)
    {
        NSIndexPath* path =[NSIndexPath indexPathForRow:focusIndexInRace inSection:0];
        if(isGivedFlowerCellLoad == true)
        {
            [self enableTopBar];
            RacesTableViewCell *cell = (RacesTableViewCell*)[self.tableView cellForRowAtIndexPath: path];
            [self CreateThankYouView:CGPointMake(cell.frame.origin.x + 20, cell.frame.origin.y - 45)];
            [self AddThankYouView];
            showThankYou= NO;
            isGivedFlowerCellLoad = false;
            isBeingGiveFlower = false;
            [self.tableView setContentOffset:self.tableView.contentOffset animated:NO];
        }
    }
    if (scrollView != _slideshow) {
        [self handelBtnPrevious];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        if (scrollView != _slideshow) {
            [self handelBtnPrevious];  
        }
    }
}

#pragma mark - Event Function
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if (touch.view == _slideshow || [touch.view isKindOfClass:[UIButton class]]){
        
        [_tableView addSubview:refreshControl];
        
        //touchTop = TRUE;
    }
    else
    {
        if (refreshControl != nil) {
            [refreshControl removeFromSuperview];
        }
        //touchTop = FALSE;
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

- (void)keyboardWillChange:(NSNotification *)notification {
    CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect SearchView = self.searchBar.bounds;
    
    CGFloat ViewSearchSize = HEIGHT_SCREEN - (keyboardRect.size.height + SearchView.size.height + self.navigationController.navigationBar.bounds.size.height);
    
    CGFloat heightFloat = self.navigationController.isNavigationBarHidden ? 20 : 0;
    CGRect frame = self.searchResultTableView.frame;
    frame.size.height = ViewSearchSize + heightFloat;
    if(hidingkeyBoard)
    {
        self.searchResultTableView.frame = frame;
        [_searchView setHidden:false];
        [_searchResultTableView setHidden:false];
    }
    
}

- (void)touchInfoButton {
    if(gender != [userDefaultManager getGender])
    {
        popup = [[MenuRacePopupController alloc] initWithNibName:@"MenuRacePopupController" bundle:nil];
        popup.parentView = self;
        popup.rules = _rules;
        popup.raceContent = _raceInfo;
        popup.raceName = _raceName;
        popup.endTime = sEndDate;
        popup.key = _key;
        popup.gender = gender;
        popup.categoryType = categoryType;
        popup.isViewRaceTop = isViewRaceTop;
        popup.userHasRank = myRank > -1;
        
        [popup showInView:[[[UIApplication sharedApplication] delegate] window] animated:TRUE];
    }
    else
    {
        switch (_isJoin) {
            case RACE_NOT_ALLOW_TO_JOIN:
            {
                popup = [[MenuRacePopupController alloc] initWithNibName:@"MenuRacePopupController" bundle:nil];
                popup.parentView = self;
                popup.rules = _rules;
                popup.raceContent = _raceInfo;
                popup.raceName = _raceName;
                popup.endTime = sEndDate;
                popup.key = _key;
                popup.gender = gender;
                popup.categoryType = categoryType;
                popup.isViewRaceTop = isViewRaceTop;
                popup.userHasRank = myRank > -1;
                [popup showInView:[[[UIApplication sharedApplication] delegate] window] animated:TRUE];
                break;
            }
            case RACE_NOT_JOINED:
            {
                popup = [[MenuRacePopupController alloc] initWithNibName:@"MenuRacePopupController" bundle:nil];
                popup.parentView = self;
                popup.rules = _rules;
                popup.raceInfo = _raceInfo;
                popup.joineInfo = _joinInfo;
                popup.leaveInfo = _leaveInfo;
                popup.raceContent = _raceInfo;
                popup.raceName = _raceName;
                popup.endTime = sEndDate;
                popup.key = _key;
                popup.gender = gender;
                popup.categoryType = categoryType;
                popup.locationID = _locationID;
                popup.parentView = self;
                popup.MyNavigationController = self.navigationController;
                popup.avatarString = _avatarRace;
                popup.userHasRank = myRank > -1;
                [popup showInView:[[[UIApplication sharedApplication] delegate] window] animated:TRUE];
                break;
            }
            default: //JOINED : isJoin = 2
            {
                popup = [[MenuRacePopupController alloc] initWithNibName:@"MenuRacePopupController" bundle:nil];
                popup.parentView = self;
                popup.rules = _rules;
                popup.raceInfo = _raceInfo;
                popup.joineInfo = _joinInfo;
                popup.leaveInfo = _leaveInfo;
                popup.raceName = _raceName;
                popup.raceContent = _raceInfo;
                popup.endTime = sEndDate;
                popup.key = _key;
                popup.gender = gender;
                popup.isJoin = TRUE;
                popup.categoryType = categoryType;
                popup.isViewRaceTop = isViewRaceTop;
                popup.userHasRank = myRank > -1;
                [popup showInView:[[[UIApplication sharedApplication] delegate] window] animated:TRUE];
            }
                break;
        }
    }
    if(popup != nil) {
        __weak RacesViewController* weakSelf = self;
        popup.OnRacejoined = ^{
            weakSelf.OnRaceJoined();
        };
    }
    [self searchBarCancelButtonClicked:_searchBar];
}

- (void)touchButtonCamera
{
    if ((self.categoryType <= RACECATEGORY_LOCATION && !profileData.isupload_avatar) || (self.isJoin == RACE_NOT_JOINED && self.categoryType != RACECATEGORY_COUNTRY)) {
        [self openUploadAvatarPopUp];
    }
    else {
        [self openGalleryPopUp];
    }
}

- (IBAction)touchDaily:(id)sender {
    isRefresh = TRUE;
    rankRace = 0;
    loadedItemIndex = 0;
    
    [self selectedRaceTimeStampByKey:3];
    
    [self loadRacesList];
    [self loadBanner];
}

- (IBAction)touchWeekly:(id)sender {
    isRefresh = TRUE;
    rankRace = 0;
    loadedItemIndex = 0;
    
    [self selectedRaceTimeStampByKey:2];
    
    [self loadRacesList];
    [self loadBanner];
}

- (IBAction)touchMothly:(id)sender {
    isRefresh = TRUE;
    rankRace = 0;
    loadedItemIndex = 0;
    [self selectedRaceTimeStampByKey:1];
    
    [self loadRacesList];
    [self loadBanner];
}

- (IBAction)touchYearly:(id)sender {
    isRefresh = TRUE;
    rankRace = 0;
    loadedItemIndex = 0;
    
    [self selectedRaceTimeStampByKey:0];
    
    [self loadRacesList];
    [self loadBanner];
}

- (IBAction)touchViewAll:(id)sender {
    [self.navigationController setNavigationBarHidden:FALSE];
    _heightOfSpace.constant = 0;
    
    PhotosTaggedInRacesViewController *view = [[PhotosTaggedInRacesViewController alloc] initWithNibName:@"PhotosTaggedInRacesViewController" bundle:nil];
    view.joinState = self.isJoin;
    view.isComingSoon = _isComingSoon;
    view.parentView = self;
    view.raceName = _raceName;
    view.key = _key;
    view.gender = gender;
    view.categoryType = self.categoryType;
    view.startTime = _startTime;
    if (categoryType > RACECATEGORY_LOCATION)
        view.raceDate = sEndDate;
    else
        view.raceDate = @"";
    //    view.raceCategory = categoryType;
    
    [self.navigationController pushViewController:view animated:YES];
}

- (IBAction)touchBackToTop:(id)sender {
    [_tableView setContentOffset:CGPointZero animated:YES];
    [_backToTopButton setHidden:TRUE];
    if (userList.count > 0) {
        if (((RacesObj *)[userList firstObject]).rank != 1) {
            [self pullToRefresh];
        }
    }
}

- (IBAction)touchBanner:(id)sender
{
    BannerObj *tempBanner = [bannerList objectAtIndex:self.currentIndex];
    
    if (profileData.uid != tempBanner.uid)
    {
        UserProfileViewController *view = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
        view.uid = tempBanner.uid;
        
        [self.navigationController pushViewController:view animated:TRUE];
    }
    else
    {
        [AppDelegate setSelectedIndexTabbar:4];
    }
    
}

- (IBAction)touchSeeNewUpdatesButton:(id)sender {
    [self pullToRefresh];
    [_btnUpdateRace setHidden:TRUE];
}

- (void)touchBackButton
{
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - SearchBar

- (void)expandSearchBar:(BOOL)expand
{
    if (expand)
    {
        self.viewAllButtonWidth.constant = 0;
        [UIView animateWithDuration:0.3 animations:^{
            [self.viewAllButton setNeedsLayout];
            [self.view layoutIfNeeded];
        }];
    }
    else
    {
        self.viewAllButtonWidth.constant = DEFAULT_BUTTON_VIEW_ALL_WIDTH;
        [UIView animateWithDuration:0.3 animations:^{
            [self.viewAllButton setNeedsLayout];
            [self.view layoutIfNeeded];
        }];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self expandSearchBar:true];
    
    [searchList removeAllObjects];
    [searchBar setShowsCancelButton:YES animated:YES];
    [_notfoundView setHidden:YES];
    _searchResultTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view endEditing:NO];
    [_searchResultTableView reloadData];
    hidingkeyBoard = TRUE;
    _searchBar.text = @"";
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    searchPage = 0;
    if(_searchBar.text.length > 0 && ![[_searchBar.text substringToIndex:1] isEqualToString:@"#"]){
        //        NSString *searchString = [_searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        @try{
            API_RaceSearch *api = [[API_RaceSearch alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] key:_key ckey:ckey gender:gender term:_searchBar.text page:searchPage size:RACE_SEARCH_LIMIT];
            [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                [self getDataRacesSearch_fetches:jsonObject response:response];
            } ErrorHandlure:^(NSError *error) {
                
            }];
        }@catch(NSException *e) {
            NSLog(@"%@", e.description);
        }
        hidingkeyBoard = TRUE;
    } else {
        [searchList removeAllObjects];
        [_notfoundView setHidden:YES];
        _searchResultTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        hidingkeyBoard = false;
        [_searchResultTableView reloadData];
    }
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchPage = 0;
    searchBar.text = @"";
    
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self expandSearchBar:false];
    
    [searchList removeAllObjects];
    self.searchResultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.searchResultTableView reloadData];
    [self.notfoundView setHidden:YES];
    [self.searchView setHidden:true];
    [self.searchResultTableView setHidden:true];
    isLoadSearch = TRUE;
    hidingkeyBoard = false;
    [self.view endEditing:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if(_searchBar.text.length > 0 && [[_searchBar.text substringToIndex:1] isEqualToString:@"#"]){
        isLoadSearch = FALSE;
        rankSelected = [[searchBar.text substringFromIndex:1] integerValue];
    }
    else{
        isLoadSearch = TRUE;
    }
    NSString *searchString = _searchBar.text;
    @try {
        API_RaceSearch *api = [[API_RaceSearch alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] key:_key ckey:ckey gender:gender term:searchString page:searchPage size:RACE_SEARCH_LIMIT];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            [self getDataRacesSearch_fetches:jsonObject response:response];
        } ErrorHandlure:^(NSError *error) {
            
        }];
    }@catch(NSException *e) {
        NSLog(@"%@", e.description);
    }
}

#pragma mark - API Functions

- (void)getDataRacesSearch_fetches:(BaseJSON *)jsonObject response:(RestfulResponse*)response {
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    if ([response status]) {
        JSON_RaceSearch *data = (JSON_RaceSearch*)jsonObject;
        if (isLoadSearch) {
            if ([[data searchList] count] == 0 && searchPage == 0)
            {
                // show NOT FOUND view instead of table view
                [_notfoundView setHidden:NO];
                
            } else {
                [_notfoundView setHidden:YES];
                
            }
            
            if(searchPage == 0) {
                searchList = [data searchList];
            } else {
                //                [searchList removeLastObject];
                [searchList addObjectsFromArray:data.searchList];
            }
            
            //            if(data.searchList.count > 0) {
            //                [searchList addObject:[[NSObject alloc] init]];
            //            }
            
            self.searchResultTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            [self.searchResultTableView reloadData];
            
        } else {
            isLoadSearch = TRUE;
            if([[data searchList] count] == 0)
            {
                // show NOT FOUND view instead of table view
                [_notfoundView setHidden:NO];
                
            } else {
                [_notfoundView setHidden:YES];
                
                [_searchView setHidden:TRUE];
                userList = [data searchList];
                [self.view endEditing:YES];
                
                isfindingRow = true;
                
                int index = 0;
                for (int i = 0 ; i < userList.count; i++) {
                    RacesObj *temp = (RacesObj *)[userList objectAtIndex:i];
                    if (temp.rank == rankSelected) {
                        index = i;
                    }
                }
                
                indexFinding = index;
                RacesObj *temp = (RacesObj *)[userList firstObject];
                if(temp.rank == 1) {
                    self.loadPreviousView.hidden = true;
                } else {
                    self.loadPreviousView.hidden = false;
                }
                
                [_tableView reloadData];
                
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            }
        }
    } else {
        [AppHelper showMessageBox:nil message:response.message];
    }
}

-(void)didConfirmationPopupOK:(NSInteger) locID
{
    UserDefaultManager *userManager = [(AppDelegate *)[UIApplication sharedApplication].delegate getUserManager];
    location *param = [[location alloc] initWithAccess_Token:[userManager getAccessToken] device_token:[userManager getDeviceToken] locationID:locID];
    if (param) {
        API_Profile_Location *api = [[API_Profile_Location alloc] initWithParams:param];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
            if (response.status) {
                [self loadRaceInfo];
            } else {
                
                [AppHelper showMessageBox:nil message:response.message];
            }
        } ErrorHandlure:^(NSError *error) {
            [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        }];
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner startAnimating];
    }
    
}

-(void) selectedRaceTimeStampByKey:(NSInteger)indexKey{
    switch (indexKey) {
        case 0: // YEARLY
        {
            self.timeStamp = @"y";
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
            [self removeThankYou];
            
            [_selectedView setHidden:isHideSearchBar];
            [_dailyButton setEnabled:TRUE];
            [_dailyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
            [_dailyButton.titleLabel setFont:[UIFont fontWithName:@"SFUIDisplay-Light" size:11]];
            [_dailyButton setBackgroundColor:[UIColor clearColor]];
            
            [_weeklyButton setEnabled:TRUE];
            [_weeklyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
            [_weeklyButton.titleLabel setFont:[UIFont fontWithName:@"SFUIDisplay-Light" size:11]];
            [_weeklyButton setBackgroundColor:[UIColor clearColor]];
            
            [_monthlyButton setEnabled:TRUE];
            [_monthlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
            [_monthlyButton.titleLabel setFont:[UIFont fontWithName:@"SFUIDisplay-Light" size:11]];
            [_monthlyButton setBackgroundColor:[UIColor clearColor]];
            
            [_yearlyButton setEnabled:FALSE];
            [_yearlyButton setTitleColor:UIColorFromRGB(0xB22225) forState:UIControlStateDisabled];
            [_yearlyButton.titleLabel setFont:[UIFont fontWithName:@"SFUIDisplay-Semibold" size:11]];
            [_yearlyButton setBackgroundColor:[UIColor whiteColor]];
            
            NSString* myString = [NSString stringWithFormat:@"%@/ %@", self.raceName,currentYear];
            
            [raceTitleButton setTitle:myString forState:UIControlStateNormal];
            
            CGFloat length = [self widthOfString:myString withFont:myFont];
            
            imageExpand.frame = CGRectMake( length + 3, 17, imageExpand.frame.size.width, imageExpand.frame.size.height );
            
            if (_ckeyList.count > 0) {
                childs *temp = (childs *)[_ckeyList objectAtIndex:0];
                ckey = temp.key;
            } else {
                ckey = @"y";
            }
            break;
        }
        case 1: // MONTHLY
        {
            self.timeStamp = @"m";
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
            [self removeThankYou];
            [_selectedView setHidden:isHideSearchBar];
            [_dailyButton setEnabled:TRUE];
            [_dailyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
            [_dailyButton.titleLabel setFont:[UIFont fontWithName:@"SFUIDisplay-Light" size:11]];
            [_dailyButton setBackgroundColor:[UIColor clearColor]];
            
            [_weeklyButton setEnabled:TRUE];
            [_weeklyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
            [_weeklyButton.titleLabel setFont:[UIFont fontWithName:@"SFUIDisplay-Light" size:11]];
            [_weeklyButton setBackgroundColor:[UIColor clearColor]];
            
            [_monthlyButton setEnabled:FALSE];
            [_monthlyButton setTitleColor:UIColorFromRGB(0xB22225) forState:UIControlStateDisabled];
            [_monthlyButton.titleLabel setFont:[UIFont fontWithName:@"SFUIDisplay-Semibold" size:11]];
            [_monthlyButton setBackgroundColor:[UIColor whiteColor]];
            
            [_yearlyButton setEnabled:TRUE];
            [_yearlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
            [_yearlyButton.titleLabel setFont:[UIFont fontWithName:@"SFUIDisplay-Light" size:11]];
            [_yearlyButton setBackgroundColor:[UIColor clearColor]];
            
            NSString* myString = [NSString stringWithFormat:@"%@/ %@", self.raceName,NSLocalizedString(@"MonthButton.title", )];
            
            [raceTitleButton setTitle:myString forState:UIControlStateNormal];
            
            CGFloat length = [self widthOfString:myString withFont:myFont];
            
            imageExpand.frame = CGRectMake( length +3, 17, imageExpand.frame.size.width, imageExpand.frame.size.height );
            
            if (_ckeyList.count > 0) {
                childs *temp = (childs *)[_ckeyList objectAtIndex:1];
                ckey = temp.key;
            } else {
                ckey = @"m";
            }
            
            break;
        }
        case 2: // WEEKLY
        {
            self.timeStamp = @"w";
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
            [self removeThankYou];
            [_selectedView setHidden:isHideSearchBar];
            [_dailyButton setEnabled:TRUE];
            [_dailyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
            [_dailyButton.titleLabel setFont:[UIFont fontWithName:@"SFUIDisplay-Light" size:11]];
            [_dailyButton setBackgroundColor:[UIColor clearColor]];
            
            [_weeklyButton setEnabled:FALSE];
            [_weeklyButton setTitleColor:UIColorFromRGB(0xB22225) forState:UIControlStateDisabled];
            [_weeklyButton.titleLabel setFont:[UIFont fontWithName:@"SFUIDisplay-Semibold" size:11]];
            [_weeklyButton setBackgroundColor:[UIColor whiteColor]];
            
            [_monthlyButton setEnabled:TRUE];
            [_monthlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
            [_monthlyButton.titleLabel setFont:[UIFont fontWithName:@"SFUIDisplay-Light" size:11]];
            [_monthlyButton setBackgroundColor:[UIColor clearColor]];
            
            [_yearlyButton setEnabled:TRUE];
            [_yearlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
            [_yearlyButton.titleLabel setFont:[UIFont fontWithName:@"SFUIDisplay-Light" size:11]];
            [_yearlyButton setBackgroundColor:[UIColor clearColor]];
            
            NSString* myString = [NSString stringWithFormat:@"%@/ %@", self.raceName,NSLocalizedString(@"WeekButton.title", )];
            
            [raceTitleButton setTitle:myString forState:UIControlStateNormal];
            
            CGFloat length = [self widthOfString:myString withFont:myFont];
            
            imageExpand.frame = CGRectMake( length +3, 17, imageExpand.frame.size.width, imageExpand.frame.size.height );
            
            if (_ckeyList.count > 0) {
                childs *temp = (childs *)[_ckeyList objectAtIndex:2];
                ckey = temp.key;
            } else {
                ckey = @"w";
            }
            break;
        }
        case 3: //DAILY
        {
            self.timeStamp = @"d";
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
            [self removeThankYou];
            [_selectedView setHidden:isHideSearchBar];
            [_dailyButton setEnabled:FALSE];
            [_dailyButton setTitleColor:UIColorFromRGB(0xB22225) forState:UIControlStateDisabled];
            [_dailyButton.titleLabel setFont:[UIFont fontWithName:@"SFUIDisplay-Semibold" size:11]];
            [_dailyButton setBackgroundColor:[UIColor whiteColor]];
            
            [_weeklyButton setEnabled:TRUE];
            [_weeklyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
            [_weeklyButton.titleLabel setFont:[UIFont fontWithName:@"SFUIDisplay-Light" size:11]];
            [_weeklyButton setBackgroundColor:[UIColor clearColor]];
            
            [_monthlyButton setEnabled:TRUE];
            [_monthlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
            [_monthlyButton.titleLabel setFont:[UIFont fontWithName:@"SFUIDisplay-Light" size:11]];
            [_monthlyButton setBackgroundColor:[UIColor clearColor]];
            
            [_yearlyButton setEnabled:TRUE];
            [_yearlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
            [_yearlyButton.titleLabel setFont:[UIFont fontWithName:@"SFUIDisplay-Light" size:11]];
            [_yearlyButton setBackgroundColor:[UIColor clearColor]];
            
            NSString* myString = [NSString stringWithFormat:@"%@/ %@", self.raceName,NSLocalizedString(@"DailyButton.title", )];
            
            [raceTitleButton setTitle:myString forState:UIControlStateNormal];
            
            CGFloat length = [self widthOfString:myString withFont:myFont];
            
            imageExpand.frame = CGRectMake( length +3, 17, imageExpand.frame.size.width, imageExpand.frame.size.height );
            
            if (_ckeyList.count > 0) {
                childs *temp = (childs *)[_ckeyList objectAtIndex:3];
                ckey = temp.key;
            } else {
                ckey = @"d";
            }
            break;
        }
        default:
        {
            [_selectedView setHidden:YES];
            ckey = @"";
            break;
        }
    }
    /*
     if ([timeKey isEqualToString:@"d"]) {
     <#statements#>
     } else if ([timeKey isEqualToString:@"w"]){
     
     } else if ([timeKey isEqualToString:@"m"]){
     
     } else if ([timeKey isEqualToString:@"y"]){
     
     }*/
}

#pragma mark - Other Functions
- (void) enableTopBar
{
    [_yearlyButton setUserInteractionEnabled:YES];
    [_monthlyButton setUserInteractionEnabled:YES];
    [_weeklyButton setUserInteractionEnabled:YES];
    [_dailyButton setUserInteractionEnabled:YES];
    [self.viewAllButton setUserInteractionEnabled:YES];
}

- (void) disableTopBar
{
    [_yearlyButton setUserInteractionEnabled:NO];
    [_monthlyButton setUserInteractionEnabled:NO];
    [_weeklyButton setUserInteractionEnabled:NO];
    [_dailyButton setUserInteractionEnabled:NO];
    [self.viewAllButton setUserInteractionEnabled:NO];
}

- (void)hideSearchBar {
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self expandSearchBar:false];
    _searchBar.text = @"";
    [searchList removeAllObjects];
    [_notfoundView setHidden:YES];
    //    _searchResultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.searchView setHidden:true];
    [self.searchResultTableView setHidden:true];
    isLoadSearch = TRUE;
    hidingkeyBoard = false;
    [self.view endEditing:YES];
}

- (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)Font {
    NSDictionary *userAttributes = @{NSFontAttributeName: Font,
                                     NSForegroundColorAttributeName: [UIColor blackColor]};
    
    CGSize textSize = [string sizeWithAttributes: userAttributes];
    
    return textSize.width;
}

@end
