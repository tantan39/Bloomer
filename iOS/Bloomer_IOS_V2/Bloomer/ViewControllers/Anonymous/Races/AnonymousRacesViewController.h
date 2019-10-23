//
//  AnonymousRacesViewController.h
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 5/3/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarView.h"
#import "RacesTableViewCell.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "UserDefaultManager.h"
#import "childs.h"
#import "API_Anonymous_Races_BannerFetches.h"
#import "BannerObj.h"
#import "UserProfileViewController.h"
#import "AnonymousUserProfileViewController.h"
#import "API_RaceSearch.h"
#import "API_AnonymousRaceSurprise.h"

@interface AnonymousRacesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate,  UISearchBarDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) TabBarView *tabbar;
@property (weak, nonatomic) IBOutlet UIView *selectedView;
@property (weak, nonatomic) IBOutlet UIButton *dailyButton;
@property (weak, nonatomic) IBOutlet UIButton *weeklyButton;
@property (weak, nonatomic) IBOutlet UIButton *monthlyButton;
@property (weak, nonatomic) IBOutlet UIButton *yearlyButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *pictureView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIScrollView *slideshow;
@property (weak, nonatomic) IBOutlet UILabel *swipeLabel;
@property (weak, nonatomic) IBOutlet UIButton *backToTopButton;
@property (weak, nonatomic) IBOutlet UIButton *buttonSurprise;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdateRace;
@property (weak, nonatomic) IBOutlet UIView *cornerView;
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet UILabel *labelEmptyTitle;
@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@property (weak, nonatomic) IBOutlet UIView *notfoundView;
@property (weak, nonatomic) IBOutlet UILabel *notFoundLabel;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITableView *searchResultTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfSpace;


- (IBAction)touchBanner:(id)sender;
- (IBAction)touchSuppise:(id)sender;
- (IBAction)touchDaily:(id)sender;
- (IBAction)touchWeekly:(id)sender;
- (IBAction)touchMothly:(id)sender;
- (IBAction)touchYearly:(id)sender;
- (IBAction)touchViewAll:(id)sender;
- (IBAction)touchBackToTop:(id)sender;
- (IBAction)touchSeeNewUpdatesButton:(id)sender;



@property (assign, nonatomic) NSInteger currentIndex;
@property (weak, nonatomic) NSString *key;
@property (strong, nonatomic) NSMutableArray *ckeyList;
@property (weak, nonatomic) NSString *raceName;
@property (assign, nonatomic) NSInteger categoryType;
@property (assign, nonatomic) NSInteger locationID;
@property (assign, nonatomic) long long endTime;
@property (strong, nonatomic) NSString *endDate;
@property (assign, nonatomic) NSInteger isJoin;
@property (strong, nonatomic) NSString *rules;
@property (strong, nonatomic) NSString *raceInfo;
@property (strong, nonatomic) NSString *joinInfo;
@property (strong, nonatomic) NSString *leaveInfo;
@property (strong, nonatomic) NSString *avatarRace;
@property (assign, nonatomic) BOOL isViewRaceTop;
@property (assign, nonatomic) NSInteger gender;
@property (assign, nonatomic) BOOL isHideSearchBar;

- (void)pullToRefresh;
- (void)loadSurprise;
//- (void)loadMyRank;
- (void)giveFlower:(long long)flower;
- (void)loadRaceTop;
- (void)showUpdateRace;

@end
