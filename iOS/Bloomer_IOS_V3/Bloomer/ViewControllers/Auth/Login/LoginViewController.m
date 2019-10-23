//
//  LoginViewController.m
//  Bloomer
//
//  Created by Phan Van Thanh Dat on 10/16/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "LoginViewController.h"

#import "API_GetCountries.h"
#import "ForgotPasswordViewController.h"
#import "ForgotPasswordViewController.h"

#define CODE_FB_NOT_EXIST 488

@interface LoginViewController (){
    UserDefaultManager * userDefaultManager;
    NSInteger country_id;
    CountryPickerView *pickerView;
    NSMutableArray * countryList;
    Spinner * spinner;
    FBSDKLoginManager * loginManager;
    BOOL isFirstLoad;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUp];
    country_id = [BloomerManager shareInstance].countryID;
    userDefaultManager = [[UserDefaultManager alloc] init];
    loginManager = [[FBSDKLoginManager alloc] init];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    countryList = [BloomerManager shareInstance].listCountry;
    [self setCountryBaseOnLocation];
    spinner = [(AppDelegate *)[[UIApplication sharedApplication] delegate] spinner];
    isFirstLoad = TRUE;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [AppHelper changeNavigationBarToClearColor:self.navigationController];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self setColorStatusBar:[UIColor whiteColor]];

   
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (isFirstLoad) {
        [self.tfPhoneNumber becomeFirstResponder];
        isFirstLoad = FALSE;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [self setColorStatusBar:[UIColor clearColor]];
}

- (void) setUp {
    
    self.labelTitle.text = [AppHelper getLocalizedString:@"login.titleLabel"];
    [self.btnSignIn setTitle:[AppHelper getLocalizedString: @"Sign In"] forState:UIControlStateNormal];
    [self.tfPhoneNumber setPlaceholder: [AppHelper getLocalizedString:@"signIn.placeholderInputPhoneTextfield"]];
    [self.btnShow setTitle: [AppHelper getLocalizedString:@"login.showPasswordButton"] forState:UIControlStateNormal];
    [self.btnSignIn.layer setCornerRadius:4];
    
    NSDictionary *dictUnderLine = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle), };
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:[AppHelper getLocalizedString:@"login.forgotPasswordButton"] attributes:dictUnderLine]];

    [self.btnForgotPassword setAttributedTitle:attString forState:UIControlStateNormal];

    NSString *string =[NSString stringWithFormat:[AppHelper getLocalizedString: @"login.createPasswordLabel"], [AppHelper getLocalizedString:@"login.clickCreatePassword"]];
    
    self.lBnewPassword.text = string;
    
    self.labelNewPassword.text = string;
    
    
    NSRange range = [self.labelNewPassword.text rangeOfString:[AppHelper getLocalizedString:@"login.clickCreatePassword"]];
    
    [self.labelNewPassword addTapActionWithRange:range withActionBlock:^{
        [self btnForgotTapper: self];

    }];

    NSString *stringPolicy = [NSString stringWithFormat:[AppHelper getLocalizedString: @"login.policyAndTermsLabel"], [AppHelper getLocalizedString:@"login.policy"], [AppHelper getLocalizedString:@"login.terms"]];
    
    self.lBpolicy.text =stringPolicy;
    
    self.labelPolicyAndTerms.text = stringPolicy;
    
    
    NSRange rangePolicy = [self.labelPolicyAndTerms.text rangeOfString:[AppHelper getLocalizedString:@"login.policy"]];
    
    [self.labelPolicyAndTerms addTapActionWithRange:rangePolicy withActionBlock:^{
        [self btnPrivacy_Pressed:self];
    }];
    
    
    NSRange rangeTems = [self.labelPolicyAndTerms.text rangeOfString:[AppHelper getLocalizedString:@"login.terms"]];
    
    [self.labelPolicyAndTerms addTapActionWithRange:rangeTems withActionBlock:^{
        [self btnTermsService_Pressed:self];
        
    }];
    
    [self.tfPhoneNumber setLeftViewWithImage:[UIImage imageNamed:@"icoPhone"]];
    [self.tfPhoneNumber setIsPhoneNumberField:YES];
    [self.tfPassword setLeftViewWithImage:[UIImage imageNamed:@"icoPassword"]];
    [self.btnSignIn setStatusEnable:NO];
}

