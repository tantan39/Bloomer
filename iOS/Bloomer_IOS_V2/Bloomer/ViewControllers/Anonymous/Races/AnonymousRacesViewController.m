//
//  AnonymousRacesViewController.m
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 5/3/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#define RACE_SEARCH_LIMIT 10

#import "AnonymousRacesViewController.h"
#import "AppDelegate.h"
#import "UIColor+Extension.h"
#import "AppHelper.h"
#import "AnonymousLoginPopUpView.h"
#import "API_AnonymousRaceName.h"
#import "API_AnonymousRace.h"
#import "API_AnonymousRaceSurprise.h"
#import "UISearchBar+Extension.h"

@interface AnonymousRacesViewController () {
    
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
    BOOL isLoadSearch;
    NSInteger rankSelected;
    BOOL isSurprise;
    UIRefreshControl *refreshControl;
    BOOL touchTop;
    BOOL isLoadScroll;
    BOOL isViewRaceTop;
    NSString *sEndDate;
    NSInteger currentPopUp;
    BOOL isFetchingRace;
    BOOL isBeingSurprise;
    NSInteger numberRandom;
    BOOL isSurpriseCellLoaded;
    NSString* currentYear;
    CGRect frameSearchView;
    BOOL hidingkeyBoard;
    NSInteger focusIndexInRace;
    
    UIButton * changeLayoutButton;
    UIImageView* imageExpand;
    
    
    BOOL isfindingRow;
    int indexFinding;
    BOOL isFindingCellLoad;
    BOOL IsOutOfScreen;
    CGRect searchBarRect;
    
    UIFont *myFont;
    NSInteger myRank;
    BOOL rankReloadView;
}

@end

@implementation AnonymousRacesViewController

@synthesize isViewRaceTop, categoryType, gender = gender, isHideSearchBar = isHideSearchBar;;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    _currentIndex = 0;
    
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
    
    isHideSearchBar = true;
    
    isBeingSurprise = false;
    isSurpriseCellLoaded = false;
    
    isfindingRow = false;
    isFindingCellLoad = false;
    
    [_dailyButton setEnabled:FALSE];
    [_dailyButton setTitleColor:[UIColor colorWithRed:0.125 green:0.125 blue:0.129 alpha:1.0] forState:UIControlStateDisabled];
    [_dailyButton.titleLabel setFont:[UIFont fontWithName:@"SFUIDisplay-Semibold" size:11]];
    [_dailyButton setBackgroundColor:[UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1.0]];
    _dailyButton.layer.borderWidth = 1;
    _dailyButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.buttonSurprise.layer.cornerRadius = self.buttonSurprise.frame.size.height / 2;
    self.buttonSurprise.clipsToBounds = true;
    self.buttonSurprise.layer.borderColor = [UIColor colorFromHexString:@"#B22225"].CGColor;
    self.buttonSurprise.layer.borderWidth = 1.3;
    
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
    self.topBar.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.topBar.bounds].CGPath;
    
    __weak AnonymousRacesViewController *weakSelf = self;
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshDoneLoading:) forControlEvents:UIControlEventValueChanged];
    [refreshControl setTintColor:[UIColor redColor]];
    [refreshControl setAutoresizingMask:(UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin)];
    [refreshControl setFrame:CGRectMake(0, 0, 320, 30)];
    [_tableView addSubview:refreshControl];
    
    [_tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf infiniteScrolling];
    }];
    
    [self getCurrentDay];
    
    [_yearlyButton setTitle:currentYear forState:UIControlStateNormal];
    
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _tabbar = appDelegate.tabbar;

    [self loadRaceInfo];
    
    searchBarRect = self.searchBar.frame;
    myFont = [UIFont fontWithName:@"SFUIDisplay-Regular" size:16];
    [self.searchBar setupSearchBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupLanguage];
    
    [_tableView setDelegate:self];
    
    [_tabbar.draggableButton removeAllAllowedDropLocations ];
    [_tableView reloadData];
    
    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //reload banner
    [self initSlideShow];
    
    if (_tableView.contentOffset.y > [UIScreen mainScreen].bounds.size.height - 70 && _btnUpdateRace.isHidden)
    {
        [_backToTopButton setHidden:FALSE];
        [self.navigationController setNavigationBarHidden:TRUE];
        _heightOfSpace.constant = 20;
    }
    
    if (_tableView.contentOffset.y < [UIScreen mainScreen].bounds.size.height - 70 && _btnUpdateRace.isHidden) {
        [_backToTopButton setHidden:TRUE];
        [self.navigationController setNavigationBarHidden:FALSE];
        _heightOfSpace.constant = 0;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_tableView setDelegate:nil];
    [timer invalidate];
}

