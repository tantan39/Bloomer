//
//  ConfirmationViewController.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/8/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "ConfirmationViewController.h"
#import <CoreText/CoreText.h>

@interface ConfirmationViewController ()
{
    UserDefaultManager *userDefaultManager;
    long textCount;
    NSString* _phoneNumber;
    Spinner * spinner;
    NSInteger iCallSupportCount;
}

@end

@implementation ConfirmationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    spinner = ((AppDelegate *)[UIApplication sharedApplication].delegate).spinner;
    userDefaultManager = [[UserDefaultManager alloc] init];
    _m_id = [userDefaultManager getM_ID];
    [_lblPhoneNumber setText:[NSString stringWithFormat:@"+84 %@",_phoneNumber]];
    
    textCount = 0;
    
    [_enterButton setStyleWhiteButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

-(void) setPhoneNumber:(NSString *)phoneNumber
{
    _phoneNumber = phoneNumber;
}

- (void)setVerifyCodeNumber:(NSString*)code
{
    [_codeTextField setText:code];
    [self.codeTextField sendActionsForControlEvents:UIControlEventEditingChanged];
    
    for (int i = 0; i < [self.imgdotList count]; i++)
    {
        if (i < [code length])
        {
            [self.imgdotList[i] setHidden:YES];
            [self.lblCodeList[i] setText:[NSString stringWithFormat:@"%c", [code characterAtIndex:i]]];
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[self.lblCodeList[i] text]];
            [attributeString addAttribute:NSUnderlineStyleAttributeName
                                    value:[NSNumber numberWithInt:1]
                                    range:(NSRange){0,[attributeString length]}];
            [self.lblCodeList[i] setAttributedText:attributeString];
        }
        else
        {
            [self.imgdotList[i] setHidden:NO];
            [self.lblCodeList[i] setText:@""];
        }
        
//        if (i == self.imgdotList.count - 1)
//        {
//            [self touchEnterButton:self.enterButton];
//        }
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_codeTextField becomeFirstResponder];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [_lblPhoneNumber setText:[NSString stringWithFormat:@"(+84) %@",_phoneNumber]];
    
}

- (IBAction)touchBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (IBAction)touchEnterButton:(id)sender
{
    if (!_isMobileVerify)
    {
        NSString *activeCode = _codeTextField.text;
        NSString *secretClient = [userDefaultManager generateSecretClient];
        NSString *credential = [NSString stringWithFormat:@"%ld+|+%@", (long)_m_id, activeCode];
        NSString *encryptedSecretClient = [userDefaultManager encryptDESByKey:[userDefaultManager getAppKey] data:secretClient iv:[userDefaultManager getAppSecret]];
        NSString *encryptedCridential = [userDefaultManager encryptDESByKey:[userDefaultManager getAppKey] data:credential iv:secretClient];
        
        verifycode *params = [[verifycode alloc] initWithCredential:encryptedCridential
                                                       Device_Token:[userDefaultManager getDeviceToken]
                                                 notification_token:[userDefaultManager getNotificationToken]
                                                      Secret_Client:encryptedSecretClient
                                                             App_ID:[userDefaultManager getAppID]];
        
        API_Auth_RegisterVerifyCode * api = [[API_Auth_RegisterVerifyCode alloc]initWithParams:params];
        [api postRequest:^(BaseJSON * json, RestfulResponse * objStatus) {
            out_auth_register_verifycode * data = (out_auth_register_verifycode *) json;
            [spinner stopAnimating];
            if (objStatus.status)
            {
                [AppHelper FBLogCompletedRegistration:@"phone_number"];
                [userDefaultManager saveAccessToken:data.access_token];
                [userDefaultManager saveRefresh_Token:data.refresh_token];
                
                UpdateSignUpViewController *view = [[UpdateSignUpViewController alloc] initWithNibName:@"UpdateSignUpViewController" bundle:nil];
                [self.view endEditing:YES];
                [self.navigationController pushViewController:view animated:TRUE];
            }else{
                
                [AppHelper showMessageBox:nil message:objStatus.message];
            }
            
            [_enterButton setEnabled:TRUE];
            
        } ErrorHandlure:^(NSError * error) {
            [spinner stopAnimating];
            [_enterButton setEnabled:TRUE];
        }];
    }
    else
    {
        NSString *activeCode = _codeTextField.text;
        NSString *secretClient = [userDefaultManager generateSecretClient];
        NSString *credential = [NSString stringWithFormat:@"%@", activeCode];
        NSString *encryptedSecretClient = [userDefaultManager encryptDESByKey:[userDefaultManager getAppKey] data:secretClient iv:[userDefaultManager getAppSecret]];
        NSString *encryptedCridential = [userDefaultManager encryptDESByKey:[userDefaultManager getAppKey] data:credential iv:secretClient];
        
        mobile_verify *param = [[mobile_verify alloc] initWithAccess_Token:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] code:activeCode uid:@([userDefaultManager getUserProfileData].uid).stringValue secret_client:encryptedSecretClient credential:encryptedCridential];
        
        if (param) {
            API_MobileVerify *API = [[API_MobileVerify alloc] initWithParams:param];
            [API request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                if (response.status)
                {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    [AppHelper showMessageBox:nil message:response.message];
                }
            } ErrorHandlure:^(NSError *error) {
                
            }];
        }
        

    }
}

