//
//  ContactListTableViewCell.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 2/25/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfileViewController.h"

@interface ContactListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *flower;
@property (assign, nonatomic) NSInteger uid;
//@property (assign, nonatomic) BOOL isChat;
@property (weak, nonatomic) UINavigationController *navigationController;
- (IBAction)touchAvatar:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;

@end
