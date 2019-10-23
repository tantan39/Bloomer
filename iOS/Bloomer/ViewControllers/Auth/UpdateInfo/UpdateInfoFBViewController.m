//
//  UpdateInfoFBViewController.m
//  Bloomer
//
//  Created by Phan Van Thanh Dat on 11/27/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "UpdateInfoFBViewController.h"

@interface UpdateInfoFBViewController () {
    Auth_FBRegisterParams * fbObject;
    UserDefaultManager * userDefaultManager;
    Spinner * spinner;
    NSInteger country_id;
    CGFloat contanBottomBtnDone;
}

@end

@implementation UpdateInfoFBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    userDefaultManager = [[UserDefaultManager alloc] init];
    spinner = [(AppDelegate *) [[UIApplication sharedApplication] delegate] spinner];
    
    [self setUp];
    fbObject = [[BloomerManager shareInstance] auth_FBRegister];
    [self configUIWithFBData:fbObject];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [AppHelper changeNavigationBarToWhite:self.navigationController];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void) setUp {
    
    self.labelTitle.text = [AppHelper getLocalizedString:@"updateInfoFB.labelHeader"];
    [self.doneBtn setTitle:[AppHelper getLocalizedString: @"updateInfoFB.titleDoneBtn"] forState:UIControlStateNormal];
    [self.nameTF setPlaceholder: [AppHelper getLocalizedString:@"updateInfoFB.placehodelNameTF"]];
    [self.doneBtn.layer setCornerRadius:4];
    
    NSString *stringPolicy = [NSString stringWithFormat:[AppHelper getLocalizedString: @"updateInfoFB.termsAndPolicyTv"], [AppHelper getLocalizedString:@"updateInfoFB.policy"], [AppHelper getLocalizedString:@"updateInfoFB.terms"]];
    
    self.policyLable.text = stringPolicy;
    
    self.policyTV.text = stringPolicy;
    
    
    NSRange rangePolicy = [self.policyTV.text rangeOfString:[AppHelper getLocalizedString:@"updateInfoFB.policy"]];
    
    [self.policyTV addTapActionWithRange:rangePolicy withActionBlock:^{
        [self btnPrivacy_Pressed:nil];
    }];
    
    
    NSRange rangeTems = [self.policyTV.text rangeOfString:[AppHelper getLocalizedString:@"updateInfoFB.terms"]];
    
    [self.policyTV addTapActionWithRange:rangeTems withActionBlock:^{
        [self btnTermsService_Pressed:nil];
        
    }];
    
    [self.nameTF setLeftViewWithImage:[UIImage imageNamed:@"icoName"]];
}

- (void) configUIWithFBData:(Auth_FBRegisterParams *) object{
    if (object) {
        NSString* name = object.fb_name;
        if(name.length > 20) {
            name = [name substringToIndex:20];
        }
        
        self.nameTF.text = name;
        [self.gender setSelectedIndex:object.fb_gender];
        
    }
    
}

- (void) presentEmailDucatiController: (NSString*) message {
    EmailDuplicateViewController * vc = [[EmailDuplicateViewController alloc] initWithNibName:@"EmailDuplicateViewController" bundle:nil];
    vc.navicontroller = self.navigationController;
    vc.message = message;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController: vc animated:true completion:^{
        [self.navigationController popViewControllerAnimated:FALSE];
    }];
}

- (IBAction)btnPrivacy_Pressed:(id)sender {
    TermAndPolicyViewController *view = [[TermAndPolicyViewController alloc] initWithNibName:@"TermAndPolicyViewController" bundle:nil];
    view.urlString = [APIDefine privacyPolicyLink];
    view.isTerm = NO;
    [self.view endEditing:TRUE];
    
    [self.navigationController pushViewController:view animated:TRUE];
}

- (IBAction)btnTermsService_Pressed:(id)sender {
    TermAndPolicyViewController *view = [[TermAndPolicyViewController alloc] initWithNibName:@"TermAndPolicyViewController" bundle:nil];
    view.urlString = [APIDefine termsOfUseLink];
    view.isTerm = YES;
    [self.view endEditing:TRUE];
    [self.navigationController pushViewController:view animated:TRUE];
}

