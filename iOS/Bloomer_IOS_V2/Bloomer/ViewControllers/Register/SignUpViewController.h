//
//  SignUpViewController.h
//  Xinh
//
//  Created by Truong Thuan Tai on 11/19/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import "LoginViewController.h"
#import "UserDefaultManager.h"
#import "UpdateSignUpViewController.h"
//#import "auth_register_sendcode_using.h"
#import "sendcode.h"
#import "out_auth_register_sendcode.h"
#import "ConfirmationViewController.h"
#import "ChooseRegionViewController.h"
#import "TextFieldValidator.h"
#import "API_Auth_RegisterSendCode.h"

@interface SignUpViewController : UIViewController

@property (weak, nonatomic) IBOutlet TextFieldValidator *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UILabel *setupAccountLabel;
@property (weak, nonatomic) IBOutlet UIButton *countryButton;
@property (weak, nonatomic) IBOutlet UIButton *showHidePasswordButton;
//@property (weak, nonatomic) IBOutlet UIView *maleView;
//@property (weak, nonatomic) IBOutlet UIView *femaleView;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
//@property (weak, nonatomic) IBOutlet UIImageView *malePicture;
//@property (weak, nonatomic) IBOutlet UIImageView *femalePicture;
@property (weak, nonatomic) IBOutlet UIButton *backButton;


//- (IBAction)editPhoneNumber:(id)sender;
//- (IBAction)touchPhoneNumber:(id)sender;
//- (IBAction)touchPassword:(id)sender;
- (IBAction)didChangePhoneNumber:(id)sender;
- (IBAction)didChangePassword:(id)sender;
- (IBAction)TouchBack:(id)sender;

- (IBAction)backgroundTap:(id)sender;
- (IBAction)touchLoginHyperlink:(id)sender;
- (IBAction)touchSignUpButton:(id)sender;
- (IBAction)touchShowHidePasswordButton:(id)sender;
@property (strong, nonatomic) NSString* countryCode;
@property (strong, nonatomic) NSString* countryShortName;

@end
