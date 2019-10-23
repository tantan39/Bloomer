//
//  ResetPasswordViewController.h
//  Xinh
//
//  Created by Truong Thuan Tai on 12/8/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResetPasswordVerifyCodeViewController.h"
#import "account_forget_who.h"
#import "API_Account_ForgetWho.h"
#import "out_account_forget_who.h"
#import "ChooseRegionViewController.h"

@interface ResetPasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *countryButton;
@property (weak, nonatomic) IBOutlet UIView *phoneNumberView;

- (IBAction)backgroundTap:(id)sender;
- (IBAction)touchBackButton:(id)sender;
- (IBAction)touchDoneButton:(id)sender;
- (IBAction)touchRegionButton:(id)sender;
- (IBAction)editEmail:(id)sender;

@property (strong, nonatomic) NSString* countryCode;
@property (strong, nonatomic) NSString* countryShortName;
@end
