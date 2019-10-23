//
//  EnterPasswordViewController.m
//  Bloomer
//
//  Created by Tran Thai Tan on 11/30/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "EnterPasswordViewController.h"

@interface EnterPasswordViewController (){
    UserDefaultManager * userDefaultManager;
    Spinner * spinner;
    BOOL isShowPass;
    UIImage * imgShowPass, * imgHidePass;
}

@end

@implementation EnterPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    userDefaultManager = [[UserDefaultManager alloc] init];
    spinner = [(AppDelegate *)[[UIApplication sharedApplication] delegate] spinner];
    
    self.btnNext.layer.cornerRadius = self.btnNext.frame.size.height/2;
    [self.btnNext setStatusEnable:NO];
    
    imgShowPass = [UIImage imageNamed:@"icon_eye"];
    imgHidePass = [UIImage imageNamed:@"icon_offeye"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [_tfPassword becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tfPassword setupPasswordUnderline];
}


- (IBAction)touchBackground:(id)sender {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length >= 20 && range.length == 0)
    {
        return NO; // return NO to not change text
    }else{
        return YES
        ;}
}

- (IBAction)passwordEditChange:(id)sender {

    if (![self.tfPassword validatePassword]) {
        [self.tfPassword setTextColor:[UIColor colorFromHexString:@"#A7A7A7"]];
        [self.btnNext setStatusEnable:NO];
    }else{
        [self.tfPassword setTextColor:[UIColor colorFromHexString:@"#333333"]];
        [self.btnNext setStatusEnable:YES];
    }
}

- (IBAction)btnShowHidePass_Pressed:(id)sender {
    if (!isShowPass)
    {
        isShowPass = YES;
        [self.btnShowHidePass setImage:imgHidePass forState:UIControlStateNormal];
        
        [self.tfPassword setSecureTextEntry:NO];
    }else{
        isShowPass = NO;
        [self.btnShowHidePass setImage:imgShowPass forState:UIControlStateNormal];
        [self.tfPassword setSecureTextEntry:YES];
    }
}

- (IBAction)btnBack_Pressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnForgotPass_Pressed:(id)sender {
    ResetPasswordVerifyCodeViewController * resetPassVC = [[ResetPasswordVerifyCodeViewController alloc] initWithNibName:@"ResetPasswordVerifyCodeViewController" bundle:nil];
    resetPassVC.phoneNumber = self.phoneNumber;
    [self.navigationController pushViewController:resetPassVC animated:YES];
}

- (IBAction)btnNext_Pressed:(id)sender {
    NSString *pass = [NSString md5:self.tfPassword.text];
    NSString *secretClient = [userDefaultManager generateSecretClient];
    NSString *userpass = [NSString stringWithFormat:@"%@+|+%@", self.phoneNumber, pass];
    NSString *encryptedSecretClient = [userDefaultManager encryptDESByKey:[userDefaultManager getAppKey] data:secretClient iv:[userDefaultManager getAppSecret]];
    NSString *encryptedCridential = [userDefaultManager encryptDESByKey:[userDefaultManager getAppKey] data:userpass iv:secretClient];
    
    auth_authorize * params = [[auth_authorize alloc] initWithCredential:encryptedCridential secretClient:encryptedSecretClient deviceToken:[userDefaultManager getDeviceToken] country_id:[[BloomerManager shareInstance] countryID] appID:[userDefaultManager getAppID] notification_token:[userDefaultManager getNotificationToken]];
        NSLog(@"device id %@", [userDefaultManager getDeviceToken]);
        if (params) {
            [spinner startAnimating];
            API_Auth_Authorize * api = [[API_Auth_Authorize alloc] initWithParams:params viaCode:NO];
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
}

#pragma mark - Handle Show/Hide Keyboard
- (void)keyboardWillShow:(NSNotification *) notif
{
    NSDictionary *userInfo = [notif userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGFloat yFrame = self.view.bounds.size.height - (_btnNext.frame.origin.y + _btnNext.bounds.size.height + 5);
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


@end
