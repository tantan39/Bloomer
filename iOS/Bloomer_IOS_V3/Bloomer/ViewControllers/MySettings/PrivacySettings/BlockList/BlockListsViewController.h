//
//  BlockListsViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/30/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlockListsTableViewCell.h"
#import "API_BlockLists_Fetches.h"
#import "UserDefaultManager.h"
#import "UIImageView+AFNetworking.h"

@interface BlockListsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (void)loadBlocker;
@end