- (void)setupLanguage
{
    [self.searchBar setPlaceholder:NSLocalizedString(@"Leaderboard.searchPlaceholder", )];
    [self.buttonSurprise setTitle:[AppHelper getLocalizedString:@"Leaderboard.buttonViewAll"] forState:UIControlStateNormal];
    self.labelEmptyTitle.text = [AppHelper getLocalizedString:@"Leaderboard.labelEmptyView"];
    [_dailyButton setTitle:NSLocalizedString(@"DailyButton.title", ) forState:UIControlStateNormal];
    [_weeklyButton setTitle:NSLocalizedString(@"WeekButton.title", ) forState:UIControlStateNormal];
    [_monthlyButton setTitle:NSLocalizedString(@"MonthButton.title", ) forState:UIControlStateNormal];
    
    [_backToTopButton setTitle:NSLocalizedString(@"BackToTopLeaderBoard.title", ) forState:UIControlStateNormal];
    [_btnUpdateRace setTitle:NSLocalizedString(@"SeeMoreUpdateLeaderBoard.title", ) forState:UIControlStateNormal];
    
    _swipeLabel.text = NSLocalizedString(@"SwipeLabelLeaderBoard.title", );
}

- (void)refreshDoneLoading:(UIRefreshControl *)refresh
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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
    
    [self loadRacesList];
    [self loadBanner];
    
    [_tableView.pullToRefreshView stopAnimating];
}

- (void)infiniteScrolling {
    if (userList.count != 0) {
        rankRace = [(RacesObj *)([userList objectAtIndex:userList.count - 1]) rank];
    } else {
        rankRace = 0;
    }
    
    if (!isSurprise) {
        isRefresh = TRUE;
        [self loadRacesList];
        lastRankRace = rankRace;
    }
    
    [_tableView.infiniteScrollingView stopAnimating];
}

- (void)loadRaceInfo {
    [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner startAnimating];
    
    API_AnonymousRaceName *api = [[API_AnonymousRaceName alloc] initWithKey:self.key gender:self.gender];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        if (response.status) {
            JSON_RacesNameFetch *racesNameJSON = (JSON_RacesNameFetch *)jsonObject;
            //            _key = data.key;
            _ckeyList = racesNameJSON.childsList;
            _raceName = racesNameJSON.name;
            _endTime = racesNameJSON.end;
            _isJoin = racesNameJSON.isJoin;
            _rules = racesNameJSON.rules;
            categoryType = racesNameJSON.category;
            _endDate = racesNameJSON.endDate;
            _raceInfo = racesNameJSON.raceInfo;
            _joinInfo = racesNameJSON.joinInfo;
            _leaveInfo = racesNameJSON.leaveInfo;
            _locationID = racesNameJSON.locationID;
            
            if (categoryType > RACECATEGORY_LOCATION) // not VietNam & Locaiton Race
            {
                // hide timebar
                [self selectedRaceTimeStampByKey:-1];
            } else {
                //set cKey is default-DAILY
                [self selectedRaceTimeStampByKey:1];
            }
            
            rankRace = 0;
            loadedItemIndex = 0;
            [self loadRacesList];
            [self loadBanner];
            [self initNavigationBar];
        } else {
            [AppHelper showMessageBox:@"" message:response.message];
        }
        
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        
    } ErrorHandlure:^(NSError *error) {
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];
}

