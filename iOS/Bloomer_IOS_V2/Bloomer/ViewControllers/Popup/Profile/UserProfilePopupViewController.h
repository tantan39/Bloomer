//
//  UserProfilePopupViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/20/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectionReasonReportViewController.h"

#import "API_Follow.h"
#import "UserDefaultManager.h"
#import "block_add.h"
#import "API_BlockAdd.h"

#import "UserProfileViewController.h"

@interface UserProfilePopupViewController : UIViewController

@property (assign, nonatomic) NSInteger uid;
@property (assign, nonatomic) long long gaveFlower;
@property (assign, nonatomic) BOOL isFollowing;
@property (assign, nonatomic) BOOL isBlock;

@property (weak, nonatomic) UIViewController *parentView;
@property (weak, nonatomic) UIViewController *destinationView;

@property (weak, nonatomic) IBOutlet UIButton *unFollowButton;
@property (weak, nonatomic) IBOutlet UIButton *blockUserButton;
@property (weak, nonatomic) IBOutlet UIButton *reportUserButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

- (void)showInView:(UIView *)aView animated:(BOOL)animated;

- (IBAction)touchUnFollow:(id)sender;
- (IBAction)touchBlockUser:(id)sender;
- (IBAction)touchReportUser:(id)sender;
- (IBAction)touchCancel:(id)sender;

@end