- (void) showAlert: (NSString*) message {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:message
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        //Add Buttons
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle: [AppHelper getLocalizedString: @"Sign Up"]
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        SignUpVC * signUpVC = [[SignUpVC alloc] initWithNibName:@"SignUpVC" bundle:nil];
                                        [self.navigationController pushViewController:signUpVC animated:true];
                                    }];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:[AppHelper getLocalizedString:@"CancelPopupRace.title"]
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction * action) {
                                       
                                   }];
        
        //Add your buttons to alert controller
        
        [alert addAction:yesButton];
        [alert addAction:noButton];
        
        [self presentViewController:alert animated:YES completion:nil];

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)btnBack_Pressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)textFieldPassword_EditChange:(id)sender {
   if (self.tfPhoneNumber.text.length > 0 && self.tfPassword.text.length > 0) {
       [self.btnSignIn setStatusEnable: YES];
   } else {
       [self.btnSignIn setStatusEnable:NO];
   }
    [(MFTextField*)(sender) setError:@"" animated:NO];

}

- (IBAction)btnShowHidePass_Pressed:(id)sender {
    if (!self.tfPassword.secureTextEntry) {
        [self.btnShow setTitle: [AppHelper getLocalizedString: @"login.showPasswordButton"] forState:UIControlStateNormal];
    } else {
        [self.btnShow setTitle: [AppHelper getLocalizedString: @"login.hidenPassword"] forState:UIControlStateNormal];
    }
    self.tfPassword.secureTextEntry = !self.tfPassword.secureTextEntry;
}

