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

typedef NS_ENUM(NSUInteger, TypeRelation) {
    RECENTLY,
    BYFLOWER,
};

@interface FlowerRelationViewController : UIViewController< UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate, UISearchControllerDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UITableView *recentlytableView;
@property (weak, nonatomic) IBOutlet UITableView *searchResultTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchResultTableViewBottomMargin;
@property (weak, nonatomic) IBOutlet UILabel *labelNoResult;
@property (weak, nonatomic) IBOutlet UITableView *byFlowersTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *animationLineLeadingConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *searchController;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeightConstraintTableResult;

@property (assign, nonatomic) BOOL isFollower;
@property (assign, nonatomic) NSInteger tabIndex;

- (IBAction)segmentControlValueChanged:(id)sender;

@end