- (void)loadRacesList {
    if (isFetchingRace) {
        return;
    }
    isFetchingRace = true;
    [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner startAnimating];
    
    API_AnonymousRace *api = [[API_AnonymousRace alloc] initWithKey:self.key ckey:ckey rank:rankRace isRefresh:isRefresh gender:gender];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        isFetchingRace = false;
        
        if (response.status) {
            JSON_RacesFetch *racesJSON = (JSON_RacesFetch *)jsonObject;
            isRefresh = false;
            
            if (racesJSON.racesList.count != 0 || loadedItemIndex > 0) {
                self.emptyView.hidden = true;
                self.tableView.scrollEnabled = true;
            } else {
                self.emptyView.hidden = false;
            }
            
            if (loadedItemIndex == 0) {
                userList = racesJSON.racesList;
                [_tabbar.draggableButton removeAllAllowedDropLocations ];
                [_tableView reloadData];
                
                [_tableView setContentOffset:CGPointZero animated:YES]; // scroll to top
                loadedItemIndex += 12;
            } else {
                if (racesJSON.racesList.count != 0)
                {
                    [self.tableView setContentOffset:self.tableView.contentOffset animated:NO];
                    [userList addObjectsFromArray:racesJSON.racesList];
                    [_tabbar.draggableButton removeAllAllowedDropLocations ];
                    [_tableView reloadData];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([racesJSON racesList].count != 12) {
                            loadedItemIndex -= 12 - racesJSON.racesList.count;
                        }
                        
                        loadedItemIndex += 12;
                    });
                    
                }
            }
        } else {
            [AppHelper showMessageBox:@"" message:response.message];
        }
        
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        
    } ErrorHandlure:^(NSError *error) {
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

- (void)loadSurprise
{
    [self.tableView setContentOffset:self.tableView.contentOffset animated:false];
    [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner startAnimating];
    
    API_AnonymousRaceSurprise *api = [[API_AnonymousRaceSurprise alloc] initWithKey:self.key ckey:ckey gender:gender];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        if (response.status) {
            JSON_RacesFetch *racesJSON = (JSON_RacesFetch *)jsonObject;
            userList = racesJSON.racesList;
            
            if (userList.count > 0) {
                [self.tableView setContentOffset:self.tableView.contentOffset animated:NO];
                isBeingSurprise = true;
                isSurpriseCellLoaded = false;
                numberRandom = arc4random() % userList.count;
                [_tableView reloadData];
                
                NSIndexPath* path = [NSIndexPath indexPathForRow:numberRandom inSection:0];
                [_tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            } else {
                isBeingSurprise = false;
            }
        } else {
            [AppHelper showMessageBox:@"" message:response.message];
        }
        
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        
    } ErrorHandlure:^(NSError *error) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];
}

- (void)loadRaceTop {
    //    [_tableView setContentOffset:CGPointZero animated:YES];
    [self pullToRefresh];
}

- (void)loadBanner {
    [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner startAnimating];
    
    API_Anonymous_Races_BannerFetches *api = [[API_Anonymous_Races_BannerFetches alloc] initWithGender:gender key:_key cKey:ckey];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        JSON_BannerFetch *data = (JSON_BannerFetch *)jsonObject;
        if (response.status) {
            bannerList = data.bannerList;
            [self initSlideShow];
        } else {
            //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[data getTitle]
            //                                                        message:[data getMegs]
            //                                                       delegate:self
            //                                              cancelButtonTitle:NSLocalizedString(@"OK",)
            //                                              otherButtonTitles:nil];
            //        [alert show];
            [self addErrorMessage:response.message];
        }
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        
    } ErrorHandlure:^(NSError *error) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];
}

-(void) showUpdateRace{
    [_btnUpdateRace setHidden:FALSE];
    [_backToTopButton setHidden:TRUE];
}

