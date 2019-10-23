//
//  ConfirmationViewController.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/8/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API_Auth_RegisterSendCode.h"
#import "API_Auth_RegisterCallSupport.h"
#import "API_Auth_RegisterVerifyCode.h"
#import "sendcode.h"
#import "verifycode.h"
#import "out_auth_register_verifycode.h"
#import "out_auth_register_sendcode.h"
#import "UserDefaultManager.h"
#import "ChooseGenderSignUpViewController.h"
#import "TermAndPolicyViewController.h"
#import "UpdateSignUpViewController.h"
#import "API_MobileVerify.h"
#import "AccountSettingViewController.h"
#import "UnderlineButton.h"

@interface ConfirmationViewController : UIViewController < UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *enterButton;
@property (weak, nonatomic) IBOutlet UIButton *resendButton;
@property (weak, nonatomic) IBOutlet UILabel *directionLabel;
@property (assign, nonatomic) NSInteger m_id;
@property (weak, nonatomic) IBOutlet UILabel *agreeLabel;
@property (weak, nonatomic) IBOutlet UIView *greentDots;
@property (weak, nonatomic) IBOutlet UILabel *lblError;
@property (weak, nonatomic) IBOutlet UILabel *lblPhoneNumber;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *imgdotList;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lblCodeList;

@property (weak, nonatomic) IBOutlet UnderlineButton *btnFreeCall;
@property (weak, nonatomic) IBOutlet UnderlineButton *btnFreeSMS;


@property (assign, nonatomic) NSInteger gender;
@property (assign, nonatomic) NSInteger country_id;
//@property (assign, nonatomic) NSString* phoneNumber;
@property (assign, nonatomic) BOOL isMobileVerify;
@property (weak, nonatomic) NSString* verifyCode;

- (IBAction)touchBackButton:(id)sender;
- (IBAction)touchEnterButton:(id)sender;

- (IBAction)touchBackground:(id)sender;

- (IBAction)touchCodeField:(id)sender;

- (IBAction)changeCodeField:(id)sender;

- (void)setPhoneNumber:(NSString *)phoneNumber;
- (void)setVerifyCodeNumber:(NSString*)code;
@end
