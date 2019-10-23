//
//  ResetPasswordVerifyCodeViewController.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/9/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChangePasswordViewController.h"
#import "account_forget_verifycode.h"
#import "API_Account_Forget_VerifyCode.h"
#import "out_account_forget_verifycode.h"
#import "out_account_forget_who.h"
#import "account_forget_who.h"
#import "API_Account_ForgetWho.h"
#import "API_Account_ForgetWho_VoiceCall.h"
#import "image_photo.h"
#import "UIImageView+AFNetworking.h"
#import "UIButton+Extension.h"
#import "UnderlineButton.h"
//#import "auth_register_callsupport_using.h"
//#import "auth_register_verifycode_using.h"


@interface ResetPasswordVerifyCodeViewController : UIViewController< UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (assign, nonatomic) NSInteger f_id;
@property (assign, nonatomic) NSInteger country_id;
@property (strong, nonatomic) NSString *phoneNumber;
@property (assign, nonatomic) NSInteger uid;
@property (weak, nonatomic) IBOutlet UIButton *verifyButton;
//@property (weak, nonatomic) IBOutlet UIView *greenDots;
@property (weak, nonatomic) IBOutlet UILabel *lblPhoneNumber;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *imgdotList;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lblCodeList;

@property (weak, nonatomic) IBOutlet UIButton *btnFreeCall;
@property (weak, nonatomic) IBOutlet UIButton *btnFreeSMS;

@property (weak, nonatomic) IBOutlet UILabel *lblMessage;

- (IBAction)touchBackButton:(id)sender;
- (IBAction)touchDoneButton:(id)sender;
- (IBAction)touchBackground:(id)sender;
//- (IBAction)didEndEdittingCodeField:(id)sender;
- (IBAction)didChangeEdittingCodeField:(id)sender;
//- (IBAction)touchCodeField:(id)sender;
- (void)setVerifyCodeNumber:(NSString*)code;


@end
