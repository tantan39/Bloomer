//
//  FlowerRelationCell.h
//  Bloomer
//
//  Created by Steven on 3/1/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "follower.h"
#import "API_Follow.h"

@interface FlowerRelationCell : UITableViewCell<UIAlertViewDelegate>

// MARK: - Static variables
+ (CGFloat) cellHeight;
+ (NSString*) cellIdentifier;
+ (NSString*) nibName;

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelUsername;
@property (weak, nonatomic) IBOutlet UILabel *labelFlower;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UIButton *buttonChat;
@property (weak, nonatomic) IBOutlet UIButton *buttonFollow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonFollowWidth;

@property (weak, nonatomic) UINavigationController *navigationController;
@property (weak, nonatomic) follower *data;

- (IBAction)touchButtonChat:(id)sender;
- (IBAction)touchButtonFollow:(id)sender;

- (void)switchStateForButtonFollow:(BOOL)isFollow;

@end
