//
//  InputPhoneVC.m
//  Bloomer
//
//  Created by Tran Thai Tan on 11/28/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "SignUpVC.h"
#import "API_GetCountries.h"

@interface SignUpVC (){
    UserDefaultManager * userDefaultManager;
    NSInteger country_id;
    CountryPickerView *pickerView;
    NSMutableArray * countryList;
    NSInteger gender;
    BOOL isFistLoad;
}

@end

@implementation SignUpVC

- (instancetype)init{
    self = [super init];
    if (self) {
        NSString * nibName = IS_IPHONE_5 ? @"SignUpVC_IP5" : @"SignUpVC";
        self = [[SignUpVC alloc] initWithNibName:nibName bundle:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[BloomerManager shareInstance] setCountryID:1];
    country_id = [BloomerManager shareInstance].countryID;
    userDefaultManager = [[UserDefaultManager alloc] init];
    self.btnNext.layer.cornerRadius = 4.0f;
    [self.btnNext setStatusEnable:NO];
    
    [self.tfName setLeftViewWithImage:[UIImage imageNamed:@"icoName"]];
    [self.tfPhoneNumber setLeftViewWithImage:[UIImage imageNamed:@"icoPhone"]];
    [self.tfPhoneNumber setIsPhoneNumberField:YES];
    [self.tfEmail setLeftViewWithImage:[UIImage imageNamed:@"icoEmail"]];
    [self.tfPassword setLeftViewWithImage:[UIImage imageNamed:@"icoPassword"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    countryList = [BloomerManager shareInstance].listCountry;
    [self setCountryBaseOnLocation];

    gender = 0;
    [self setUpView];
    isFistLoad = TRUE;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [AppHelper changeNavigationBarToWhite:self.navigationController];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
}
- (void) viewDidAppear:(BOOL)animate {
    [super viewDidAppear:animate];
    if (isFistLoad) {
        [self.tfName becomeFirstResponder];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void) setUpView {
    NSString *stringPolicy = [NSString stringWithFormat:[AppHelper getLocalizedString: @"signUp.policyAndTermsLabel"], [AppHelper getLocalizedString:@"login.policy"], [AppHelper getLocalizedString:@"login.terms"]];
    
    self.labelPolicyAndTerms.text =stringPolicy;
    
    self.tvPolicyAndTerms.text = stringPolicy;
    
    
    NSRange rangePolicy = [self.tvPolicyAndTerms.text rangeOfString:[AppHelper getLocalizedString:@"login.policy"]];
    
    [self.tvPolicyAndTerms addTapActionWithRange:rangePolicy withActionBlock:^{
        [self btnPrivacy_Pressed:self];
    }];
    
    
    NSRange rangeTems = [self.tvPolicyAndTerms.text rangeOfString:[AppHelper getLocalizedString:@"login.terms"]];
    
    [self.tvPolicyAndTerms addTapActionWithRange:rangeTems withActionBlock:^{
        [self btnTermsService_Pressed:self];
        
    }];
}
- (IBAction) didChange_GenderValue:(id) sender {
    gender = [self.genderSwitchControl selectedIndex];
}

- (IBAction)btnShowHidePass_Pressed:(id)sender {
    if (!self.tfPassword.secureTextEntry) {
        [self.btnShowPassword setTitle: [AppHelper getLocalizedString: @"login.showPasswordButton"] forState:UIControlStateNormal];
    } else {
        [self.btnShowPassword setTitle: [AppHelper getLocalizedString: @"login.hidenPassword"] forState:UIControlStateNormal];
    }
    self.tfPassword.secureTextEntry = !self.tfPassword.secureTextEntry;
    NSString * tmpString = self.tfPassword.text;
    self.tfPassword.text = @"";
    self.tfPassword.text = tmpString;
}

- (IBAction)didChangePhoneNumber:(id)sender {
    if (![_tfName.text isEqual: @""] && ![_tfPhoneNumber.text isEqual: @""] && ![_tfEmail.text isEqual: @""] && ![_tfPassword.text isEqual: @""]) {
        [_btnNext setStatusEnable:YES];
    } else {
        [_btnNext setStatusEnable:NO];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)btnBack_Pressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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


- (IBAction)btnNext_Pressed:(id)sender {
    [self.view endEditing:YES];
    
    if ([self.tfName validateDisplayName]) {
        [self.tfName hideValidateError];
        
        if ([self.tfPhoneNumber validatePhoneNumber]) {
            [self.tfPhoneNumber hideValidateError];
            
            if ([self.tfEmail validateEmail]) {
                [self.tfEmail hideValidateError];
                
                if ([self.tfPassword validatePassword]) {
                    [self.tfPassword hideValidateError];
                    //Validate success
                    
                }else{
                    //Password error
                    [self.tfPassword setError:[AppHelper getLocalizedString:@"signIn.inputPasswordErrorFormat"] animated:YES];
                    return;
                }
            }else{
                //Email error
                [self.tfEmail setError:[AppHelper getLocalizedString:@"InvalidEmail"] animated:YES];
                return;
            }
        }else{
            //Phone error
            [self.tfPhoneNumber setError:[AppHelper getLocalizedString:@"signIn.inputPhoneError"] animated:YES];
            return;
        }
    }else{
        //Name error
        [self.tfName setError:[AppHelper getLocalizedString:@"DisplaynameInvalid"] animated:YES];
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
    
    RegisterInfo * registerInfo = [[RegisterInfo alloc] initWithName:self.tfName.text SecretClient:encryptedSecretClient Credential:encryptedCridential DeviceID:[userDefaultManager getDeviceToken] Gender:gender CountryID:country_id AppID:[userDefaultManager getAppID] Email:self.tfEmail.text];
    
    API_Auth_RegisterInfo * api = [[API_Auth_RegisterInfo alloc] initWithRegisterInfo:registerInfo];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        if (response.status) {
//            JSON_Auth_RegisterInfo * object =(JSON_Auth_RegisterInfo *) jsonObject;
            [self navigateToVerifyVCWithPhone:phoneNumb CountryID:country_id signup:YES];

        }else{
            if (response.message) {
                [AppHelper showMessageBox:nil message:response.message];
            }

            if (response.nameError) {
                [self.tfName setError:response.nameError animated:YES];
            }

            if (response.phoneError) {
                [self.tfPhoneNumber setError:response.phoneError animated:YES];
            }

            if (response.emailError) {
                [self.tfEmail setError:response.emailError animated:YES];
            }

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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.tfName && textField.text.length + string.length > 20 && range.length == 0) {
        return NO;
    }else if (textField == self.tfPhoneNumber && textField.text.length + string.length > 11 && range.length == 0){
        return NO;
    }else if (textField == self.tfPassword && textField.text.length + string.length > 20 && range.length == 0){
        return NO;
    }
    return YES;
}

#pragma mark CountryPickerDelegate
- (void)didSelectCountry:(Country *)country{
    country_id = country.countryID;
    [[BloomerManager shareInstance] setCountryID:country.countryID];
    [[BloomerManager shareInstance] setCountry_short_name:country.countryShortName];
    _lblCountryCode.text = country.countryCode;
}

#pragma mark - Handle Show/Hide Keyboard
- (void)keyboardWillShow:(NSNotification *) notif
{
    NSDictionary *userInfo = [notif userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGFloat value = IS_IPHONE_5 ? (_tfPassword.frame.origin.y + _tfPassword.bounds.size.height) + 10: (_btnNext.frame.origin.y + _btnNext.bounds.size.height);
    
    CGFloat yFrame = self.navigationController.navigationBar.bounds.size.height + self.view.bounds.size.height - value;
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
    frame.origin.y = self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    
    [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.frame = frame;
    }];
}

@end