- (IBAction)touchBackground:(id)sender
{
    [self.view endEditing:TRUE];
//    [self keyboardWillHide];
}

//- (IBAction)touchTerms:(id)sender
//{
//    TermAndPolicyViewController *view = [[TermAndPolicyViewController alloc] initWithNibName:@"TermAndPolicyViewController" bundle:nil];
//    view.urlString = [APIDefine termsOfUseLink];
//    view.isTerm = YES;
//    [self.view endEditing:TRUE];
//    [[self navigationController] setNavigationBarHidden:NO animated:NO];
//    [self.navigationController pushViewController:view animated:TRUE];
//    
//}
//- (IBAction)touchPrivacy:(id)sender
//{
//    TermAndPolicyViewController *view = [[TermAndPolicyViewController alloc] initWithNibName:@"TermAndPolicyViewController" bundle:nil];
//    view.urlString = [APIDefine privacyPolicyLink];
//    view.isTerm = NO;
//    [self.view endEditing:TRUE];
//    [[self navigationController] setNavigationBarHidden:NO animated:NO];
//    [self.navigationController pushViewController:view animated:TRUE];
//    
//}

- (IBAction)touchCodeField:(id)sender
{
//    [self keyboardWillShow];
}

- (IBAction)changeCodeField:(id)sender {
    if (![_codeTextField.text isEqualToString:@""] && _codeTextField.text.length == 4)
    {
        [_enterButton setBackgroundColor:[UIColor colorWithRed:0.125 green:0.125 blue:0.129 alpha:1.0]];
        [_enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_enterButton setEnabled:TRUE];
        [self touchEnterButton:nil];
    }else{
        [_enterButton setBackgroundColor:[UIColor clearColor]];
        [_enterButton setTitleColor:[UIColor colorWithRed:0.125 green:0.125 blue:0.129 alpha:1.0] forState:UIControlStateNormal];
        [_enterButton setEnabled:FALSE];
    }
    
}

- (IBAction)valuechangeCodeField:(id)sender{
}

- (void)enableResendButton
{
    [_btnFreeSMS setStatusEnable:YES];
    [_lblError setText:@""];
}
- (void) enableVoiceCall{
    if (iCallSupportCount < 2) {
        [_btnFreeCall setStatusEnable:YES];
    }
    [_lblError setText:@""];
}

