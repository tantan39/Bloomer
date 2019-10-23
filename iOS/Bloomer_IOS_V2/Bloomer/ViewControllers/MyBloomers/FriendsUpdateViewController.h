//
//  FriendsUpdateViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 2/16/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarView.h"
#import "FriendsUpdatesRaceTableViewCell.h"
#import "SEDraggable.h"
#import "SEDraggableLocation.h"
#import "AwesomeMenu.h"
#import "FlowerMenuPostPopupViewController.h"
#import "API_ClosedRaceFeed.h"
#import "API_Feeds.h"
#import "feed_list.h"
#import "feed_winner.h"
#import "UserDefaultManager.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "API_Flower_GivePost.h"
#import "API_Flower_GiveProfile.h"
#import "SinglePhotoCell.h"
#import "TwoPhotosCell.h"
#import "ThreePhotosCell.h"
#import "FourPhotosCell.h"
#import "FivePhotosCell.h"
#import "UILabel+Extension.h"
#import "SuggestedBloomerCell.h"

@interface FriendsUpdateViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, AwesomeMenuDelegate, SEDraggableEventResponder, SEDraggableLocationEventResponder, UIGestureRecognizerDelegate>

@property (weak, nonatomic) TabBarView *tabbar;
@property (weak, nonatomic) IBOutlet UITableView *updatesTableView;
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (strong, nonatomic) NSMutableArray *listDraggableLocationSingle;
@property (strong, nonatomic) NSMutableArray *listDraggableLocationTop;
@property (strong, nonatomic) NSMutableArray *listDraggableLocationPicture;
@property (strong, nonatomic) NSMutableArray *listDraggableLocationDouble;
@property (strong, nonatomic) AwesomeMenu *circularMenu;
@property (strong, nonatomic) out_profile_fetch *profileData;
@property (strong, nonatomic) ThankYou *thankyou;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

- (void)giveFlowerProfile:(long long)flower;
- (void)giveFlowerPost:(long long)flower;

@end