- (IBAction)btnCountryCode_Pressed:(id)sender {
    
    [self.view endEditing:YES];
    if (countryList) {
        pickerView = [[CountryPickerView alloc] initWithFrame:self.view.bounds];
        pickerView.countryList = countryList;
        pickerView.delegate = self;
        [self.view addSubview:pickerView];
    }
    
}
- (IBAction)btnForgotTapper:(id)sender {
    ForgotPasswordViewController *view = [[ForgotPasswordViewController alloc] initWithNibName: [AppHelper getScreenNameView: @"ForgotPasswordViewController"] bundle:nil];
    [self.navigationController pushViewController:view animated:TRUE];
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

- (BOOL) isvalidate {
    BOOL isValidate = TRUE;
    if ([self.tfPhoneNumber.text isEqualToString:@""]) {
        [self.tfPhoneNumber setError:NSLocalizedString(@"signIn.inputPhoneEmpty",nil) animated:YES];
        isValidate = FALSE;
    }
    if (![self.tfPhoneNumber validatePhoneNumber]) {
        [self.tfPhoneNumber setError:NSLocalizedString(@"signIn.inputPhoneError",nil) animated:YES];
        isValidate = FALSE;
    }
    
    if (self.tfPassword.text.length == 0) {
        [self.tfPassword setError: [AppHelper getLocalizedString:@"signIn.inputPasswordEmpty"] animated:YES];
        isValidate = FALSE;
    }
    
    if (![self.tfPassword validatePassword]) {
        [self.tfPassword setError: [AppHelper getLocalizedString:@"signIn.inputPasswordErrorFormat"] animated:YES];
        isValidate = FALSE;
    }
    return isValidate;
}
- (IBAction)btnNext_Pressed:(id)sender {
    [self.view endEditing:YES];
    if (![self isvalidate]) {
        return;
    }
    
    NSString * phoneNumb = [self.tfPhoneNumber.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    phoneNumb = [[phoneNumb componentsSeparatedByCharactersInSet:
                  [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                 componentsJoinedByString:@""];
    
    NSString *pass = [NSString md5:self.tfPassword.text];
    NSString *secretClient = [userDefaultManager generateSecretClient];
    NSString *userpass = [NSString stringWithFormat:@"%@+|+%@", phoneNumb, pass];
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
                [[BloomerManager shareInstance] setAuthenType:Via_PHONENUMBER];
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

- (IBAction)btnGoWithFB_Pressed:(id)sender {
    [self.view endEditing:TRUE];
    if([FBSDKAccessToken currentAccessToken]) {
        [loginManager logOut];
    }
    [loginManager logInWithReadPermissions:@[@"public_profile",@"email",@"user_link"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            [AppHelper showMessageBox:nil message:error.localizedDescription];
        } else if (result.isCancelled) {
            NSLog(@"%@", @"User cancelled.");
        } else {
            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields" : @"id,link,gender,name,email,picture.height(750).width(750)"}] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    Auth_FBRegisterParams * object = [[Auth_FBRegisterParams alloc] initWithJSON:result];
                    [[BloomerManager shareInstance] setAuth_FBRegister:object];
                    if (object) {
                        [self requestCheckFBExitsWithFBToken:[[FBSDKAccessToken currentAccessToken] tokenString]];
                    }
                }
            }];
        }
    }];
}

- (void) requestCheckFBExitsWithFBToken:(NSString *) fbToken{
    if (fbToken) {
        CheckFBExistParams * params = [[CheckFBExistParams alloc] initWithFBToken:fbToken device_id:[userDefaultManager getDeviceToken] app_id:[userDefaultManager getAppID] notification_token:[userDefaultManager getNotificationToken]];
        if (params) {
            [spinner startAnimating];
            API_CheckFBExist * api = [[API_CheckFBExist alloc] initWithParams:params];
            [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                
                JSON_CheckFBExist * data = (JSON_CheckFBExist *) jsonObject;
                if (response.status) {
                    [[BloomerManager shareInstance] setAuthenType:Via_FACEBOOK];
                    out_auth_authorize * object = data.user;
                    [userDefaultManager saveAccessToken:object.access_token];
                    [userDefaultManager saveRefresh_Token:object.refresh_token];
                    [userDefaultManager getUserProfileData].gender = object.gender;
                    [userDefaultManager saveCredentialEjab:[userDefaultManager decryptDESByKey:[userDefaultManager getAppKey] data:object.cridential_ejab iv:[userDefaultManager getAppSecret]]];
                    [userDefaultManager setDidPostDailyLocalNotification:false];
                    [LocalNotificationHelper removeAllLocalNotifications];
                        
                    [self requestGetProfileMeWith:object.access_token DeviceToken:[userDefaultManager getDeviceToken]];
                    
                    [spinner stopAnimating];
                } else {
                    [spinner stopAnimating];
                    if (response.code == CODE_FB_NOT_EXIST) {
                        [self showAlert: response.message];
                    } else {
                        [AppHelper showMessageBox:nil message:response.message];
                    }
                }
            } ErrorHandlure:^(NSError *error) {
                [spinner stopAnimating];
            }];
        }
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
                [view setSelectedIndex:3];
                [self.navigationController pushViewController:view animated:TRUE];
            }else{
                [AppHelper showMessageBox:[AppHelper getLocalizedString:@"Alert.Title.ErrorMessage"] message:objStatus.message];
            }
        } ErrorHandlure:^(NSError * error) {
            [spinner stopAnimating];
        }];
    }
}