- (IBAction)changeGender:(id)sender {
}
- (IBAction)textdidchangeTf:(id)sender {
    if ([self.nameTF.text isEqualToString:@""]) {
        [self.doneBtn setStatusEnable:NO];
    } else {
        [self.doneBtn setStatusEnable:YES];
    }
    
    [self.nameTF hideValidateError];
}
- (IBAction)touchBackground:(id)sender {
    [self.view endEditing:TRUE];
}

- (IBAction)touchDoneBtn:(id)sender {
    [self.view endEditing:TRUE];
    if ([self.nameTF validateDisplayName]) {
        [self.nameTF hideValidateError];
    } else {
        [self.nameTF setError:[AppHelper getLocalizedString:@"DisplaynameInvalid"] animated:YES];
        return;
    }
    if(!fbObject) {
        return;
    }
    
    [fbObject setFb_name: self.nameTF.text];
    [fbObject setCountryID:self.country_id];
    [fbObject setFb_gender: [self.gender selectedIndex]];
    [fbObject setNotification_token: [userDefaultManager getNotificationToken]];
    [fbObject setAppId: [userDefaultManager getAppID]];
    [self requestResgisterWithData: fbObject];
}

- (void) requestResgisterWithData:(Auth_FBRegisterParams *) params{
    if (params) {
        [spinner startAnimating];
        API_Auth_FBRegister * api = [[API_Auth_FBRegister alloc] initWithParams:params];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            out_auth_authorize * object = (out_auth_authorize *) jsonObject;
            if (response.status)
            {
                if (object.is_exist_email) {
                    [spinner stopAnimating];
                    [self presentEmailDucatiController: object.mobile];
                } else {
                    [userDefaultManager getUserProfileData].gender = params.fb_gender;
                    [userDefaultManager saveAccessToken:object.access_token];
                    [userDefaultManager saveRefresh_Token:object.refresh_token];
                    [userDefaultManager saveCredentialEjab:[userDefaultManager decryptDESByKey:[userDefaultManager getAppKey] data:object.cridential_ejab iv:[userDefaultManager getAppSecret]]];
                    [userDefaultManager setDidPostDailyLocalNotification:false];
                    [LocalNotificationHelper removeAllLocalNotifications];
                    [self requestGetProfileMeWith:object.access_token DeviceToken:[userDefaultManager getDeviceToken]];

                }
                
            } else {
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
                [[BloomerManager shareInstance] setAuthenType:Via_FACEBOOK];
                [userDefaultManager saveUserProfileData:data];
                [userDefaultManager removeM_ID];
                TabBarViewController *view = [[TabBarViewController alloc] initWithNibName:@"TabBarViewController" bundle:nil];
                [view setSelectedIndex:4];
                UINavigationController *nav = (UINavigationController*)[view.viewControllers objectAtIndex:4];
                MyProfileViewController *myProfileView = (MyProfileViewController*)[nav.viewControllers firstObject];
                [myProfileView showRemindInviteCodePopUpWith:data.invite_flower];

                [self.navigationController pushViewController:view animated:TRUE];
            }else{
                [spinner stopAnimating];
                [AppHelper showMessageBox:[AppHelper getLocalizedString:@"Alert.Title.ErrorMessage"] message:objStatus.message];
            }
        } ErrorHandlure:^(NSError * error) {
            [spinner stopAnimating];
        }];
    }
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

#pragma mark - Handle Show/Hide Keyboard
- (void)keyboardWillShow:(NSNotification *) notif
{
    if ([AppHelper isIP5AndIP4]) {
        return;
    }
    
    NSDictionary *userInfo = [notif userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGFloat yFrame = self.view.bounds.size.height - (self.doneBtn.frame.origin.y + self.doneBtn.bounds.size.height  - self.navigationController.navigationBar.bounds.size.height);
    
    CGFloat offSet = yFrame - kbSize.height;
    
    if (offSet < 0) {
        [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
            self.view.frame = CGRectMake(0, offSet, self.view.bounds.size.width, self.view.bounds.size.height);
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *) notif
{
    if ([AppHelper isIP5AndIP4]) {
        return;
    }
    
    NSDictionary *userInfo = [notif userInfo];
    CGRect frame = self.view.frame;
    frame.origin.y = self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    
    [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.frame = frame;
    }];
}

@end
