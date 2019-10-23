//
//  ContactListFollowingTableViewCell.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 2/25/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API_Follow.h"
#import "UserDefaultManager.h"
#import "ContactListViewController.h"

@interface ContactListFollowingTableViewCell : UITableViewCell < UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *flower;
@property (weak, nonatomic) IBOutlet UIButton *unFollowerButton;
@property (weak, nonatomic) IBOutlet UIButton *followerButton;
@property (assign, nonatomic) NSInteger uid;
@property (assign, nonatomic) NSInteger userID;
//@property (assign, nonatomic) BOOL isChat;
@property (weak, nonatomic) UINavigationController *navigationController;
@property (weak, nonatomic) UIViewController *parentView;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
- (IBAction)touchUnFollow:(id)sender;
- (IBAction)touchAvatar:(id)sender;

@end
