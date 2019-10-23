//
//  ConfirmationViewController.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/8/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "ConfirmationViewController.h"
#import <CoreText/CoreText.h>
#import "AppHelper.h"

@interface ConfirmationViewController ()
{
    UserDefaultManager *userDefaultManager;
    long textCount;
    Spinner * spinner;
    NSInteger iCallSupportCount;
    CGRect originFrame;

}

@end

@implementation ConfirmationViewController
@synthesize lblCodeList;

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName: [AppHelper getScreenNameView:nibNameOrNil] bundle:nibBundleOrNil];
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [self initWithCoder:aDecoder];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    spinner = ((AppDelegate *)[UIApplication sharedApplication].delegate).spinner;
    userDefaultManager = [[UserDefaultManager alloc] init];
    
    textCount = 0;
    
    _enterButton.layer.cornerRadius = 4;
    [_enterButton setStatusEnable:NO];
    [self setUpLabel];
    [self setUp];
    self.codeField.delegate = self;
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    originFrame = self.view.frame;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    [_codeField becomeFirstResponder];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [AppHelper changeNavigationBarToWhite:self.navigationController];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    BOOL isCountryVN = [[BloomerManager shareInstance].country_short_name isEqualToString:@"vn"];
    [_btnFreeCall setUserInteractionEnabled:isCountryVN];
    if(!isCountryVN) {
        [_btnFreeCall setAlpha:0.3];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:YES];
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)setVerifyCodeNumber:(NSString*)code
{
    [self.codeField setText:code];
    [self.codeField sendActionsForControlEvents:UIControlEventEditingChanged];
    
    for (int i = 0; i < [self.lblCodeList count]; i++)
    {
        if (i < [code length])
        {
            //            [self.imgdotList[i] setHidden:YES];
            [self.lblCodeList[i] setText:[NSString stringWithFormat:@"%c", [code characterAtIndex:i]]];
            [self setBorderColor: lblCodeList[i] color:[UIColor rgb:178 green:34 blue:37]];
            //            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[self.lblCodeList[i] text]];
            //            [attributeString addAttribute:NSUnderlineStyleAttributeName
            //                                    value:[NSNumber numberWithInt:1]
            //                                    range:(NSRange){0,[attributeString length]}];
            //            [self.lblCodeList[i] setAttributedText:attributeString];
        }
        else
        {
            [self.lblCodeList[i] setText:@""];
        }
        
    }
}

- (IBAction)touchBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (void) setUp {
    NSString *string = [NSString stringWithFormat:[AppHelper getLocalizedString: @"Support Label"], [AppHelper getLocalizedString:@"Support phone"], [AppHelper getLocalizedString:@"Support email"]];
    
    NSMutableAttributedString *stringAttribute  = [[NSMutableAttributedString alloc]initWithString:string];
    NSRange rangePhone = [string rangeOfString:[AppHelper getLocalizedString:@"Support phone"]];
    
    [stringAttribute addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]
                            range:rangePhone];
    
    NSRange rangeMail = [string rangeOfString:[AppHelper getLocalizedString:@"Support email"]];
    
    [stringAttribute addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]
                            range:rangeMail];
    self.labelSupport.attributedText = stringAttribute;
    
}

- (void) setUpLabel {
    for (UILabel * lb  in self.lblCodeList) {
        [self setBorderColor:lb color: [UIColor rgb:245 green:245 blue:245]];
        
    }
}

- (void) setBorderColor: (UILabel*) label color: (UIColor*) color {
    label.layer.cornerRadius= 4.0f;
    label.layer.masksToBounds = YES;
    label.layer.borderColor = [color CGColor];
    label.layer.borderWidth = 1.5f;
}

- (void) pushUpdateProfile {
    UpdateInfoViewController *updateInfoVC = [[UpdateInfoViewController alloc] init];
    [self.view endEditing:YES];
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]];
    [self.navigationController pushViewController:updateInfoVC animated:TRUE];
}

