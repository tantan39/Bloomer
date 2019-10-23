//
//  FlowerGiverViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/27/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API_Post_FollowerFetches.h"
#import "UserDefaultManager.h"
#import "UIImageView+AFNetworking.h"
#import "API_Notification_ListUser.h"

@interface FlowerGiverViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString *post_id;
@property (assign, nonatomic) NSInteger userID;
@property (weak, nonatomic) NSString *notificationKey;

@end
