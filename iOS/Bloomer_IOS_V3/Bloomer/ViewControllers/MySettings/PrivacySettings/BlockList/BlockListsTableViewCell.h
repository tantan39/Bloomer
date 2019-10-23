//
//  BlockListsTableViewCell.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/30/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API_BlockRemove.h"
#import "UserDefaultManager.h"
#import "BlockListsViewController.h"

@interface BlockListsTableViewCell : UITableViewCell <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *username;
- (IBAction)touchUnBlock:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *unBlockButton;
@property (assign, nonatomic) NSInteger uid;
@property (weak, nonatomic) UIViewController *parentView;

@end
