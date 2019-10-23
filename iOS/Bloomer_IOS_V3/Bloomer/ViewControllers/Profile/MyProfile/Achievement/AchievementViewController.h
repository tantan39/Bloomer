//
//  AchievementViewController.h
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 3/22/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ProfileAchievementsListTableViewCell.h"
#import "achievementObject.h"
#import "API_GetCloseAchievement.h"
#import "API_GetActiveAchievement.h"
#import "UserDefaultManager.h"
#import "Support.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"

typedef enum {
    RaceResultCell = 0,
    ActiveRaceWithFlowerCell,
    ActiveRaceCell,
    ClosedRaceCell
} AchievementCellType;

@interface AchievementViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *emptyDataImageView;
@property (weak, nonatomic) IBOutlet UILabel *emptyDataText;

@property (strong, nonatomic) NSMutableArray* achievementsData;
@property (assign, nonatomic) BOOL activeRaces;
@property (assign, nonatomic) NSInteger uid;

- (void)loadAchievements;

@end
