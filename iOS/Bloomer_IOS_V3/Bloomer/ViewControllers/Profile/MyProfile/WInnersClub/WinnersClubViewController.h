//
//  WinnersClubViewController.h
//  Bloomer
//
//  Created by Ahri on 10/12/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Extension.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "SEDraggable.h"
#import "SEDraggableLocation.h"
#import "AwesomeMenu.h"
#import "FlowerMenuPostPopupViewController.h"
#import "UserDefaultManager.h"
#import "WinnersClubTableViewCell.h"
#import "WinnersClubSearchTableViewCell.h"
#import "API_WinnersClub.h"
#import "API_WinnersClubSearch.h"
#import "WeakLinkObj.h"
#import "UIShadeView.h"
#import "PopupForGSB.h"
#import "UISearchBar+Extension.h"

enum {
    GSBBronze = 1,
    GSBSilver = 7,
    GSBGold = 28
};
typedef NSUInteger GSBType;

@interface WinnersClubViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *notFoundLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomSpace;
@property (weak, nonatomic) IBOutlet UITableView *searchResultTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchResultTableViewBottomMargin;

// API properties
@property (assign, nonatomic) GSBType gsbType;
@property (assign, nonatomic) NSInteger gender;

@end
