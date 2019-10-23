//
//  ChangesPasswordViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/27/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "ChangesPasswordViewController.h"
#import "AppHelper.h"

@interface ChangesPasswordViewController () {
    UserDefaultManager *userDefaultManager;
    UIColor * activeColor, * deActiveColor;
    
    BOOL isShowCurrentPass, isShowNewPass, isShowConfirmPass;

    UIImage * imgShowPass, * imgHidePass;
    UIBarButtonItem *doneButton;
    
}

@end

@implementation ChangesPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    userDefaultManager = [[UserDefaultManager alloc] init];
    [self initNavigationBar];
    
//     [_passwordNew addRegx:@"[A-Za-z0-9]{6,20}" withMsg:NSLocalizedString(@"Password must contain alpha numeric characters or at least 6 characters",nil)];
//    [_confirmPassword addConfirmValidationTo:_passwordNew withMsg:NSLocalizedString(@"Confirm password didn’t match.",nil)];
   
    activeColor = [UIColor blackColor];
    deActiveColor = [UIColor colorFromHexString:@"#ACACAC"];
    imgShowPass = [UIImage imageNamed:@"icon_eye"];
    imgHidePass = [UIImage imageNamed:@"icon_offeye"];
    [self setupUI];
}

- (void) setupUI{
     [_currentPassword setupUnderline];
    [_passwordNew setupUnderline];
    [_confirmPassword setupUnderline];
    
    [_currentPassLabel setTextColor:deActiveColor];
    [_lblNewPass setTextColor:deActiveColor];
    [_confirmPassLabel setTextColor:deActiveColor];
    
    [_showCurrentPassButton setEnabled:NO];
    [_showNewPassButton setEnabled:NO];
    [_showConfirmPassButton setEnabled:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavigationBar {
//    self.doneButton = [[UIBarButtonItem alloc] initWithTitle:[AppHelper getLocalizedString:@"UpdatePhoneNumber.doneButton"] style:UIBarButtonItemStyleDone target:self action:@selector(touchDoneButton)];
//    self.doneButton.enabled = false;
//    self.navigationItem.rightBarButtonItem = self.doneButton;
    
    doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done",nil) style:UIBarButtonItemStyleDone target:self action:@selector(touchDoneButton)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:doneButton, nil]];
    
    [AppHelper setTitleViewForNavigationBar:self.navigationItem title:NSLocalizedString(@"Change Password", nil)];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchDoneButton {
    [self.view endEditing:YES];
    [self.view setNeedsLayout];
    if (![_currentPassword.text isEqual: @""])
    {
        if([_currentPassword validatePassword])
        {
            if (![_passwordNew.text isEqualToString:@""])
            {
                if([_passwordNew validatePassword])
                {
                    if(![_confirmPassword.text isEqualToString:@""])
                    {
                        if([_confirmPassword validatePassword])
                        {
                            if ([_confirmPassword.text isEqualToString:_passwordNew.text]) {
                                
                                NSString *pass = [NSString md5:_currentPassword.text];
                                NSString *passNew = [NSString md5:_passwordNew.text];
                                NSString *passConfirm = [NSString md5:_confirmPassword.text];
                                NSString *secretClient = [userDefaultManager generateSecretClient];
                                NSString *userpass = [NSString stringWithFormat:@"%@+|+%@+|+%@", pass, passNew, passConfirm];
                                NSString *encryptedSecretClient = [userDefaultManager encryptDESByKey:[userDefaultManager getAppKey] data:secretClient iv:[userDefaultManager getAppSecret]];
                                NSString *encryptedCridential = [userDefaultManager encryptDESByKey:[userDefaultManager getAppKey] data:userpass iv:secretClient];
                                
                                password *param = [[password alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] secret_client:encryptedSecretClient credential:encryptedCridential];
                                if (param) {
                                    API_Profile_ChangePassword *api = [[API_Profile_ChangePassword alloc] initWithParams:param];
                                    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                                        if (response.status) {
                                            [self.view endEditing:YES];
                                            [AppHelper showMessageBox:NSLocalizedString(@"SetupPassSuccess.tittle", nil) message:NSLocalizedString(@"SetupPassSuccess.message", nil)];
                                            [self.navigationController popViewControllerAnimated:YES];
                                        } else {
                                            [AppHelper showMessageBox:response.message message:nil];
                                            [_currentPassword becomeFirstResponder];
                                        }
                                    } ErrorHandlure:^(NSError *error) {
                                        
                                    }];
                                    
                                }
                            }else{
                                [AppHelper showMessageBox:NSLocalizedString(@"ConfirmPasswordNotMatch", nil) message:nil];
                                [_confirmPassword becomeFirstResponder];
                            }
                        }
                        else
                        {
                            [AppHelper showMessageBox:NSLocalizedString(@"PassWordAtleast6Char", nil) message:nil];
                            [_confirmPassword becomeFirstResponder];
                        }
                    }
                    else
                    {
                        [AppHelper showMessageBox:NSLocalizedString(@"confirmnewPasswordEmpty", nil) message:nil];
                        [_confirmPassword becomeFirstResponder];
                    }
                }
                else
                {
                    [AppHelper showMessageBox:NSLocalizedString(@"PassWordAtleast6Char", nil) message:nil];
                    [_passwordNew becomeFirstResponder];
                }
            }else{
                [AppHelper showMessageBox:NSLocalizedString(@"newPasswordEmpty", nil) message:nil];
                [_passwordNew becomeFirstResponder];
            }
        }
        else
        {
            [AppHelper showMessageBox:NSLocalizedString(@"PassWordAtleast6Char", nil) message:nil];
            [_currentPassword becomeFirstResponder];
        }
    }
    else
    {
        [AppHelper showMessageBox:NSLocalizedString(@"enterYourCurrentPassword", nil) message:nil];
        [_currentPassword becomeFirstResponder];
    }
}

- (IBAction)touchViewCurrentPassword:(id)sender {
    _currentPassword.secureTextEntry = !_currentPassword.secureTextEntry;
}

- (IBAction)touchViewPasswordNew:(id)sender {
    _passwordNew.secureTextEntry = !_passwordNew.secureTextEntry;
}

- (void)displayErrorMessage:(NSString*)message
{
//    [_lblError setText:message];
}

#define MAX_LENGTH 20

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length >= MAX_LENGTH && range.length == 0)
    {
        return NO; // return NO to not change text
    }
    return YES;
}

