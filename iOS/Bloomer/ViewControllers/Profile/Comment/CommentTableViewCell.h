//
//  CommentTableViewCell.h
//  Xinh
//
//  Created by Truong Thuan Tai on 12/9/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfileViewController.h"
#import "UserDefaultManager.h"

@interface CommentTableViewCell : UITableViewCell

// MARK: - Static Variables

+ (CGFloat) cellHeight;
+ (NSString*) cellIdentifier;

// MARK: - Variables

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelUsername;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;

@property NSInteger uid;
@property (weak, nonatomic) UINavigationController *navigationController;

- (IBAction)touchAvatarButton:(id)sender;

@end
