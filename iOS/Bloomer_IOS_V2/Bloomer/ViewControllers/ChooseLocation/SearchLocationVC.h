//
//  SearchLocationVC.h
//  Bloomer
//
//  Created by Tran Thai Tan on 6/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface SearchLocationVC : UITableViewController

- (instancetype) initWithViewController:(id<UITableViewDataSource,UITableViewDelegate>) viewController;

- (void) reloadDataWithDataSource:(NSArray *) dataSource;
@end
