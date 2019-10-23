//
//  NewsFeedSearchCustomView.h
//  Bloomer
//
//  Created by Tan Tan on 1/3/19.
//  Copyright © 2019 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchNewFeedTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewsFeedSearchCustomView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