- (void) checkPasswordWithPhone:(NSString *) phoneNumb CountryID:(NSInteger) countryID{
    API_Auth_CheckPassword * api = [[API_Auth_CheckPassword alloc] initWithPhoneNumb:phoneNumb AppID:[userDefaultManager getAppID] CountryID:country_id];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        JSON_CheckPassword * data = (JSON_CheckPassword *) jsonObject;
        if (response.status) {
            if (data.check_pass_user) {
                EnterPasswordViewController * enterPassVC = [[EnterPasswordViewController alloc] initWithNibName:@"EnterPasswordViewController" bundle:nil];
                enterPassVC.phoneNumber = phoneNumb;
                enterPassVC.fbToken = [[FBSDKAccessToken currentAccessToken] tokenString];
                [self.navigationController pushViewController:enterPassVC animated:true];
            }else{
                [self navigateToVerifyVCWithPhone:phoneNumb CountryID:country_id signup:NO];
            }
        }else{
            [AppHelper showMessageBox:nil message:response.message];
        }
    } ErrorHandlure:^(NSError *error) {
        
    }];
}

- (void) navigateToVerifyVCWithPhone:(NSString *) phone CountryID:(NSInteger ) countryID signup:(BOOL)isSignup{
    if(isSignup) {
        API_GetVerifyCode * api = [[API_GetVerifyCode alloc] initWithPhoneNumb:self.tfPhoneNumber.text CountryID:country_id DeviceID:[userDefaultManager getDeviceToken]];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            JSON_GetVerifyCode * data = (JSON_GetVerifyCode* ) jsonObject;
            if (!response.status) {
                [AppHelper showMessageBox:nil message:response.message];
            }else{
                [userDefaultManager saveM_ID:data.m_id];
                ConfirmationViewController * confirmVC = [[ConfirmationViewController alloc] initWithNibName:@"ConfirmationViewController" bundle:nil];
                confirmVC.phoneNumber = phone;
                confirmVC.country_id = countryID;
                confirmVC.isSignUp = YES;
                [self.navigationController pushViewController:confirmVC animated:NO];
            }
        } ErrorHandlure:^(NSError *error) {
        }];
    } else {
        ConfirmationViewController * confirmVC = [[ConfirmationViewController alloc] initWithNibName:@"ConfirmationViewController" bundle:nil];
        confirmVC.phoneNumber = phone;
        confirmVC.country_id = countryID;
        [self.navigationController pushViewController:confirmVC animated:NO];
    }
}

-(void)setCountryBaseOnLocation {
    Country* country = nil;
    for (int i = 0; i < countryList.count; i++) {
        Country* tmp = (Country*)[countryList objectAtIndex:i];
        NSString* currentCountryCode = [[LocationManager sharedInstance] getCountryCode];
        if([currentCountryCode isEqualToString:tmp.countryShortName]) {
            country = tmp;
        }
    }
    if(country) {
        [self didSelectCountry:country];
    }
}

#pragma mark CountryPickerDelegate

- (void)didSelectCountry:(Country *)country{
    country_id = country.countryID;
    [[BloomerManager shareInstance] setCountryID:country.countryID];
    [[BloomerManager shareInstance] setCountry_short_name:country.countryShortName];
    _lblCountryCode.text = country.countryCode;
    if ([country.countryFlag isKindOfClass:NSString.class]) {
//        [_countryFlagButton setImageWithURL:[NSURL URLWithString:country.countryFlag] forState:UIControlStateNormal];
    }
}

#pragma mark - Handle Show/Hide Keyboard
- (void)keyboardWillShow:(NSNotification *) notif
{
    if ([AppHelper isIP5AndIP4]) {
        return;
    }
    
    NSDictionary *userInfo = [notif userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGFloat yFrame = self.view.bounds.size.height - (self.viewParentBtnSignIn.frame.origin.y + self.btnSignIn.frame.origin.y + self.btnSignIn.bounds.size.height + 5);

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
    frame.origin.y = 0;
    
    [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.frame = frame;
    }];
}

-(void) setColorStatusBar: (UIColor*) color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        
        statusBar.backgroundColor = color;//set whatever color you like
    }
}
@end
