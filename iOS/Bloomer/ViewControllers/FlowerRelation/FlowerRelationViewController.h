//
//  FlowerRelationViewController.h
//  Bloomer
//
//  Created by Steven on 3/1/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API_Profile_FollowingFetches.h"
#import "API_Profile_FollowerFetches.h"
#import "API_Profile_FollowerSearch.h"
#import "API_Profile_FollowingSearch.h"

@interface FlowerRelationViewController : UIViewController< UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *searchResultTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchResultTableViewBottomMargin;
@property (weak, nonatomic) IBOutlet UILabel *labelNoResult;

@property (assign, nonatomic) BOOL isFollower;
@property (assign, nonatomic) NSInteger tabIndex;

- (IBAction)segmentControlValueChanged:(id)sender;

@end
