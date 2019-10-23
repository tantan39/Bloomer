//
//  ChangePasswordViewController.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/9/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "SelectScreenViewController.h"

@interface ChangePasswordViewController ()
{
    UserDefaultManager *userDefaultManager;
    BOOL isShowNewPass, isShowConfirmPass;
    UIImage * imgShowPass, * imgHidePass;
    Spinner * spinner;
}
@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    spinner = [(AppDelegate *) [[UIApplication sharedApplication] delegate] spinner];
    self.completeButton.layer.cornerRadius = self.completeButton.frame.size.height/2;
    [self.password setupPasswordUnderline];
    
    [self.password becomeFirstResponder];
    [self.completeButton setStatusEnable:NO];
    
    imgShowPass = [UIImage imageNamed:@"icon_eye"];
    imgHidePass = [UIImage imageNamed:@"icon_offeye"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_password becomeFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

- (IBAction)touchBackground:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)touchBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (IBAction)textFieldPassword_EditChange:(id)sender {
    if (![self.password validatePassword]) {
        [self.password setTextColor:[UIColor colorFromHexString:@"#A7A7A7"]];
        [self.completeButton setStatusEnable:NO];
    } else {
        [self.password setTextColor:[UIColor colorFromHexString:@"#333333"]];
        [self.completeButton setStatusEnable:YES];
    }
}

#pragma mark - Hide/Show Password
- (IBAction)btnShowNewPass_Pressed:(id)sender {
    if (!isShowNewPass){
        
        isShowNewPass = YES;
        [self.btnShowHidePass setImage:imgHidePass forState:UIControlStateNormal];
        [_password setSecureTextEntry:NO];
        
    }else{
        isShowNewPass = NO;
        [self.btnShowHidePass setImage:imgShowPass forState:UIControlStateNormal];
        [_password setSecureTextEntry:YES];
    }
    
//    [_password setFont:nil];
//    [_password setFont:[UIFont fontWithName:SFUIDisplay_Regular size:14]];
}


#pragma mark - Handle Show/Hide Keyboard
- (void)keyboardWillShow:(NSNotification *) notif
{
    NSDictionary *userInfo = [notif userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGFloat yFrame = self.view.bounds.size.height - (_completeButton.frame.origin.y + _completeButton.bounds.size.height + 10);
    CGFloat offSet = yFrame - kbSize.height;
    
    if (offSet < 0) {
        [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
            self.view.frame = CGRectMake(0, offSet, self.view.bounds.size.width, self.view.bounds.size.height);
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *) notif
{
    NSDictionary *userInfo = [notif userInfo];
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    
    [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.frame = frame;
    }];
}

- (IBAction)touchDoneButton:(id)sender
{

    NSString *pass = [NSString md5:_password.text];
    NSString *passConfirm = [NSString md5:_password.text];
    NSString *secretClient = [userDefaultManager generateSecretClient];
    NSString *userpass = [NSString stringWithFormat:@"%ld+|+%@+|+%@", (long)_f_id, pass, passConfirm];
    
    NSString *encryptedSecretClient = [userDefaultManager encryptDESByKey:[userDefaultManager getAppKey] data:secretClient iv:[userDefaultManager getAppSecret]];
    NSString *encryptedCridential = [userDefaultManager encryptDESByKey:[userDefaultManager getAppKey] data:userpass iv:secretClient];
    
    account_forget_changepass *params = [[account_forget_changepass alloc] initWithCredential:encryptedCridential secretClient:encryptedSecretClient deviceToken:[userDefaultManager getDeviceToken] appID:[userDefaultManager getAppID]];
    [spinner startAnimating];
    API_Account_ForgetChangePass * api = [[API_Account_ForgetChangePass alloc] initWithParams:params];
    [api postRequest:^(BaseJSON *json, RestfulResponse * objStatus) {
        if (objStatus.status){
            [self requestAuthenticationWithPhoneNumb:self.phoneNumber Password:pass];
        }
        else
        {
            [spinner stopAnimating];
            [AppHelper showMessageBox:nil message:objStatus.message];
        }
    } ErrorHandlure:^(NSError * error) {
        [spinner stopAnimating];
    }];

}

- (void) requestAuthenticationWithPhoneNumb:(NSString *) phone Password:(NSString *) pass {
//    NSString *pass = [Support md5:self.tfPassword.text];
    NSString *secretClient = [userDefaultManager generateSecretClient];
    NSString *userpass = [NSString stringWithFormat:@"%@+|+%@", phone, pass];
    NSString *encryptedSecretClient = [userDefaultManager encryptDESByKey:[userDefaultManager getAppKey] data:secretClient iv:[userDefaultManager getAppSecret]];
    NSString *encryptedCridential = [userDefaultManager encryptDESByKey:[userDefaultManager getAppKey] data:userpass iv:secretClient];
    
    Auth_FBAuthentication * params = [[Auth_FBAuthentication alloc] initWithFBToken:@"" SecretClient:encryptedSecretClient DeviceToken:[userDefaultManager getDeviceToken] NotificationToken:[userDefaultManager getNotificationToken] Credential:encryptedCridential CountryID:[[BloomerManager shareInstance] countryID] AppID:[userDefaultManager getAppID]];
    NSLog(@"device id %@", [userDefaultManager getDeviceToken]);
    if (params) {
        [spinner startAnimating];
        API_Auth_FBAuthentication * api = [[API_Auth_FBAuthentication alloc] initWithParams:params];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            
            out_auth_authorize * object = (out_auth_authorize *) jsonObject;
            if (response.status) {
                [userDefaultManager getUserProfileData].gender = object.gender;
                [userDefaultManager saveAccessToken:object.access_token];
                [userDefaultManager saveRefresh_Token:object.refresh_token];
                [userDefaultManager saveCredentialEjab:[userDefaultManager decryptDESByKey:[userDefaultManager getAppKey] data:object.cridential_ejab iv:[userDefaultManager getAppSecret]]];
                [userDefaultManager setDidPostDailyLocalNotification:false];
                [LocalNotificationHelper removeAllLocalNotifications];
                
                [self requestGetProfileMeWith:object.access_token DeviceToken:[userDefaultManager getDeviceToken]];
            }else{
                [spinner stopAnimating];
                [AppHelper showMessageBox:nil message:response.message];
            }
        } ErrorHandlure:^(NSError *error) {
            [spinner stopAnimating];
        }];
    }
}

- (void) requestGetProfileMeWith:(NSString *) accessToken DeviceToken:(NSString *) deviceToken{
    if (accessToken && deviceToken) {
        API_Profile_Me * api = [[API_Profile_Me alloc] initWithAccessToken:accessToken
                                                              device_token:deviceToken];
        [api getRequest:^(BaseJSON * json, RestfulResponse * objStatus) {
            out_profile_fetch * data = (out_profile_fetch *) json;
            [spinner stopAnimating];
            if (objStatus.status)
            {
                [userDefaultManager saveUserProfileData:data];
                [userDefaultManager removeM_ID];
                //                profileData = data;
                TabBarViewController *view = [[TabBarViewController alloc] initWithNibName:@"TabBarViewController" bundle:nil];
                [view setSelectedIndex:0];
                [self.navigationController pushViewController:view animated:TRUE];
            }else{
                [AppHelper showMessageBox:[AppHelper getLocalizedString:@"Alert.Title.ErrorMessage"] message:objStatus.message];
            }
        } ErrorHandlure:^(NSError * error) {
            [spinner stopAnimating];
        }];
    }
     [spinner stopAnimating];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length >= 20 && range.length == 0)
    {
        return NO; // return NO to not change text
    }
    else
    {return YES;}
}

@end
