//
//  ReportChatPopUpViewController.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 5/8/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "ReportChatPopUpViewController.h"
#import "ChatViewController.h"
//#import "ProfileViewController.h"

@interface ReportChatPopUpViewController ()
{
    UserDefaultManager *userDefaultManager;
}
@end

@implementation ReportChatPopUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
        userDefaultManager = [[UserDefaultManager alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.8];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)touchCancelButton:(id)sender {
    [self removeAnimate];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        block_add *params = [[block_add alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] uid:_uid];
        if (params) {
            API_BlockAdd * api = [[API_BlockAdd alloc] initWithParams:params];
            [api postRequest:^(BaseJSON * json, RestfulResponse * objStatus) {
                
                if (objStatus.status){
                    
                    [self removeAnimate];
                    ChatViewController *view = (ChatViewController*)_parentView;
//                    view.isBlock = TRUE;
                    view.blocker = [userDefaultManager getUserProfileData].uid;
                    [view checkBlockState];
                    
                    UIViewController* grandView = [_parentView.navigationController.viewControllers objectAtIndex:_parentView.navigationController.viewControllers.count - 2];
                    if ([grandView isKindOfClass:[UserProfileViewController class]])
                    {
                        //            UserProfileViewController* profile = (UserProfileViewController*)grandView;
                        //            [profile loadProfileUsingAPI];VL
                    }
                }else{
                    [AppHelper showMessageBox:nil message:objStatus.message];
                }
                
            } ErrorHandlure:^(NSError * error) {
                
            }];
        }
    }
}

- (IBAction)touchBlockButton:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"Are you sure you want to block this user?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    [alert dismissWithClickedButtonIndex:0 animated:TRUE];
    [alert show];
}

//- (void)getDataBlock_Add:(out_auth_register_verifycode *)data
//{
//    if ([data getStt])
//    {
//        [self removeAnimate];
//        ChatViewController *view = (ChatViewController*)_parentView;
//        view.isBlock = TRUE;
//        view.blocker = [userDefaultManager getUserProfileData].uid;
//        [view CheckBlockState];
//        
//        UIViewController* grandView = [_parentView.navigationController.viewControllers objectAtIndex:_parentView.navigationController.viewControllers.count - 2];
//        if ([grandView isKindOfClass:[UserProfileViewController class]])
//        {
////            UserProfileViewController* profile = (UserProfileViewController*)grandView;
////            [profile loadProfileUsingAPI];VL
//        }
//    }
//    else
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[data getTitle]
//                                                        message:[data getMegs]
//                                                       delegate:self
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
//    }
//}

@end