#pragma mark - Current Password
- (IBAction)didEndEditingCurrentPassword:(id)sender {
}
- (IBAction)didBeginEditingCurrentPassword:(id)sender {
    
}
- (IBAction)changedEditingCurrentPassword:(id)sender {
    if ([_currentPassword.text isEqualToString:@""]) {
        [_currentPassLabel setTextColor:deActiveColor];
        [_showCurrentPassButton setEnabled:NO];
    }else{
        [_currentPassLabel setTextColor:activeColor];
        [_showCurrentPassButton setEnabled:YES];
    }

}

- (IBAction)showCurrentPass_Pressed:(id)sender {
    if (!isShowCurrentPass)
    {
        isShowCurrentPass = YES;
        [_showCurrentPassButton setImage:imgHidePass forState:UIControlStateNormal];
        [_currentPassword setSecureTextEntry:NO];
    }
    else
    {
        isShowCurrentPass = NO;
        [_showCurrentPassButton setImage:imgShowPass forState:UIControlStateNormal];
        [_currentPassword setSecureTextEntry:YES];
        
    }
    [_currentPassword setFont:nil];
    [_currentPassword setFont:[UIFont fontWithName:SFUIDisplay_Regular size:12]];

}


#pragma mark - NewPassword
- (IBAction)didEndEditingNewPassword:(id)sender {
    
}
- (IBAction)didBeginEditingNewPassword:(id)sender {
    
}
- (IBAction)changedEditingNewPassword:(id)sender {
    if ([_passwordNew.text isEqualToString:@""]) {
        [_lblNewPass setTextColor:deActiveColor];
        [_showNewPassButton setEnabled:NO];
    }else{
        [_lblNewPass setTextColor:activeColor];
        [_showNewPassButton setEnabled:YES];
    }
}

- (IBAction)showNewPass_Pressed:(id)sender {
    
    if (!isShowNewPass){
        isShowNewPass = YES;
        [_showNewPassButton setImage:imgHidePass forState:UIControlStateNormal];
        [_passwordNew setSecureTextEntry:NO];
       
    }else{
        isShowNewPass = NO;
        [_showNewPassButton setImage:imgShowPass forState:UIControlStateNormal];
        [_passwordNew setSecureTextEntry:YES];
        
    }
    [_passwordNew setFont:nil];
     [_passwordNew setFont:[UIFont fontWithName:SFUIDisplay_Regular size:12]];
}

#pragma mark - Confirm new Password
- (IBAction)didEndEditingConfirmNewPassword:(id)sender {
    
}
- (IBAction)didBeginEditingConfirmNewPassword:(id)sender {
    
}
- (IBAction)changedEditingConfirmNewPassword:(id)sender {
    if ([_confirmPassword.text isEqualToString:@""]) {
        [_confirmPassLabel setTextColor:deActiveColor];
        [_showConfirmPassButton setEnabled:NO];
    }else{
        [_confirmPassLabel setTextColor:activeColor];
        [_showConfirmPassButton setEnabled:YES];
    }
}
- (IBAction)showConfirmPass_Pressed:(id)sender {
    if (!isShowConfirmPass){
        isShowConfirmPass = YES;
        [_showConfirmPassButton setImage:imgHidePass forState:UIControlStateNormal];
        [_confirmPassword setSecureTextEntry:NO];
    }else{
        isShowConfirmPass = NO;
        [_showConfirmPassButton setImage:imgShowPass forState:UIControlStateNormal];
        [_confirmPassword setSecureTextEntry:YES];
        
    }
    
    [_confirmPassword setFont:nil];
    [_confirmPassword setFont:[UIFont fontWithName:SFUIDisplay_Regular size:12]];
}

@end
