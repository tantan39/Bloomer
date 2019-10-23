//
//  ChangePasswordViewController.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/9/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "account_forget_changepass.h"
#import "API_Account_ForgetChangePass.h"
#import "UserDefaultManager.h"
#import "API_Auth_FBAuthentication.h"

@interface ChangePasswordViewController : UIViewController< UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *password;

@property (assign, nonatomic) NSInteger f_id;
@property (weak, nonatomic) IBOutlet UIButton *btnShowHidePass;
@property (strong,nonatomic) NSString * phoneNumber;

@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (weak, nonatomic) IBOutlet UILabel *lblError;
- (IBAction)touchDoneButton:(id)sender;
- (IBAction)touchBackground:(id)sender;
- (IBAction)touchBackButton:(id)sender;

@end
