//
//  InputPasswordViewController.h
//  Bloomer
//
//  Created by Phan Van Thanh Dat on 10/16/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "account_forget_changepass.h"
#import "API_Account_ForgetChangePass.h"
#import "UserDefaultManager.h"
#import "TextFieldValidator.h"
#import "API_Auth_FBAuthentication.h"
#import "MFTextField.h"

@interface InputPasswordViewController : UIViewController< UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet MFTextField *password;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (assign, nonatomic) NSInteger f_id;
@property (weak, nonatomic) IBOutlet UIButton *btnShowHidePass;
@property (strong,nonatomic) NSString * phoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;

- (IBAction)touchDoneButton:(id)sender;
- (IBAction)touchBackground:(id)sender;
- (IBAction)touchBackButton:(id)sender;

@end
