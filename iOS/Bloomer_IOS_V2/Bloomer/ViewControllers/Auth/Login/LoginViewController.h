//
//  LoginViewController.h
//  Bloomer
//
//  Created by Phan Van Thanh Dat on 10/16/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "UserDefaultManager.h"
#import "ConfirmationViewController.h"
#import "TextFieldValidator.h"
#import "EnterPasswordViewController.h"
#import "CountryPickerView.h"
#import "API_Auth_CheckPassword.h"
#import "UIButton+Extension.h"
#import "ActiveSubstringTextView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : UIViewController<CountryPickerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lBnewPassword;
@property (weak, nonatomic) IBOutlet UILabel *lBpolicy;

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet MFTextField *tfPhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblCountryCode;
@property (weak, nonatomic) IBOutlet UIButton *btnForgotPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnSignIn;
@property (weak, nonatomic) IBOutlet UIButton *btnSignInFB;
@property (weak, nonatomic) IBOutlet MFTextField *tfPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnShow;
@property (weak, nonatomic) IBOutlet UIView *viewParentBtnSignIn;
@property (weak, nonatomic) IBOutlet ActiveSubstringTextView *labelNewPassword;
@property (weak, nonatomic) IBOutlet ActiveSubstringTextView *labelPolicyAndTerms;

@end

NS_ASSUME_NONNULL_END
