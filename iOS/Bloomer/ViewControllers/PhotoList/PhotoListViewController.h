//
//  PhotoListViewController.h
//  Bloomer
//
//  Created by Steven on 3/12/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AwesomeMenu.h"
#import "SEDraggable.h"
#import "SEDraggableLocation.h"
#import "API_Flower_GivePost.h"
#import "API_Content_Post_Fetches.h"
#import "API_UserRacePosts.h"
#import "API_Follow.h"
#import "API_GetFeed.h"

@interface PhotoListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, SEDraggableLocationEventResponder, SEDraggableEventResponder, AwesomeMenuDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *postsData;
@property (strong, nonatomic) NSIndexPath *currentIndexPath;
@property (weak, nonatomic) NSMutableArray *postIDs;
@property (weak, nonatomic) NSString *raceName;
@property (strong, nonatomic) NSString *raceKey;
@property (assign, nonatomic) NSInteger uid;
@property (weak, nonatomic) UIViewController *parentView;
@property (weak, nonatomic) IBOutlet UIView *topInfoCloseView;
@property (weak, nonatomic) IBOutlet UILabel *titleForCloseLeaderboard;
@property (assign, nonatomic) NSInteger status;
@property (strong,nonatomic) NSString *feed_id;

-(void) changeDataAfterEdit:(NSString*) title index:(NSInteger) index;
- (void)giveFlowerPost:(long long)flower postID:(NSString*)postID receiverID:(NSInteger)receiverID;
-(void)touchUnFollow;
-(void)pullToRefresh;
@end
