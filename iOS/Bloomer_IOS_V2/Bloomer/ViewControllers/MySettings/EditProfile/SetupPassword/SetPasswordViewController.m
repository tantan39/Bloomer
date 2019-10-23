//
//  SetPasswordViewController.m
//  Bloomer
//
//  Created by Thanh Tu Nguyen on 3/6/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "SetPasswordViewController.h"

@interface SetPasswordViewController ()
{
    UserDefaultManager *userDefaultManager;
    UIColor * activeColor, * deActiveColor;
    
    BOOL isShowCurrentPass, isShowNewPass, isShowConfirmPass;
    
    UIImage * imgShowPass, * imgHidePass;
    UIBarButtonItem *doneButton;
}

@end

@implementation SetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    
    [self initNavigationBar];
    
    activeColor = [UIColor blackColor];
    deActiveColor = [UIColor colorFromHexString:@"#ACACAC"];
    imgShowPass = [UIImage imageNamed:@"icon_eye"];
    imgHidePass = [UIImage imageNamed:@"icon_offeye"];
    
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavigationBar {
    
    doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done",nil) style:UIBarButtonItemStyleDone target:self action:@selector(touchDoneButton)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:doneButton, nil]];
    
    [AppHelper setTitleViewForNavigationBar:self.navigationItem title:NSLocalizedString(@"SetPassword.Label", nil)];
}

- (void) setupUI{
    [_passwordNew setupUnderline];
    [_confirmPassword setupUnderline];
    
    [_lblSetupPass setTextColor:deActiveColor];
    [_lblComfirmPass setTextColor:deActiveColor];
    
    [_confirmPassButton setEnabled:NO];
    [_reviewpassButton setEnabled:NO];
    
}

- (IBAction)reviewPass:(id)sender {
    if (!isShowNewPass){
        isShowNewPass = YES;
        [_reviewpassButton setImage:imgHidePass forState:UIControlStateNormal];
        [_passwordNew setSecureTextEntry:NO];
        
    }else{
        isShowNewPass = NO;
        [_reviewpassButton setImage:imgShowPass forState:UIControlStateNormal];
        [_passwordNew setSecureTextEntry:YES];
        
    }
    [_passwordNew setFont:nil];
    [_passwordNew setFont:[UIFont fontWithName:SFUIDisplay_Regular size:12]];
    
}

- (IBAction)reviewComfirmPass:(id)sender {
    if (!isShowConfirmPass){
        isShowConfirmPass = YES;
        [_confirmPassButton setImage:imgHidePass forState:UIControlStateNormal];
        [_confirmPassword setSecureTextEntry:NO];
    }else{
        isShowConfirmPass = NO;
        [_confirmPassButton setImage:imgShowPass forState:UIControlStateNormal];
        [_confirmPassword setSecureTextEntry:YES];
        
    }
    
    [_confirmPassword setFont:nil];
    [_confirmPassword setFont:[UIFont fontWithName:SFUIDisplay_Regular size:12]];
}

- (void)touchDoneButton {
    [self.view endEditing:YES];
    if (![_passwordNew.text isEqualToString:@""])
    {
        if([_passwordNew validatePassword])
        {
            if(![_confirmPassword.text isEqualToString:@""])
            {
                if ([_confirmPassword.text isEqualToString:_passwordNew.text]) {
                    
                    NSString *passNew = [NSString md5:_passwordNew.text];
                    NSString *secretClient = [userDefaultManager generateSecretClient];
                    NSString *userpass = [NSString stringWithFormat:@"%@", passNew];
                    NSString *encryptedSecretClient = [userDefaultManager encryptDESByKey:[userDefaultManager getAppKey] data:secretClient iv:[userDefaultManager getAppSecret]];
                    NSString *encryptedCridential = [userDefaultManager encryptDESByKey:[userDefaultManager getAppKey] data:userpass iv:secretClient];
                    
                    password *param = [[password alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] secret_client:encryptedSecretClient credential:encryptedCridential];
                    if (param) {
                        API_Set_Password *api = [[API_Set_Password alloc] initWithParams:param];
                        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                            if (response.status) {
                                
                                if(_isLogOut)
                                {
                                    [self showMessage];
                                }
                                else
                                {
                                    out_profile_fetch* profile = [userDefaultManager getUserProfileData];
                                    profile.pass = YES;
                                    [userDefaultManager saveUserProfileData:profile];
                                    [AppHelper showMessageBox:NSLocalizedString(@"SetupPassSuccess.tittle", nil) message:NSLocalizedString(@"CreatePassSuccess.message", nil)];
                                    [self.navigationController popViewControllerAnimated:YES];
                                }
                            } else {
                                [AppHelper showMessageBox:response.message message:nil];
                                [_passwordNew becomeFirstResponder];
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

- (IBAction) changeTextPassword:(id)sender
{
    if ([_passwordNew.text isEqualToString:@""]) {
        [_lblSetupPass setTextColor:deActiveColor];
        [_reviewpassButton setEnabled:NO];
    }else{
        [_lblSetupPass setTextColor:activeColor];
        [_reviewpassButton setEnabled:YES];
    }
}

-(IBAction)changeTextComfirmPass:(id)sender
{
    if ([_confirmPassword.text isEqualToString:@""]) {
        [_lblComfirmPass setTextColor:deActiveColor];
        [_confirmPassButton setEnabled:NO];
    }else{
        [_lblComfirmPass setTextColor:activeColor];
        [_confirmPassButton setEnabled:YES];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length >= 20 && range.length == 0)
    {
        return NO; // return NO to not change text
    }
    return YES;
}


-(void) showMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SetupPassSuccess.tittle",nil)
                                                    message:NSLocalizedString(@"CreatePassSuccess.message", nil)
                                                   delegate:self
                                          cancelButtonTitle: nil
                                          otherButtonTitles: nil, nil];
    [alert show];
    
    [self performSelector:@selector(dismiss:) withObject:alert afterDelay:1.0];
    
    
}

-(void)dismiss:(UIAlertView*)alert
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self logOut];
    });
}

-(void) logOut
{
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

// MARK: - FBSDKAppInviteDialogDelegate
- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error
{
    NSLog(@"error : %@", error);
}

- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results
{
    
}
@end