- (void)initSlideShow
{
    [timer invalidate];
    scroll = false;
    [_slideshow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 0; i < bannerList.count; i++)
    {
        BannerObj *temp = (BannerObj *)[bannerList objectAtIndex:i];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, self.slideshow.frame.size.height)];
        [image setImageWithURL:[NSURL URLWithString:temp.photo_url]];
        image.contentMode = UIViewContentModeScaleAspectFill;
        image.clipsToBounds = TRUE;
        
        UIImageView *rankView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rec_places.png"]];
        [rankView setFrame:CGRectMake(12, 0, 36, 44)];
        [image addSubview:rankView];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(320 * i, 0, 320, self.slideshow.frame.size.height)];
        [button addTarget:self action:@selector(touchBanner:) forControlEvents:UIControlEventTouchUpInside];
        [button addSubview:image];
        
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(12, -3, 36, 44)];
        lb.backgroundColor = [UIColor clearColor];
        lb.font = [UIFont fontWithName:@"SFUIDisplay-Semibold" size:21];
        lb.textColor = [UIColor whiteColor];
        lb.text = @(i+1).stringValue;
        [lb setTextAlignment:NSTextAlignmentCenter];
        [image addSubview:lb];
        
        //        [_slideshow addSubview:image];
        [self.slideshow addSubview:button];
    }
    
    UIImageView *BGImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Image_View_All_Photos"]];
    [BGImage setFrame:CGRectMake(0, 0, 320, _slideshow.frame.size.height)];
    
    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(80, 85, 40, 35)];
    [iconImage setImage:[UIImage imageNamed:@"icon_image.png"]];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(320 * bannerList.count, 0, 320, self.slideshow.frame.size.height)];
    [button addTarget:self action:@selector(touchViewAll:) forControlEvents:UIControlEventTouchUpInside];
    [button addSubview:BGImage];
    
    UILabel *viewPicture = [[UILabel alloc] initWithFrame:CGRectMake(132, 53, 150, 100)];
    viewPicture.backgroundColor = [UIColor clearColor];
    viewPicture.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:14];
    viewPicture.numberOfLines = 0;
    viewPicture.textColor = [UIColor colorWithRed:0.698 green:0.133 blue:0.145 alpha:1.0];
    
    if ([_slideshow.subviews count] == 0)
    {
        viewPicture.text = NSLocalizedString(@"Be the first person\nto join this contest!",);
        viewPicture.textAlignment = NSTextAlignmentCenter;
        [viewPicture setFrame:CGRectMake(60, 40, 200, 100)];
    }
    else
    {
        [BGImage addSubview:iconImage];
        viewPicture.text = NSLocalizedString(@"View all photos of this contest",);
    }
    
    [BGImage addSubview:viewPicture];
    [_slideshow addSubview:button];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(slideImage) userInfo:nil repeats:YES];
    _slideshow.contentSize = CGSizeMake((bannerList.count + 1) * 320, _slideshow.frame.size.height);
    pageIndex = 1;
    [_slideshow setContentOffset:CGPointMake(0, 0) animated:YES];
    if(bannerList.count == 0 )
        [_swipeLabel setHidden:TRUE];
    else
        [_swipeLabel setHidden:FALSE];
    
}

//////////

