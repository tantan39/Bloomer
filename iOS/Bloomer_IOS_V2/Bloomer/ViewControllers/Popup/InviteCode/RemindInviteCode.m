//
//  RemindInviteCode.m
//  Bloomer
//
//  Created by Tan Tan on 4/17/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "RemindInviteCode.h"

@interface RemindInviteCode (){
    UserDefaultManager *userDefaultManager;
}

@end

@implementation RemindInviteCode

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupUI];
    userDefaultManager = [[UserDefaultManager alloc] init];
}

- (void) setupUI{
    self.contentView.layer.cornerRadius = 20;
    self.contentView.clipsToBounds = YES;
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.btnSubmit.layer.cornerRadius = self.btnSubmit.bounds.size.height/2;
    self.btnSubmit.clipsToBounds = YES;
    self.btnCancel.layer.cornerRadius = self.btnSubmit.bounds.size.height/2;
    self.btnCancel.clipsToBounds = YES;
    self.labelContent.text = [NSString stringWithFormat:NSLocalizedString(@"RemindInviteCode.content", nil),self.inviteFlowerNumb,self.inviteFlowerNumb];
    self.labelContent.hidden = self.inviteFlowerNumb > 0 ? NO : YES;
}

- (IBAction)btnSubmit_Pressed:(id)sender {
    [self removeAnimate];
    if (self.navigationController) {
        for (UIView *view in [[[UIApplication sharedApplication] delegate] window].subviews) {
            if ([view isKindOfClass:[TabBarView class]]){
                _tabbar = (TabBarView*)view;
                break;
            }
        }
        if (_tabbar) {
            [_tabbar snapbackFlowerIconToTabbar];
        }
        
        RedeemInviteCodeViewController *view = [[RedeemInviteCodeViewController alloc] initWithNibName:@"RedeemInviteCodeViewController" bundle:nil];
        view.hidesBottomBarWhenPushed = YES;
        [view setRedeemmInviteCodeFailure:^{
            [self showInView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        }];
        [self.navigationController pushViewController:view animated:YES];
    }
}

- (IBAction)btnCancel_Pressed:(id)sender {
    [self removeAnimate];
    out_profile_fetch * profile = [userDefaultManager getUserProfileData];
    
    [FIRAnalytics logEventWithName:@"cancle_popup_invitecode" parameters:@{@"uid": [NSNumber numberWithInteger:profile.uid],
                                                                           @"name": profile.username
                                                                           }];
}

- (void)showInView:(UIView *)aView animated:(BOOL)animated{
    self.view.frame = aView.bounds;
    dispatch_async(dispatch_get_main_queue(), ^{
        [aView addSubview:self.view];
        if (animated) {
            [self showAnimate];
        }
    });
}

- (void)removeAnimate{
    [UIView animateWithDuration:.4 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1, 1);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
}

- (void)showAnimate{
    self.view.transform = CGAffineTransformMakeScale(1, 1);
    self.view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
}
@end
