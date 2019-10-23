//
//  RemindInviteCode.h
//  Bloomer
//
//  Created by Tan Tan on 4/17/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedeemInviteCodeViewController.h"
#import "TabBarView.h"
@import Firebase;
@interface RemindInviteCode : UIViewController

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong,nonatomic) UINavigationController * navigationController;
@property (strong,nonatomic) TabBarView* tabbar;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;
@property (assign,nonatomic) long inviteFlowerNumb;
- (void)showInView:(UIView *)aView animated:(BOOL)animated;

@end
