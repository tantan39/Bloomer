//
//  RacesViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 1/26/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarView.h"
#import "RacesTableViewCell.h"
#import "MenuRacePopupController.h"
#import "MenuRaceViewJoinViewController.h"
#import "SEDraggable.h"
#import "SEDraggableLocation.h"
#import "AwesomeMenu.h"
#import "FlowerMenuPostPopupViewController.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "PhotosTaggedInRacesViewController.h"
#import "API_RacesFetch.h"
#import "UserDefaultManager.h"
#import "childs.h"
#import "API_Races_BannerFetches.h"
#import "BannerObj.h"
#import "flower_give.h"
#import "API_Flower_Give.h"
#import "ImagePickerRaceViewController.h"
#import "API_RaceSearch.h"
#import "RacesSearchTableViewCell.h"
#import "UserProfileViewController.h"
#import "API_RacesMyRank.h"
#import "ConfirmationPopupViewController.h"
#import "API_Profile_Location.h"
#import "PopUpTutorial.h"
#import "ThankYou.h"
#import "CountryAvatarCustomView.h"
#import "API_RacesSurprise.h"
#import "API_RacesNameFetch.h"
#import "API_LoadPrevousRace.h"

@interface RacesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SEDraggableLocationEventResponder, SEDraggableEventResponder, AwesomeMenuDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate, UISearchBarDelegate, ConfirmationPopupDelegate>

@property (weak, nonatomic) TabBarView *tabbar;
@property (weak, nonatomic) IBOutlet UIView *selectedView;
@property (weak, nonatomic) IBOutlet UIButton *dailyButton;
@property (weak, nonatomic) IBOutlet UIButton *weeklyButton;
@property (weak, nonatomic) IBOutlet UIButton *monthlyButton;
@property (weak, nonatomic) IBOutlet UIButton *yearlyButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet SEDraggableLocation *draggableLocation;
@property (weak, nonatomic) IBOutlet SEDraggableLocation *bannerDraggableLocation;
@property (weak, nonatomic) IBOutlet UIView *pictureView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIScrollView *slideshow;
@property (weak, nonatomic) IBOutlet UILabel *swipeLabel;
@property (weak, nonatomic) IBOutlet UIButton *backToTopButton;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITableView *searchResultTableView;
@property (weak, nonatomic) IBOutlet UIView *notfoundView;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdateRace;
@property (weak, nonatomic) IBOutlet UIView *cornerView;
@property (weak, nonatomic) IBOutlet UIScrollView *emptyScrollView;
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet UILabel *labelEmptyTitle;
@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UILabel *notFoundLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfSpace;
@property (weak, nonatomic) IBOutlet UIButton *viewAllButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewAllButtonWidth;
@property (weak, nonatomic) IBOutlet UIView *slideShowContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *slideShowContentViewWidth;
@property (weak, nonatomic) IBOutlet UIView *loadPreviousView;

- (IBAction)touchBanner:(id)sender;
- (IBAction)touchDaily:(id)sender;
- (IBAction)touchWeekly:(id)sender;
- (IBAction)touchMothly:(id)sender;
- (IBAction)touchYearly:(id)sender;
- (IBAction)touchViewAll:(id)sender;
- (IBAction)touchBackToTop:(id)sender;
- (IBAction)touchSeeNewUpdatesButton:(id)sender;

@property (strong, nonatomic) NSMutableArray *listDraggableLocatioinList;
@property (assign, nonatomic) NSInteger currentIndex;
@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSMutableArray *ckeyList;
@property (strong, nonatomic) NSString *raceName;
@property (assign, nonatomic) NSInteger categoryType;
@property (assign, nonatomic) NSInteger locationID;
@property (assign, nonatomic) long long startTime;
@property (assign, nonatomic) long long endTime;
@property (strong, nonatomic) NSString *endDate;
@property (assign, nonatomic) NSInteger isJoin;
@property (assign, nonatomic) BOOL isClosed;
@property (assign, nonatomic) BOOL isComingSoon;
@property (strong, nonatomic) NSString *rules;
@property (strong, nonatomic) NSString *raceInfo;
@property (strong, nonatomic) NSString *joinInfo;
@property (strong, nonatomic) NSString *leaveInfo;
@property (strong, nonatomic) NSString *avatarRace, *timeStamp;
@property (assign, nonatomic) NSInteger gsb;
@property (assign, nonatomic) BOOL isViewRaceTop;
@property (strong, nonatomic) PopUpTutorial* popupTutorialFlowerGive;
@property (assign, nonatomic) NSInteger gender;
@property (strong, nonatomic) AwesomeMenu *circularMenu;
@property (assign, nonatomic) BOOL isHideSearchBar;

@property (strong, nonatomic) void (^OnRaceJoined)();

- (void)pullToRefresh;
- (void)loadSurprise;
- (void)loadMyRank:(BOOL)reloadView;
- (void)giveFlower:(long long)flower;
- (void)loadRaceTop;
- (void)showUpdateRace;
- (void)touchButtonCamera;
- (void) hideSearchBar;
- (void) LeftRevealToggle;
- (void) loadRaceInfo;
@end
