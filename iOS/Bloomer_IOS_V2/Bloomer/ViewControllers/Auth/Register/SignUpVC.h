//
//  InputPhoneVC.h
//  Bloomer
//
//  Created by Tran Thai Tan on 11/28/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "UserDefaultManager.h"
#import "API_Auth_RegisterInfo.h"
#import "ConfirmationViewController.h"
#import "EnterPasswordViewController.h"
#import "CountryPickerView.h"
#import "API_Auth_CheckPassword.h"
#import "UIButton+Extension.h"
#import "BLSwitchControl.h"
#import "MFTextField.h"
#import "ActiveSubstringTextView.h"

@interface SignUpVC : UIViewController<CountryPickerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet MFTextField *tfPhoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UILabel *lblCountryCode;
@property (weak, nonatomic) IBOutlet BLSwitchControl *genderSwitchControl;
@property (weak, nonatomic) IBOutlet MFTextField *tfName;
@property (weak, nonatomic) IBOutlet MFTextField *tfEmail;
@property (weak, nonatomic) IBOutlet MFTextField *tfPassword;
@property (weak, nonatomic) IBOutlet ActiveSubstringTextView *tvPolicyAndTerms;
@property (weak, nonatomic) IBOutlet UILabel *labelPolicyAndTerms;
@property (weak, nonatomic) IBOutlet UIButton *btnShowPassword;


@end
