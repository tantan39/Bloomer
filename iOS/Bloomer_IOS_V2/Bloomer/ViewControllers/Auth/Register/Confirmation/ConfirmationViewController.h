//
//  ConfirmationViewController.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/8/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API_Auth_ResendCode.h"
#import "API_Auth_RegisterCallSupport.h"
#import "API_Auth_RegisterVerifyCode.h"
#import "API_GetVerifyCode.h"

#import "verifycode.h"
#import "out_auth_register_verifycode.h"
#import "out_auth_register_sendcode.h"
#import "UserDefaultManager.h"
#import "TermAndPolicyViewController.h"
#import "CreatePasswordViewController.h"
#import "API_MobileVerify.h"
#import "AccountSettingViewController.h"
#import "UnderlineButton.h"

#import "API_Auth_Authorize.h"

@interface ConfirmationViewController : UIViewController < UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *enterButton;
@property (weak, nonatomic) IBOutlet UIButton *resendButton;
@property (weak, nonatomic) IBOutlet UILabel *directionLabel;
@property (assign, nonatomic) NSInteger m_id;
@property (weak, nonatomic) IBOutlet UILabel *agreeLabel;
@property (weak, nonatomic) IBOutlet UIView *greentDots;
@property (weak, nonatomic) IBOutlet UILabel *lblError;
@property (weak, nonatomic) IBOutlet UILabel *lblPhoneNumber;


@property (weak, nonatomic) IBOutlet UIButton *btnFreeCall;
@property (weak, nonatomic) IBOutlet UIButton *btnFreeSMS;


@property (assign, nonatomic) NSInteger gender;
@property (assign, nonatomic) NSInteger country_id;
//@property (assign, nonatomic) NSString* phoneNumber;
@property (assign, nonatomic) BOOL isMobileVerify;
@property (weak, nonatomic) NSString* verifyCode;
@property (strong,nonatomic) NSString * phoneNumber;

@property (nonatomic,assign) BOOL isSignUp;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lblCodeList;
@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UILabel *labelSupport;

- (IBAction)touchBackButton:(id)sender;
- (IBAction)touchEnterButton:(id)sender;

- (IBAction)touchBackground:(id)sender;

- (IBAction)touchCodeField:(id)sender;

- (IBAction)changeCodeField:(id)sender;

- (void)setPhoneNumber:(NSString *)phoneNumber;
- (void)setVerifyCodeNumber:(NSString*)code;
@end
