//
//  ContactListViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 2/25/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactListTableViewCell.h"
#import "ContactListFollowingTableViewCell.h"
#import "API_Profile_FollowerFetches.h"
#import "API_Profile_FollowingFetches.h"
#import "API_Profile_FollowerSearch.h"
#import "API_Profile_FollowingSearch.h"
#import "UserDefaultManager.h"
#import "UIImageView+AFNetworking.h"

@interface ContactListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate,UISearchResultsUpdating>
@property (weak, nonatomic) IBOutlet UISegmentedControl *mySegment;
@property (nonatomic, strong) NSMutableArray *searchResult;
@property (strong, nonatomic) UISearchController *searchController;


- (IBAction)segment:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) BOOL isFollower;
@property (weak, nonatomic) UIViewController* parentView;
//- (void)loadFollowing;
-(void)updateFollowing:(BOOL)isFollow userID:(NSInteger)userID;
@end