- (void)slideImage {
    _currentIndex++;
    offset = 320 * _currentIndex;
    [_slideshow setContentOffset:CGPointMake(offset, _slideshow.contentOffset.y) animated:YES];
    
    if (_currentIndex > bannerList.count)
    {
        //delay = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(scrollToFirstPage) userInfo:nil repeats:NO];
        [self scrollToFirstPage];
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
        if (_tableView.contentOffset.y > [UIScreen mainScreen].bounds.size.height && _btnUpdateRace.isHidden)
        {
            [_backToTopButton setHidden:FALSE];
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            _heightOfSpace.constant = 20;
            if(!isHideSearchBar) {
                [self LeftRevealToggle];
            }
        }
        
        if (_tableView.contentOffset.y < 1) {
            [_backToTopButton setHidden:TRUE];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            _heightOfSpace.constant = 0;
        }
        //        lastContentOffset = _tableView.contentOffset.y;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == _slideshow) {
        [timer invalidate];
        scroll = true;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}

- (void)initNavigationBar
{
    if(categoryType > RACECATEGORY_LOCATION)
    {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -15;
        
        UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 9, 200, 19)];
        titleView.textAlignment = NSTextAlignmentLeft;
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:16];
        titleView.textColor = [UIColor whiteColor];
        titleView.text = _raceName;
        
        UILabel *dateView = [[UILabel alloc] initWithFrame:CGRectMake(0, 21, 250, 13)];
        dateView.textAlignment = NSTextAlignmentLeft;
        dateView.backgroundColor = [UIColor clearColor];
        dateView.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:11];
        dateView.textColor = [UIColor whiteColor];
        dateView.text = _endDate;
        
        sEndDate = dateView.text;
        
        UIView *title = [[UIView alloc] initWithFrame:CGRectMake(60, 20, 200, 35)];
        
        [title addSubview:titleView];
        [title addSubview:dateView];
        
        UIBarButtonItem *leftTitle = [[UIBarButtonItem alloc] initWithCustomView:title];

        self.navigationItem.leftItemsSupplementBackButton = true;
        [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects: leftTitle, nil]];
        
        [title sizeToFit];
    }
    else
    {
        NSString* myString = [NSString stringWithFormat:@"%@/ %@", self.raceName,NSLocalizedString(@"MonthButton.title", )];
        
        CGFloat length = [self widthOfString:myString withFont:myFont ];
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -15;
        
        UIView* LeftButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 250, 60)];
        
        changeLayoutButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        [changeLayoutButton addTarget:self action:@selector(LeftRevealToggle)forControlEvents:UIControlEventTouchUpInside];
        changeLayoutButton.autoresizesSubviews = YES;
        changeLayoutButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
        
        changeLayoutButton.titleLabel.font = myFont;
        
        [changeLayoutButton setFrame:CGRectMake(0, 0, 150, 60)];
        
        [changeLayoutButton setTitle:myString forState:UIControlStateNormal];
        
        changeLayoutButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        imageExpand = [[UIImageView alloc]  initWithFrame:CGRectMake(length + 3, 28, 9, 5)];
        
        [imageExpand setImage:[UIImage imageNamed:@"scoll_down"]];
        
        [LeftButtonView addSubview:changeLayoutButton];
        [LeftButtonView addSubview:imageExpand];
        UIBarButtonItem *leftRevealButtonItem = [[UIBarButtonItem alloc] initWithCustomView:LeftButtonView];
        
        self.navigationItem.leftItemsSupplementBackButton = true;
        [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects: leftRevealButtonItem, nil]];
        
    }
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Icon_Leaderboard_More"] style:UIBarButtonItemStylePlain target:self action:@selector(touchInfoButton)];
    UIBarButtonItem *buttonCamera = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Icon_Camera_White"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(touchButtonCamera)];
    NSArray *rightBarButtonArray = [[NSArray alloc] initWithObjects:infoButton, buttonCamera, nil];
    [self.navigationItem setRightBarButtonItems:rightBarButtonArray];
    [self.navigationItem setRightBarButtonItems:rightBarButtonArray];
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


- (void)touchButtonCamera
{
    if ([userDefaultManager isAnonymous])
    {
        [AppHelper showAnonymousLoginPopUpView];
    }
}

