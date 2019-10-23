//
//  VerifyUpdatePhoneNumberViewController.m
//  Bloomer
//
//  Created by Steven on 3/8/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "VerifyUpdatePhoneNumberViewController.h"
#import "AppHelper.h"
#import "API_Auth_ResendCode.h"
#import "BloomerManager.h"
#import "API_MobileVerify.h"
#import "UserDefaultManager.h"
#import "Spinner.h"
#import "AppDelegate.h"
#import "UIButton+Extension.h"
#import "NotificationHelper.h"

@interface VerifyUpdatePhoneNumberViewController ()

@property (assign, nonatomic) NSInteger iCallSupportCount;
@property (strong, nonatomic) UserDefaultManager *userDefaultManager;
@property (strong, nonatomic) Spinner *spinner;

@end

@implementation VerifyUpdatePhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.userDefaultManager = [[UserDefaultManager alloc] init];
    self.spinner = ((AppDelegate *)[UIApplication sharedApplication].delegate).spinner;
    
    self.completeButton.layer.cornerRadius = self.completeButton.frame.size.height / 2;
    self.completeButton.clipsToBounds = true;
    
    self.waitLabel.text = @"";
    [self.completeButton setStatusEnable:false];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupLanguage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    if ([self isMovingFromParentViewController])
    {
        // Pop
        [AppHelper changeNavigationBarToRed:self.navigationController];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.verifyCodeTextField becomeFirstResponder];
}

- (void)setupLanguage
{
    self.titleLabel.text = [AppHelper getLocalizedString:@"VerifyUpdatePhoneNumber.title"];
    [self.resendCodeButton setTitle:[AppHelper getLocalizedString:@"VerifyUpdatePhoneNumber.resendButton"] forState:UIControlStateNormal];
    [self.getAudioCodeButton setTitle:[AppHelper getLocalizedString:@"VerifyUpdatePhoneNumber.audioCodeButton"] forState:UIControlStateNormal];
    [self.completeButton setTitle:[AppHelper getLocalizedString:@"VerifyUpdatePhoneNumber.completButton"] forState:UIControlStateNormal];
//    self.waitLabel.text = [AppHelper getLocalizedString:@"Please wait up for 1 min"];
}

- (void)setVerifyCodeNumber:(NSString*)verifyCodeNumber
{
    self.verifyCodeTextField.text = verifyCodeNumber;
    [self.verifyCodeTextField sendActionsForControlEvents:UIControlEventEditingChanged];
}

// MARK: - Actions

- (IBAction)touchBackground:(id)sender {
    [self.view endEditing:true];
}

- (IBAction)verifyCodeTextFieldEditingChanged:(id)sender
{
    for (NSInteger i = 0; i < 4; i++)
    {
        UILabel *label = (UILabel*)self.codeLabels[i];
        
        if (i < self.verifyCodeTextField.text.length)
        {
            NSString *character = [NSString stringWithFormat:@"%c", [self.verifyCodeTextField.text characterAtIndex:i]];
            label.text = character;
        }
        else
        {
            label.text = @"";
        }
    }
    
    if(self.verifyCodeTextField.text.length == 4) {
        [self touchCompleteButton:nil];
    }
}

- (IBAction)touchResendCodeButton:(id)sender
{
    [self.resendCodeButton setStatusEnable:NO WithButtonType:GETVERIFYCODE_BUTTON];
    [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(enableResendCodeButton) userInfo:nil repeats:false];
    self.waitLabel.text = [AppHelper getLocalizedString:@"Please wait up for 1 min"];
    
    resendcode *parameters = [[resendcode alloc] initWithPhoneNumb:self.phoneNumber CountryID:[[BloomerManager shareInstance] countryID] Voice:NO];
    if (parameters)
    {
        API_Auth_ResendCode *api = [[API_Auth_ResendCode alloc] initWithParamsForUpdate:parameters];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            if (response.status)
            {
            }
            else
            {
                [AppHelper showMessageBox:nil message:response.message];
            }
        } ErrorHandlure:^(NSError *error) {
            [self.resendCodeButton setStatusEnable:YES WithButtonType:GETVERIFYCODE_BUTTON];
//            self.getAudioCodeButton.enabled = true;
        }];
    }
}

- (IBAction)touchGetAudioCodeButton:(id)sender
{
    [self.getAudioCodeButton setStatusEnable:NO WithButtonType:GETVERIFYCODE_BUTTON];
    [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(enableGetAudioCodeButton) userInfo:nil repeats:false];
    self.waitLabel.text = [AppHelper getLocalizedString:@"Please wait up for 15s"];

    resendcode *parameters = [[resendcode alloc] initWithPhoneNumb:self.phoneNumber CountryID:[[BloomerManager shareInstance] countryID] Voice:YES];
    if (parameters)
    {
        API_Auth_ResendCode *api = [[API_Auth_ResendCode alloc] initWithParamsForUpdate:parameters];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            if (response.status)
            {
                self.iCallSupportCount += 1;
            }
            else
            {
                [AppHelper showMessageBox:nil message:response.message];
            }
        } ErrorHandlure:^(NSError *error) {
            [self.getAudioCodeButton setStatusEnable:YES WithButtonType:GETVERIFYCODE_BUTTON];
        }];
    }
}

