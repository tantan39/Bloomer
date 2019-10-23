//
//  UserProfilePopupViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/20/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "UserProfilePopupViewController.h"

@interface UserProfilePopupViewController () {
    SelectionReasonReportViewController *popup;
    UserDefaultManager *userDefaultManager;
}

@end

@implementation UserProfilePopupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
    
    _unFollowButton.layer.cornerRadius = 20;
    _blockUserButton.layer.cornerRadius = 20;
    _reportUserButton.layer.cornerRadius = 20;
    _cancelButton.layer.cornerRadius = 20;
    
    [_cancelButton setTitle:NSLocalizedString(@"InfoUserCancelButton.title", ) forState:UIControlStateNormal];
    [_reportUserButton setTitle:NSLocalizedString(@"InfoUserReprot.title", ) forState:UIControlStateNormal];
    [_blockUserButton setTitle:NSLocalizedString(@"InfoUserBlock.title", ) forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(removeAnimate)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_isFollowing) {
        [_unFollowButton setTitle:NSLocalizedString(@"InfoUserUnfollow.title",) forState:UIControlStateNormal];
    } else {
        [_unFollowButton setTitle:NSLocalizedString(@"InfoUserFollow.title",) forState:UIControlStateNormal];
    }
    [_unFollowButton setHidden:_gaveFlower == 0];
    
    if (_isBlock) {
        [_blockUserButton setHidden:YES];
    }
}

- (void)showAnimate
{
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
}

- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [aView addSubview:self.view];
        if (animated) {
            [self showAnimate];
        }
    });
}

- (IBAction)touchUnFollow:(id)sender {
    void(^yesAction)(UIAlertAction * _Nonnull action) = nil;
    NSString *message = @"";
    
    if (self.isFollowing) {
        message = [AppHelper getLocalizedString:@"Popup.UnFollowDescript"];
        yesAction = ^(UIAlertAction * _Nonnull action) {
            [self invokeUnfollowAPI];
        };
    } else {
        message = [AppHelper getLocalizedString:@"Are you sure you want to follow this user?"];
        yesAction = ^(UIAlertAction * _Nonnull action) {
            [self invokeRefollowAPI];
        };
    }
    
    UIAlertController *unFollowAlert = [UIAlertController alertControllerWithTitle:nil
                                                                           message:message
                                                                    preferredStyle:UIAlertControllerStyleAlert];
    [unFollowAlert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"No",)
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                    }]];
    [unFollowAlert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Yes",)
                                                      style:UIAlertActionStyleDefault
                                                    handler:yesAction]];
    [self presentViewController:unFollowAlert animated:true completion:nil];
}

- (IBAction)touchBlockUser:(id)sender {
    UIAlertController *unFollowAlert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Are you sure you want to block this user?",)
                                                                           message:@""
                                                                    preferredStyle:UIAlertControllerStyleAlert];
    [unFollowAlert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"No",)
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                    }]];
    [unFollowAlert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Yes",)
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        [self invokeBlockAPI];
                                                    }]];
    [self presentViewController:unFollowAlert animated:true completion:nil];
}

- (IBAction)touchReportUser:(id)sender {
    [self removeAnimate];
    
    popup = [[SelectionReasonReportViewController alloc] initWithNibName:@"SelectionReasonReportViewController" bundle:nil];
    popup.uid = _uid;
    popup.isUser = TRUE;
    
    popup.view.frame = [UIScreen mainScreen].bounds; // Get device's bounds
    [popup showInView:[[[UIApplication sharedApplication] delegate] window] animated:TRUE];
}

- (IBAction)touchCancel:(id)sender {
    [self removeAnimate];
}

- (void)showConfirmPopup:(NSString *)title {
    UIAlertController *unFollowAlert = [UIAlertController alertControllerWithTitle:title
                                                                           message:@""
                                                                    preferredStyle:UIAlertControllerStyleAlert];
    [unFollowAlert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK",)
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        [self removeAnimate];
                                                    }]];
    [self presentViewController:unFollowAlert animated:true completion:nil];
}

- (void)invokeUnfollowAPI {
    block_remove *param = [[block_remove alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                       device_token:[userDefaultManager getDeviceToken]
                                                                uid:_uid];
    if (param) {
        API_UnFollow *api = [[API_UnFollow alloc] initWithParams:param];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            if (response.status)
            {
                if (self.parentView != nil) {
                    UserProfileViewController *parent = (UserProfileViewController *)self.parentView;
                    [parent loadProfileUsingAPI];
                }
                
                [self showConfirmPopup:NSLocalizedString(@"InfoUsersSuccessFollow.title",)];
            } else {
                [AppHelper showMessageBox:nil message:response.message];
            }
        } ErrorHandlure:^(NSError *error) {
            
        }];
    }
}

- (void)invokeRefollowAPI {
    block_remove *param = [[block_remove alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                       device_token:[userDefaultManager getDeviceToken]
                                                                uid:_uid];
    if (param) {
        API_ReFollow *api = [[API_ReFollow alloc] initWithParams:param];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            if (response.status) {
                if (self.parentView != nil) {
                    UserProfileViewController *parent = (UserProfileViewController*)_parentView;
                    [parent loadProfileUsingAPI];
                }
                
                [self showConfirmPopup:NSLocalizedString(@"InfoUsersSuccessFollow.title",)];
            }
            else
            {
                [AppHelper showMessageBox:nil message:response.message];
            }
        } ErrorHandlure:^(NSError *error) {
            
        }];
    }
}

- (void)invokeBlockAPI {
    block_add *params = [[block_add alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                  device_token:[userDefaultManager getDeviceToken]
                                                           uid:_uid];

    API_BlockAdd *api = [[API_BlockAdd alloc] initWithParams:params];
    [api postRequest:^(BaseJSON *json, RestfulResponse *objStatus) {
        [self removeAnimate];
        
        if (objStatus.status) {
            if (self.parentView != nil) {
                UserProfileViewController *parent = (UserProfileViewController *)self.parentView;
//                [userDefaultManager setReloadDiscovery:TRUE];
                [NotificationHelper postNotificationWhenLockProfile: self.uid];
                UIViewController * root = [[parent.navigationController viewControllers] firstObject];
                if ([root isKindOfClass: FriendsUpdateViewController.class] || [root isKindOfClass: DiscoveryViewController.class]) {
                    [parent.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    [parent.navigationController popViewControllerAnimated:YES];
                }
            }
        } else {
            [AppHelper showMessageBox:nil message:objStatus.message];
        }
    } ErrorHandlure:^(NSError *error) {
        
    }];
}

- (void)getDataProfile_Follow:(out_name_update *)data {
//    [self removeAnimate];
}

@end