- (void) LeftRevealToggle
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
        cell.cellIndex = indexPath;
        cell.tableView = _tableView;
        
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

        [cell setVideoLink:temp.video_link];
        [cell switchStyleForAvatarBorderViewWithMedal:temp.gsbMedal isIcon:NO];
        cell.draggableLocation.hidden = true;
        
        return cell;
    }
    else
    {
        NSString *identifier = @"RacesSearch";
        
        RacesSearchTableViewCell *cell = (RacesSearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"RacesSearchTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        RacesObj  *temp = (RacesObj *)[searchList objectAtIndex:indexPath.row];
        [cell.avatar setImageWithURL:[NSURL URLWithString:temp.avatar]];
        cell.name.text = temp.name;
        cell.username.text = temp.username;
        cell.rank.text = [NSString stringWithFormat:@"#%@", @(temp.rank).stringValue];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    hidingkeyBoard = false;
    RacesObj *temp = (RacesObj *)[userList objectAtIndex:indexPath.row];
    
    AnonymousUserProfileViewController *view = [[AnonymousUserProfileViewController alloc] initWithNibName:@"AnonymousUserProfileViewController" bundle:nil];
    view.uid = temp.uid;
    
    [self.navigationController pushViewController:view animated:YES];

}

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
//                [cell showUpBubbleView];
                [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
                isSurpriseCellLoaded = false;
                isBeingSurprise = false;
                [self.tableView setContentOffset:self.tableView.contentOffset animated:NO];
            }
        }
        
    }
}

#pragma mark - Event Function

- (void)touchInfoButton
{
    if ([userDefaultManager isAnonymous])
    {
        [AppHelper showAnonymousLoginPopUpView];
    }
}

- (IBAction)touchSuppise:(id)sender
{
//    if(isBeingSurprise == false)
//    {
//        [self loadSurprise];
//    }
    [AppHelper showAnonymousLoginPopUpView];
}

- (IBAction)touchDaily:(id)sender
{
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
    if ([userDefaultManager isAnonymous])
    {
        [AppHelper showAnonymousLoginPopUpView];
    }
}

- (IBAction)touchBackToTop:(id)sender {
    [_tableView setContentOffset:CGPointZero animated:YES];
    [_backToTopButton setHidden:TRUE];
}

- (IBAction)touchBanner:(id)sender
{
    BannerObj *tempBanner = [bannerList objectAtIndex:self.currentIndex];
    AnonymousUserProfileViewController *view = [[AnonymousUserProfileViewController alloc] initWithNibName:@"AnonymousUserProfileViewController" bundle:nil];
    view.uid = tempBanner.uid;
    
    [self.navigationController pushViewController:view animated:TRUE];
}

- (IBAction)touchSeeNewUpdatesButton:(id)sender {
    [self pullToRefresh];
    [_btnUpdateRace setHidden:TRUE];
}

#pragma mark - API Functions

-(void) selectedRaceTimeStampByKey:(NSInteger)indexKey{
    switch (indexKey) {
        case 0: // YEARLY
        {
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
            
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
            
            [changeLayoutButton setTitle:myString forState:UIControlStateNormal];
            
            CGFloat length = [self widthOfString:myString withFont:myFont];
            
            imageExpand.frame = CGRectMake( length + 3, 28, imageExpand.frame.size.width, imageExpand.frame.size.height );
            
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
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];

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
            
            [changeLayoutButton setTitle:myString forState:UIControlStateNormal];
            
            CGFloat length = [self widthOfString:myString withFont:myFont];
            
            imageExpand.frame = CGRectMake( length +3, 28, imageExpand.frame.size.width, imageExpand.frame.size.height );
            
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
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
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
            
            [changeLayoutButton setTitle:myString forState:UIControlStateNormal];
            
            CGFloat length = [self widthOfString:myString withFont:myFont];
            
            imageExpand.frame = CGRectMake( length +3, 28, imageExpand.frame.size.width, imageExpand.frame.size.height );
            
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
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];

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
            
            [changeLayoutButton setTitle:myString forState:UIControlStateNormal];
            
            CGFloat length = [self widthOfString:myString withFont:myFont];
            
            imageExpand.frame = CGRectMake( length +3, 28, imageExpand.frame.size.width, imageExpand.frame.size.height );
            
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

}