- (IBAction)touchEnterButton:(id)sender
{
    
    if (![self.codeField.text isEqualToString: @""])
    {
        [self.view endEditing:TRUE];
        [_enterButton setStatusEnable:YES];
        if (!_isMobileVerify)
        {
//            NSString *activeCode = _codeTextField.text;
            NSString *secretClient = [userDefaultManager generateSecretClient];
            NSString * credentialPrefix = _isSignUp ? @([userDefaultManager getM_ID]).stringValue : _phoneNumber;
            NSString *credential = [NSString stringWithFormat:@"%@+|+%@", credentialPrefix, self.codeField.text];
            NSString *encryptedSecretClient = [userDefaultManager encryptDESByKey:[userDefaultManager getAppKey] data:secretClient iv:[userDefaultManager getAppSecret]];
            NSString *encryptedCridential = [userDefaultManager encryptDESByKey:[userDefaultManager getAppKey] data:credential iv:secretClient];
            
            if(_isSignUp) {
                verifycode *params = [[verifycode alloc] initWithCredential:encryptedCridential
                                                               Device_Token:[userDefaultManager getDeviceToken]
                                                         notification_token:[userDefaultManager getNotificationToken]
                                                              Secret_Client:encryptedSecretClient
                                                                     App_ID:[userDefaultManager getAppID]];
                
                API_Auth_RegisterVerifyCode * api = [[API_Auth_RegisterVerifyCode alloc]initWithParams:params];
                [spinner startAnimating];
                [api postRequest:^(BaseJSON * json, RestfulResponse * objStatus) {
                    [spinner stopAnimating];
                    out_auth_register_verifycode * data = (out_auth_register_verifycode *) json;
                    if (objStatus.status)
                    {
                        [AppHelper FBLogCompletedRegistration:@"phone_number"];
                        [[[BloomerManager shareInstance] auth_FBRegister] setPhoneNumber:self.phoneNumber];
                        [[BloomerManager shareInstance] setAuthenType:Via_PHONENUMBER];
                        [userDefaultManager saveAccessToken:data.access_token];
                        [userDefaultManager saveRefresh_Token:data.refresh_token];
                        
                        [self pushUpdateProfile];
                    }else{
                        
                        if (objStatus.code == 464) {
                            [self pushUpdateProfile];
                        } else {
                            [AppHelper showMessageBox:nil message:objStatus.message];
                        }
                    }
                    
                    [_enterButton setEnabled:TRUE];
                    
                } ErrorHandlure:^(NSError * error) {
                    [spinner stopAnimating];
                    [_enterButton setEnabled:TRUE];
                }];
            } else {
                auth_authorize* params = [[auth_authorize alloc] initWithCredential:encryptedCridential
                                                                       secretClient:encryptedSecretClient
                                                                        deviceToken:[userDefaultManager getDeviceToken]
                                                                         country_id:_country_id
                                                                              appID:[userDefaultManager getAppID]
                                                                 notification_token:[userDefaultManager getNotificationToken]];
                
                API_Auth_Authorize *api = [[API_Auth_Authorize alloc] initWithParams:params viaCode:YES];
                [spinner startAnimating];
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
        else
        {
            NSString *activeCode = _codeField.text;
            NSString *secretClient = [userDefaultManager generateSecretClient];
            NSString *credential = [NSString stringWithFormat:@"%@", activeCode];
            NSString *encryptedSecretClient = [userDefaultManager encryptDESByKey:[userDefaultManager getAppKey] data:secretClient iv:[userDefaultManager getAppSecret]];
            NSString *encryptedCridential = [userDefaultManager encryptDESByKey:[userDefaultManager getAppKey] data:credential iv:secretClient];
            
            mobile_verify *param = [[mobile_verify alloc] initWithAccess_Token:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] code:activeCode uid:@([userDefaultManager getUserProfileData].uid).stringValue secret_client:encryptedSecretClient credential:encryptedCridential];
            
            if (param) {
                API_MobileVerify *API = [[API_MobileVerify alloc] initWithParams:param];
                [spinner startAnimating];
                [API request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                    [spinner stopAnimating];
                    if (response.status)
                    {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }else{
                        [AppHelper showMessageBox:nil message:response.message];
                    }
                } ErrorHandlure:^(NSError *error) {
                    [spinner stopAnimating];
                }];
            }
        }
    }
    else
    {
        [_lblError setText: NSLocalizedString(@"Please enter your code",nil)];
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

- (IBAction)touchBackground:(id)sender
{
    [self.view endEditing:TRUE];
    //    [self keyboardWillHide];
}

- (IBAction)touchCodeField:(id)sender
{
    //    [self keyboardWillShow];
}

- (IBAction)changeCodeField:(id)sender {
    if (![_codeField.text isEqualToString:@""] && _codeField.text.length == 4)
    {
        [_enterButton setStatusEnable:YES];
        [self touchEnterButton:nil];
    }else{
        [_enterButton setStatusEnable:NO];
    }
    
}

- (IBAction)valuechangeCodeField:(id)sender{
}

- (void)enableResendButton
{
    [_btnFreeSMS setStatusEnable:YES WithButtonType:GETVERIFYCODE_BUTTON];
    [_lblError setText:@""];
}
- (void) enableVoiceCall{
    if (iCallSupportCount < 2) {
        [_btnFreeCall setStatusEnable:YES WithButtonType:GETVERIFYCODE_BUTTON];
    }
    [_lblError setText:@""];
}

#pragma mark - Free Call - Resend Code
- (IBAction)btnFreeCall_Pressed:(id)sender {
    [_btnFreeCall setStatusEnable:NO WithButtonType:GETVERIFYCODE_BUTTON];
    
    [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(enableVoiceCall) userInfo:nil repeats:FALSE];
    [_lblError setText:NSLocalizedString(@"Please wait up for 15s",nil)];
    
    resendcode * params = [[resendcode alloc] initWithPhoneNumb:self.phoneNumber CountryID:[[BloomerManager shareInstance] countryID] Voice:YES];
    if (params) {
        if(_isSignUp) {
            API_Auth_ResendCode * api = [[API_Auth_ResendCode alloc] initWithParamsForSignUp:params];
            [api request:^(BaseJSON * json, RestfulResponse * data) {
                if (data.status) {
                    iCallSupportCount++;
                }else{
                    [AppHelper showMessageBox:nil message:data.message];
                }
            } ErrorHandlure:^(NSError * error) {
                [_btnFreeCall setStatusEnable:YES WithButtonType:GETVERIFYCODE_BUTTON];
            }];
        } else {
            API_Auth_ResendCode * api = [[API_Auth_ResendCode alloc] initWithParamsForLogin:params];
            [api request:^(BaseJSON * json, RestfulResponse * data) {
                if (data.status) {
                    iCallSupportCount++;
                }else{
                    [AppHelper showMessageBox:nil message:data.message];
                }
            } ErrorHandlure:^(NSError * error) {
                [_btnFreeCall setStatusEnable:YES WithButtonType:GETVERIFYCODE_BUTTON];
            }];
        }
    }
    
}

- (IBAction)btnResendCode_Pressed:(id)sender {
    [_btnFreeSMS setStatusEnable:NO WithButtonType:GETVERIFYCODE_BUTTON];
    [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(enableResendButton) userInfo:nil repeats:FALSE];
    [_lblError setText:NSLocalizedString(@"Please wait up for 1 min", nil)];
    
    resendcode * params = [[resendcode alloc] initWithPhoneNumb:self.phoneNumber CountryID:[[BloomerManager shareInstance] countryID] Voice:NO];
    if (params) {
        if(_isSignUp) {
            API_Auth_ResendCode * api = [[API_Auth_ResendCode alloc] initWithParamsForSignUp:params];
            [api request:^(BaseJSON * json, RestfulResponse * data) {
                if (data.status) {

                }else{
                    [AppHelper showMessageBox:nil message:data.message];
                }
            } ErrorHandlure:^(NSError * error) {
                [_btnFreeCall setStatusEnable:YES WithButtonType:GETVERIFYCODE_BUTTON];
            }];
        } else {
            API_Auth_ResendCode * api = [[API_Auth_ResendCode alloc] initWithParamsForLogin:params];
            [api request:^(BaseJSON * json, RestfulResponse * data) {
                if (data.status) {

                }else{
                    [AppHelper showMessageBox:nil message:data.message];
                }
            } ErrorHandlure:^(NSError * error) {
                [_btnFreeCall setStatusEnable:YES WithButtonType:GETVERIFYCODE_BUTTON];
            }];
        }
    }
}

#pragma mark - Handle Show/Hide Keyboard
- (void)handleKeyboard:(NSNotification *) notif
{
    if ([AppHelper isIP5AndIP4]) {
        return;
    }
    
    NSDictionary *userInfo = [notif userInfo];
    
    if (notif.name == UIKeyboardWillShowNotification) { //Keyboard show
        
        CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        CGFloat yFrame = self.view.bounds.size.height - (_enterButton.frame.origin.y + _enterButton.bounds.size.height + 7);
        CGFloat offSet = yFrame - kbSize.height;
        
        if (offSet < 0) {
            self.view.frame = CGRectMake(0, offSet + self.view.frame.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
            
            [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
                [self.view layoutIfNeeded];
            }];
        }
        
    }else{ //Keyboard hide
        
        [self.view setFrame:CGRectMake(originFrame.origin.x, originFrame.origin.y, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
            [self.view layoutIfNeeded];
        }];
    }

}

#pragma mark - TextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *text = [textField.text stringByReplacingCharactersInRange:range
                                                             withString:string];
    for (int i =0 ; i < [self.lblCodeList count]; i++)
    {
        if(i < [text length])
        {
            //            [self.imgdotList[i] setHidden:YES];
            if([[self.lblCodeList[i] text] isEqualToString:@""])
            {
                [self.lblCodeList[i] setText:string];
                [self setBorderColor: lblCodeList[i] color:[UIColor rgb:178 green:34 blue:37]];
                //                NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[self.lblCodeList[i] text]];
                //                [attributeString addAttribute:NSUnderlineStyleAttributeName
                //                                        value:[NSNumber numberWithInt:1]
                //                                        range:(NSRange){0,[attributeString length]}];
                //                [self.lblCodeList[i] setAttributedText:attributeString];
            }
        }
        else
        {
            //            [self.imgdotList[i] setHidden:NO];
            [self.lblCodeList[i] setText:@""];
            [self setBorderColor:lblCodeList[i] color: [UIColor rgb:245 green:245 blue:245]];
        }
        self.lblError.text = @"";
    }
    return [text length] <= 4;
}

@end