#pragma mark - Free Call - Resend Code
- (IBAction)btnFreeCall_Pressed:(id)sender {
//    [spinner startAnimating];
    [_btnFreeCall setStatusEnable:NO];
    
    [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(enableVoiceCall) userInfo:nil repeats:FALSE];
    [_lblError setText:NSLocalizedString(@"Please wait up for 15s",nil)];
    
    NSString *secretClient = [userDefaultManager generateSecretClient];
    NSString *userpass = [userDefaultManager getUserPass];
    NSString *encryptedSecretClient = [userDefaultManager encryptDESByKey:[userDefaultManager getAppKey] data:secretClient iv:[userDefaultManager getAppSecret]];
    NSString *encryptedCridential = [userDefaultManager encryptDESByKey:[userDefaultManager getAppKey] data:userpass iv:secretClient];
    NSString * deviceId = [userDefaultManager getDeviceToken];
    
    sendcode *params = [[sendcode alloc] initWithCredential:encryptedCridential
                                              Secret_Client:encryptedSecretClient
                                                     App_ID:[userDefaultManager getAppID]
                                                 Country_ID:_country_id DeviceID:deviceId];
    if (params) {
        API_Auth_RegisterCallSupport * api = [[API_Auth_RegisterCallSupport alloc]initWithParams:params];
        [api request:^(BaseJSON * json, RestfulResponse * data) {
            if (data.status) {
                iCallSupportCount++;
                //        [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(enableResendButton) userInfo:nil repeats:FALSE];
            }else{
                [AppHelper showMessageBox:nil message:data.message];
            }
        } ErrorHandlure:^(NSError * error) {
            
        }];
    }

}

- (IBAction)btnResendCode_Pressed:(id)sender {
//    [spinner startAnimating];
    [_btnFreeSMS setStatusEnable:NO];
    [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(enableResendButton) userInfo:nil repeats:FALSE];
    [_lblError setText:NSLocalizedString(@"Please wait up for 1 min",nil)];
    
    NSString *secretClient = [userDefaultManager generateSecretClient];
    NSString *userpass = [userDefaultManager getUserPass];
    NSString *encryptedSecretClient = [userDefaultManager encryptDESByKey:[userDefaultManager getAppKey] data:secretClient iv:[userDefaultManager getAppSecret]];
    NSString *encryptedCridential = [userDefaultManager encryptDESByKey:[userDefaultManager getAppKey] data:userpass iv:secretClient];
    NSString * deviceId = [userDefaultManager getDeviceToken];
    
    sendcode *params = [[sendcode alloc] initWithCredential:encryptedCridential
                                              Secret_Client:encryptedSecretClient
                                                     App_ID:[userDefaultManager getAppID]
                                                 Country_ID:_country_id DeviceID:deviceId];
    if (params) {
        API_Auth_RegisterSendCode * api = [[API_Auth_RegisterSendCode alloc] initWithParams:params];
        [api request:^(BaseJSON * json, RestfulResponse * data) {
            if (data.status){
                
            }else{
                
                [AppHelper showMessageBox:nil message:data.message];
            }
        } ErrorHandlure:^(NSError * error) {
            [_btnFreeCall setStatusEnable:YES];
            [_btnFreeSMS setStatusEnable:YES];
        }];
    }

}


#pragma mark - Handle Show/Hide Keyboard
- (void)keyboardWillShow:(NSNotification *) notif
{
    NSDictionary *userInfo = [notif userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGFloat yFrame = self.view.bounds.size.height - (_btnFreeCall.frame.origin.y + _btnFreeCall.bounds.size.height + 5);
    CGFloat offSet = yFrame - kbSize.height;
    
    if (offSet < 0) {
        [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
            self.view.frame = CGRectMake(0, offSet, self.view.bounds.size.width, self.view.bounds.size.height);
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *) notif
{
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = frame;
    }];
}

#pragma mark - TextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *text = [textField.text stringByReplacingCharactersInRange:range
                                                             withString:string];
    for (int i =0 ; i < [self.imgdotList count]; i++)
    {
        if(i < [text length])
        {
            [self.imgdotList[i] setHidden:YES];
            if([[self.lblCodeList[i] text] isEqualToString:@""])
            {
                [self.lblCodeList[i] setText:string];
                NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[self.lblCodeList[i] text]];
                [attributeString addAttribute:NSUnderlineStyleAttributeName
                                        value:[NSNumber numberWithInt:1]
                                        range:(NSRange){0,[attributeString length]}];
                [self.lblCodeList[i] setAttributedText:attributeString];
            }
        }
        else
        {
            [self.imgdotList[i] setHidden:NO];
            [self.lblCodeList[i] setText:@""];
        }
    }
    return [text length] <= 4;
}



@end