- (IBAction)touchCompleteButton:(id)sender
{
    NSString *code = self.verifyCodeTextField.text;
    
    if (code.length == 4)
    {
        NSInteger uid = [self.userDefaultManager getUserProfileData].uid;
        NSString *secretClient = [self.userDefaultManager generateSecretClient];
        NSString *credential = [NSString stringWithFormat:@"%@", code];
        NSString *encryptedSecretClient = [self.userDefaultManager encryptDESByKey:[self.userDefaultManager getAppKey] data:secretClient iv:[self.userDefaultManager getAppSecret]];
        NSString *encryptedCridential = [self.userDefaultManager encryptDESByKey:[self.userDefaultManager getAppKey] data:credential iv:secretClient];
        
        __weak VerifyUpdatePhoneNumberViewController *weakSelf = self;
        mobile_verify *parameters = [[mobile_verify alloc] initWithAccess_Token:[self.userDefaultManager getAccessToken] device_token:[self.userDefaultManager getDeviceToken] code:code uid:@(uid).stringValue secret_client:encryptedSecretClient credential:encryptedCridential];
        API_MobileVerify *api = [[API_MobileVerify alloc] initWithParams:parameters];
        [self.spinner startAnimating];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            if (response.status)
            {
                if(!_linkWithExistedPhone) {
                    [weakSelf.userDefaultManager getUserProfileData].mobile = weakSelf.phoneNumber;
                    [NotificationHelper postNotificationUpdateNumberPhone];
                    [weakSelf.navigationController popToRootViewControllerAnimated:true];
                } else {
                    [weakSelf Logout];
                }
            }
            else
            {
                [AppHelper showMessageBox:nil message:response.message];
            }
            
            [weakSelf.spinner stopAnimating];
        } ErrorHandlure:^(NSError *error) {
            [weakSelf.spinner stopAnimating];
        }];
    }
    else
    {
        [AppHelper showMessageBox:[AppHelper getLocalizedString:@"common.error"] message:[AppHelper getLocalizedString:@"VerifyUpdatePhoneNumber.verifyCodeError"]];
    }
}

-(void) Logout
{
    UserDefaultManager* userDefaultManager = [[UserDefaultManager alloc] init];
    Spinner* spinner = ((AppDelegate*)[UIApplication sharedApplication].delegate).spinner;
    [spinner startAnimating];
    API_Auth_Logout * api = [[API_Auth_Logout alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken]];
    [api getRequest:^(BaseJSON *json, RestfulResponse *data) {
        if (data.status) {
            if([FBSDKAccessToken currentAccessToken]) {
                FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
                [loginManager logOut];
            }
            [userDefaultManager removeAccessToken];
            [userDefaultManager removeUserProfileData];
            [userDefaultManager removeCredentialEjab];
            [userDefaultManager removeAuthSession];
            [userDefaultManager removeIsUpdateInformation];
            [userDefaultManager removeRefresh_Token];
            [userDefaultManager saveTransactionID:@""];
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//            [appDelegate.pullNotificationAPI cancelCurrentRequest];
//            [appDelegate.pullAPITimer invalidate];
//            appDelegate.pullAPITimer = nil;
            [appDelegate.badgeNumber removeFromSuperview];
            [appDelegate.chatBadgeNumber removeFromSuperview];
            UINavigationController *navController = (UINavigationController *)UIApplication.sharedApplication.keyWindow.rootViewController;
            SelectScreenViewController *selectScreenViewController = [[SelectScreenViewController alloc] initWithNibName:@"SelectScreenViewController" bundle:nil];
            [navController popToRootViewControllerAnimated:false];
            [navController pushViewController:selectScreenViewController animated:true];
        }
        [spinner stopAnimating];
    } ErrorHandlure:^(NSError * error) {
        [spinner stopAnimating];
    }];
}

// MARK: - Selectors
- (void)enableResendCodeButton
{
    [self.resendCodeButton setStatusEnable:YES WithButtonType:GETVERIFYCODE_BUTTON];
    
    self.waitLabel.text = @"";
}

- (void)enableGetAudioCodeButton
{
    if (self.iCallSupportCount < 2)
    {
        [self.getAudioCodeButton setStatusEnable:YES WithButtonType:GETVERIFYCODE_BUTTON];
    }
    
    self.waitLabel.text = @"";
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    CGSize keyboardSize = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSTimeInterval time = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions option = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedLongValue];
    
    self.mainViewCenterY.constant = -1 * (UIScreen.mainScreen.bounds.size.height/2 - keyboardSize.height);
    [self.mainView setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:time delay:0 options:option animations:^{
        [self.mainView layoutIfNeeded];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    self.mainViewCenterY.constant = 0;
    
    NSTimeInterval time = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions option = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedLongValue];
    
    [UIView animateWithDuration:time delay:0 options:option animations:^{
        [self.mainView layoutIfNeeded];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

// MARK: - TextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    if (newLength == 4)
    {
        [self.completeButton setStatusEnable:true];
    }
    else
    {
        [self.completeButton setStatusEnable:false];
    }
    
    return newLength <= 4;
}

@end
