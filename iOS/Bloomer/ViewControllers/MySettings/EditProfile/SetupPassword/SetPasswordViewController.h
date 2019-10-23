//
//  SetPasswordViewController.h
//  Bloomer
//
//  Created by Thanh Tu Nguyen on 3/6/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarView.h"
#import "UserDefaultManager.h"
#import "UITextField+Extension.h"
#import "UIColor+Extension.h"
#import "AppHelper.h"
#import "API_Set_Password.h"
#import "API_Auth_Logout.h"
#import "InviteCodeViewController.h"
#import "AccountSettingViewController.h"


@interface SetPasswordViewController : UIViewController <FBSDKAppInviteDialogDelegate,UIAlertViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblSetupPass;
@property (weak, nonatomic) IBOutlet UILabel *lblComfirmPass;

@property (weak, nonatomic) IBOutlet UITextField *passwordNew;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;

- (IBAction)reviewPass:(id)sender;
- (IBAction)reviewComfirmPass:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *confirmPassButton;
@property (weak, nonatomic) IBOutlet UIButton *reviewpassButton;

@property (assign, nonatomic) BOOL isLogOut;

@end
