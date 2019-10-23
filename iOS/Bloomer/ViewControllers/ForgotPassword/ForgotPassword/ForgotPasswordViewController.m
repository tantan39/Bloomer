//
//  ForgotPasswordViewController.m
//  Bloomer
//
//  Created by Phan Van Thanh Dat on 10/16/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "API_GetCountries.h"
#import "out_account_forget_who.h"

@interface ForgotPasswordViewController (){
    UserDefaultManager * userDefaultManager;
    NSInteger country_id;
    CountryPickerView *pickerView;
    NSMutableArray * countryList;
}

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[BloomerManager shareInstance] setCountryID:1];
    country_id = [BloomerManager shareInstance].countryID;
    userDefaultManager = [[UserDefaultManager alloc] init];
    [self.btnNext setStatusEnable:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.tfPhoneNumber becomeFirstResponder];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    countryList = [BloomerManager shareInstance].listCountry;
    [self setCountryBaseOnLocation];
    [self setUp];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [AppHelper changeNavigationBarToWhite:self.navigationController];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void) setUp {
    self.labelTitle.text = [AppHelper getLocalizedString: @"inputPhoneForgot.tileLabel"];
    [self.btnNext setTitle: [AppHelper getLocalizedString:@"inputPhoneForgot.tileContinueBtn"] forState:UIControlStateNormal];
    [self.btnNext.layer setCornerRadius: 4];
    [self.tfPhoneNumber setPlaceholder: [AppHelper getLocalizedString:@"signIn.placeholderInputPhoneTextfield"]];
    
    [self.tfPhoneNumber setLeftViewWithImage:[UIImage imageNamed:@"icoPhone"]];
    [self.tfPhoneNumber setIsPhoneNumberField:YES];

}

- (IBAction)didChangePhoneNumber:(id)sender {
    if (![_tfPhoneNumber.text isEqual: @""] ) {
        [_btnNext setStatusEnable:YES];
    } else {
        [_btnNext setStatusEnable:NO];
    }
    [self.tfPhoneNumber setError:@"" animated:NO];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (IBAction)touchView:(id)sender {
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


- (IBAction)btnNext_Pressed:(id)sender {
    [self.view endEditing:TRUE];
    NSString * phoneNumb = [self.tfPhoneNumber.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    phoneNumb = [[phoneNumb componentsSeparatedByCharactersInSet:
                  [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                 componentsJoinedByString:@""];
    
    if (![self.tfPhoneNumber.text isEqualToString:@""]) {
        if ([self.tfPhoneNumber validatePhoneNumber]) {
            account_forget_who *params = [[account_forget_who alloc] initWithField:phoneNumb countryCode:[BloomerManager shareInstance].countryID];//VL-NOTEs country code is not safe.
            if (params) {
                API_Account_ForgetWho *forgetWhoAPI = [[API_Account_ForgetWho alloc] initWithParams:params];
                [forgetWhoAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
                    //    [spinner stopAnimating];
                    if (response.status)
                    {
                        out_account_forget_who *json = (out_account_forget_who*)jsonObject;
                        if(json) {
                            ResetPasswordVerifyCodeViewController * resetPassVC = [[ResetPasswordVerifyCodeViewController alloc] initWithNibName: [AppHelper getScreenNameView:@"ResetPasswordVerifyCodeViewController"] bundle:nil];
                            resetPassVC.f_id = json.f_id;
                            
                            resetPassVC.phoneNumber = phoneNumb;
                            [self.navigationController pushViewController:resetPassVC animated:YES];
                        }
                    }else
                    {
                        [self.tfPhoneNumber setError:response.message animated:YES];
                    }
                } ErrorHandlure:^(NSError *error) {
                    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
                    [self.tfPhoneNumber setError:@""animated:YES];
                }];
            }
        } else {
            [self.tfPhoneNumber setError:NSLocalizedString(@"signIn.inputPhoneError",nil) animated:YES];
        }
    }else{
        [self.tfPhoneNumber setError:NSLocalizedString(@"signIn.inputPhoneEmpty",nil) animated:YES];
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
                [self navigateToVerifyVCWithPhone:phoneNumb CountryID:country_id forgot:NO];
            }
        }else{
            [AppHelper showMessageBox:nil message:response.message];
        }
    } ErrorHandlure:^(NSError *error) {
        
    }];
}

- (void) navigateToVerifyVCWithPhone:(NSString *) phone CountryID:(NSInteger ) countryID forgot:(BOOL)isForgot{
        API_GetVerifyCode * api = [[API_GetVerifyCode alloc] initWithPhoneNumb:self.tfPhoneNumber.text CountryID:country_id DeviceID:[userDefaultManager getDeviceToken]];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            JSON_GetVerifyCode * data = (JSON_GetVerifyCode* ) jsonObject;
            if (!response.status) {
                [self.tfPhoneNumber setError:response.message animated:YES];
                [AppHelper showMessageBox:nil message:response.message];
            }else{
                [userDefaultManager saveM_ID:data.m_id];
                
                ResetPasswordVerifyCodeViewController * resetPassVC = [[ResetPasswordVerifyCodeViewController alloc] initWithNibName:[AppHelper getScreenNameView:@"ResetPasswordVerifyCodeViewController"] bundle:nil];
                
                resetPassVC.phoneNumber = self.tfPhoneNumber.text;
                [self.navigationController pushViewController:resetPassVC animated:YES];
            }
        } ErrorHandlure:^(NSError *error) {
        }];
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
    frame.origin.y = self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;;
    
    [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.frame = frame;
    }];
}

@end
