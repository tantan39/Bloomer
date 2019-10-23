//
//  DiscoveryViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 1/19/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarView.h"
#import "DiscoveryTableViewCell.h"

#import "DiscoveryModel.h"
#import "UserDefaultManager.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "SEDraggable.h"
#import "SEDraggableLocation.h"
#import "AwesomeMenu.h"
#import "FlowerMenuPostPopupViewController.h"

#import "SinglePhotoCell.h"
#import "TwoPhotosCell.h"
#import "ThreePhotosCell.h"
#import "FourPhotosCell.h"
#import "FivePhotosCell.h"

#import "API_Flower_GivePost.h"
#import "API_Flower_GiveProfile.h"
#import "city.h"
#import "ThankYou.h"
#import "API_LoadLocation.h"

#import "API_DiscoverySearch.h"
#import "API_DiscoveryFetches.h"
#import "FilterCustomView.h"


@interface DiscoveryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, SEDraggableLocationEventResponder, SEDraggableEventResponder, AwesomeMenuDelegate, UIGestureRecognizerDelegate, UISearchBarDelegate, UISearchControllerDelegate, FilterCustomViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *notFoundView;
@property (weak, nonatomic) TabBarView *tabbar;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *searchResultTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchResultTableViewBottomMargin;
@property (strong, nonatomic) out_profile_fetch *profileData;
@property (assign, nonatomic) NSInteger gender;
@property (strong, nonatomic) city *filterCity;
@property (assign, nonatomic) BOOL isRefresh;
@property (assign, nonatomic) NSInteger userID;
@property (assign, nonatomic) NSInteger loadedItemIndex;
@property (strong, nonatomic) AwesomeMenu *circularMenu;
//@property (strong, nonatomic) FlowerMenuPostPopupViewController *flowerPopup;
@property (strong, nonatomic) NSMutableArray *listDraggableLocationTop;
@property (weak, nonatomic) NSMutableArray *cityList;
@property (strong, nonatomic) NSMutableDictionary* postsPerUserID;
@property (assign, nonatomic) BOOL showPopup;

- (void)loadDiscovery;
- (void)touchTitle;
- (void)giveFlowerProfile:(long long)flower;
- (void)giveFlowerPost:(long long)flower;
- (void) saveFilterOptions;
- (void)pullToRefresh;
- (void) removeAllowedDropLocationsInList:(NSMutableArray* )locations ;
- (void) addAllowedDropLocationsInList:(NSMutableArray* )locations;
@end
