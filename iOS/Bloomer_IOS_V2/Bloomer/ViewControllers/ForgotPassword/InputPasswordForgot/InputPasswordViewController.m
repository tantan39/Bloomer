//
//  InputPasswordViewController.m
//  Bloomer
//
//  Created by Phan Van Thanh Dat on 10/16/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "InputPasswordViewController.h"
#import "SelectScreenViewController.h"

@interface InputPasswordViewController ()
{
    UserDefaultManager *userDefaultManager;
    BOOL isShowNewPass, isShowConfirmPass;
    UIImage * imgShowPass, * imgHidePass;
    Spinner * spinner;
}
@end

@implementation InputPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    spinner = [(AppDelegate *) [[UIApplication sharedApplication] delegate] spinner];
    self.completeButton.layer.cornerRadius = 4;
//    [self.password setupPasswordUnderline];
    
    [self.password becomeFirstResponder];
    [self.completeButton setStatusEnable:NO];
    
    [self.password setLeftViewWithImage:[UIImage imageNamed:@"icoPassword"]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    self.titleLabel.text = [AppHelper getLocalizedString: @"inputPassword.titleLabel"];
    [self.completeButton setTitle:[AppHelper getLocalizedString: @"inputPassword.titleBtnComplete"] forState:UIControlStateNormal];
    self.password.placeholder = [AppHelper getLocalizedString: @"signIn.placeholderInputNewPasswordTextfield"];
    [self.btnShowHidePass setTitle: [AppHelper getLocalizedString:@"login.showPasswordButton"] forState:UIControlStateNormal];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [AppHelper changeNavigationBarToWhite:self.navigationController];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
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
    if (self.password.text.length == 0) {
//        [self.password setTextColor:[UIColor colorFromHexString:@"#A7A7A7"]];
        [self.completeButton setStatusEnable:NO];
    } else {
//        [self.password setTextColor:[UIColor colorFromHexString:@"#333333"]];
        [self.completeButton setStatusEnable:YES];
    }
    [self.password setError: @"" animated:NO];
}

#pragma mark - Hide/Show Password
- (IBAction)btnShowNewPass_Pressed:(id)sender {
    if (!self.password.secureTextEntry) {
        [self.btnShowHidePass setTitle: [AppHelper getLocalizedString: @"login.showPasswordButton"] forState:UIControlStateNormal];
    } else {
        [self.btnShowHidePass setTitle: [AppHelper getLocalizedString: @"login.hidenPassword"] forState:UIControlStateNormal];
    }
    self.password.secureTextEntry = !self.password.secureTextEntry;
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
    frame.origin.y = self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;;
    
    [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.frame = frame;
    }];
}

- (IBAction)touchDoneButton:(id)sender
{
    if (self.password.text.length == 0) {
        [self.password setError: [AppHelper getLocalizedString:@"signIn.inputPasswordEmpty"] animated:YES];
        return;
    }
    [self.view endEditing:TRUE];
    if (![self.password validatePassword]) {
        [self.password setError: [AppHelper getLocalizedString:@"signIn.inputPasswordErrorFormat"] animated:YES];
        return;
    }
    
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
            [self.password setError:objStatus.message animated:TRUE];
//            [AppHelper showMessageBox:nil message:objStatus.message];
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
