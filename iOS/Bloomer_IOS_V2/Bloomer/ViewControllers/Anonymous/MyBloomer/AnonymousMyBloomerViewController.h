//
//  AnonymousMyBloomerViewController.h
//  Bloomer
//
//  Created by Steven on 5/4/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarView.h"
#import "FriendsUpdatesRaceTableViewCell.h"
#import "feed_list.h"
#import "feed_winner.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "UILabel+Extension.h"
#import "API_Feeds.h"
#import "API_ClosedRaceFeed.h"

@interface AnonymousMyBloomerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) TabBarView *tabbar;
@property (weak, nonatomic) IBOutlet UITableView *updatesTableView;
@property (weak, nonatomic) IBOutlet UIView *emptyView;

@end