#pragma mark - SearchBar
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
//    CGRect rect = searchBarRect;
//    rect.size.width = self.view.frame.size.width;
//    [UIView animateWithDuration:0.3 animations:^{
//        self.searchBar.frame = rect;
//    }];
//    
//    [searchList removeAllObjects];
//    [searchBar setShowsCancelButton:YES animated:YES];
//    [_notfoundView setHidden:YES];
//    _searchResultTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    [self.view endEditing:NO];
//    [_searchResultTableView reloadData];
//    hidingkeyBoard = TRUE;
//    return YES;
    
    if ([userDefaultManager isAnonymous])
    {
        [AppHelper showAnonymousLoginPopUpView];
    }
    return NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(_searchBar.text.length > 0 && ![[_searchBar.text substringToIndex:1] isEqualToString:@"#"]){
        NSString *searchString = [_searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        API_RaceSearch *api = [[API_RaceSearch alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] key:_key ckey:ckey gender:gender term:searchString page:0 size:RACE_SEARCH_LIMIT];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            [self getDataRacesSearch_fetches:jsonObject response:response];
        } ErrorHandlure:^(NSError *error) {
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        }];
        hidingkeyBoard = TRUE;
    }
    else{
        [searchList removeAllObjects];
        [_notfoundView setHidden:YES];
        _searchResultTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        hidingkeyBoard = false;
        [_searchResultTableView reloadData];
    }
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.searchBar.frame = searchBarRect;
    }];
    searchBar.text = @"";
    [searchList removeAllObjects];
    [_notfoundView setHidden:YES];
    //    _searchResultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_searchView setHidden:TRUE];
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
    NSString *searchString = [_searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    API_RaceSearch *api = [[API_RaceSearch alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] key:_key ckey:ckey gender:gender term:searchString page:0 size:RACE_SEARCH_LIMIT];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        [self getDataRacesSearch_fetches:jsonObject response:response];
    } ErrorHandlure:^(NSError *error) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];
    hidingkeyBoard = TRUE;
}

- (void)getDataRacesSearch_fetches:(BaseJSON *)jsonObject response:(RestfulResponse*)response {
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    if ([response status]) {
        JSON_RaceSearch* data = (JSON_RaceSearch*)jsonObject;
        if (isLoadSearch) {
            if([[data searchList] count] == 0)
            {
                // show NOT FOUND view instead of table view
                [_notfoundView setHidden:NO];
                
            } else {
                [_notfoundView setHidden:YES];
                
            }
            searchList = [data searchList];
            _searchResultTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            
            [_searchResultTableView reloadData];
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
                
                [_tableView reloadData];
                
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            }
            
        }
    } else {
        [self addErrorMessage:[response message]];
    }
}

#pragma mark - Other Functions

-(void) addErrorMessage:(NSString*) error{
    ErrorMessageView* messView = [[ErrorMessageView alloc]initWithMessage:error];
    [self.view addSubview:messView];
}

- (void) enableTopBar
{
    [_yearlyButton setUserInteractionEnabled:YES];
    [_monthlyButton setUserInteractionEnabled:YES];
    [_weeklyButton setUserInteractionEnabled:YES];
    [_dailyButton setUserInteractionEnabled:YES];
    [_buttonSurprise setUserInteractionEnabled:YES];
}

- (void) disableTopBar
{
    [_yearlyButton setUserInteractionEnabled:NO];
    [_monthlyButton setUserInteractionEnabled:NO];
    [_weeklyButton setUserInteractionEnabled:NO];
    [_dailyButton setUserInteractionEnabled:NO];
    [_buttonSurprise setUserInteractionEnabled:NO];
}

- (void)backButtonPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)Font {
    NSDictionary *userAttributes = @{NSFontAttributeName: Font,
                                     NSForegroundColorAttributeName: [UIColor blackColor]};
    
    CGSize textSize = [string sizeWithAttributes: userAttributes];
    
    return textSize.width;
}

@end
