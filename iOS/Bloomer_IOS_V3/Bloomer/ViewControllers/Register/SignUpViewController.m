//
//  SignUpViewController.m
//  Xinh
//
//  Created by Truong Thuan Tai on 11/19/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()
{
    UIView *notificationView;
    UserDefaultManager *userDefaultManager;
//    int gender;
    int country_id;
    UIImage * imgShowPass, * imgHidePass;
    BOOL isShowPass;
}
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_signUpButton setStatusEnable:NO];
    _countryCode = @"0";
    _countryShortName = NSLocalizedString(@"VN",);
    country_id = 1;
    
    [_signUpButton roundedBorderCornerForButton];
    
    imgShowPass = [UIImage imageNamed:@"icon_eye"];
    imgHidePass = [UIImage imageNamed:@"icon_offeye"];
    
    [_phoneView setDefaultBorder];
    [_phoneView roundedBorderCornerForTextField];
    
    [_password roundedBorderCornerForTextField];
     [_password addLeftPaddingView];
    [_password setDefaultBorder];
    
//    UITapGestureRecognizer *maleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchMaleView)];
//    [_maleView addGestureRecognizer:maleTap];
//    UITapGestureRecognizer *femaleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchFemaleView)];
//    [_femaleView addGestureRecognizer:femaleTap];
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    
//    [_phoneNumber addRegx:@"[A-Za-z0-9]{3,11}" withMsg:NSLocalizedString(@"Only alpha numeric characters are allowed.",)];
//    // Add regex for validating alpha numeric characters
//    [_password addRegx:@"[A-Za-z0-9]{6,20}" withMsg:NSLocalizedString(@"Password must contain alpha numeric characters or at least 6 characters",)];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.navigationController setNavigationBarHidden:TRUE];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_phoneNumber becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)didChangePhoneNumber:(id)sender {
    if (![_phoneNumber.text isEqual: @""] && ![_password.text isEqual: @""] /* && gender != 2 */) {
        [_signUpButton setStatusEnable:YES];
    } else {
        [_signUpButton setStatusEnable:NO];

    }
}

- (IBAction)didChangePassword:(id)sender {
    if (![_phoneNumber.text isEqual: @""] && ![_password.text isEqual: @""] /*&& gender != 2*/) {
        [_signUpButton setStatusEnable:YES];
    } else {
        [_signUpButton setStatusEnable:NO];

    }
}

- (IBAction)TouchBack:(id)sender {
    
    [[self navigationController] popViewControllerAnimated:YES];
    
}

- (IBAction)backgroundTap:(id)sender{
    
    [self.view endEditing:YES];
}

- (IBAction)touchLoginHyperlink:(id)sender {
    for (UIViewController *view in self.navigationController.viewControllers)
    {
        if ([view isKindOfClass:[LoginViewController class]])
        {
            [self.navigationController popToViewController:view animated:TRUE];
            return;
        }
    }
    
    LoginViewController *view;
//    
//    if (IS_IPHONE_5)
//    {
         view = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//    }
//    else
//        if (IS_IPHONE_4)
//        {
//            view = [[LoginViewController alloc] initWithNibName:@"LoginViewController_ip4" bundle:nil];
//        }

    [self.navigationController pushViewController:view animated:TRUE];
}

- (IBAction)touchTermsOfUse:(id)sender {
    TermAndPolicyViewController *view = [[TermAndPolicyViewController alloc] initWithNibName:@"TermAndPolicyViewController" bundle:nil];
    view.urlString = [APIDefine termsOfUseLink];
    view.isTerm = YES;
    [self.view endEditing:TRUE];
    [self.navigationController pushViewController:view animated:TRUE];
}
- (IBAction)touchPrivacyPolicy:(id)sender {
    TermAndPolicyViewController *view = [[TermAndPolicyViewController alloc] initWithNibName:@"TermAndPolicyViewController" bundle:nil];
    view.urlString = [APIDefine privacyPolicyLink];
    view.isTerm = NO;
    [self.view endEditing:TRUE];
    [self.navigationController pushViewController:view animated:TRUE];
}

- (IBAction)touchSignUpButton:(id)sender {
    [self.view endEditing:YES];
    if([_password validatePassword] && [_phoneNumber validate])
    {
        if (![_phoneNumber.text isEqual: @""] && ![_password.text  isEqual: @""] )
        {
            NSRange whiteSpaceRange = [_phoneNumber.text rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
            
            if (whiteSpaceRange.location != NSNotFound) {
//                [self displayErrorMessage:NSLocalizedString(@"Invalid phone number.",)];
                [AppHelper showMessageBox:nil message:NSLocalizedString(@"Invalid phone number.",)];
            } else {
                [_signUpButton setEnabled:FALSE];
                NSString *pass = [Support md5:_password.text];
                NSString *secretClient = [userDefaultManager generateSecretClient];
                //NSString *userpass = [NSString stringWithFormat:@"%@+|+%@", [NSString stringWithFormat:@"%@%@", _countryCode, _phoneNumber.text], _password.text];
                NSString *userpass = [NSString stringWithFormat:@"%@+|+%@", _phoneNumber.text, pass];
                NSString *encryptedSecretClient = [userDefaultManager encryptDESByKey:[userDefaultManager getAppKey] data:secretClient iv:[userDefaultManager getAppSecret]];
                NSString *encryptedCridential = [userDefaultManager encryptDESByKey:[userDefaultManager getAppKey] data:userpass iv:secretClient];
                NSString * deviceId = [userDefaultManager getDeviceToken];
                
                sendcode *params = [[sendcode alloc] initWithCredential:encryptedCridential Secret_Client:encryptedSecretClient App_ID:[userDefaultManager getAppID] Country_ID:country_id DeviceID:deviceId/*Gender:gender*/];
//                NSLog(@"SENDCODE: %@", [params createStringJSON]);
                
//                auth_register_sendcode_using *sendcodeAPI = [[auth_register_sendcode_using alloc] init];
//                [sendcodeAPI selectInput:params];
//                sendcodeAPI.myDelegate = self;
//                [sendcodeAPI connect];
                
                API_Auth_RegisterSendCode * api = [[API_Auth_RegisterSendCode alloc] initWithParams:params];
                [api postRequest:^(BaseJSON * json, RestfulResponse * data) {
                    out_auth_register_sendcode * object = (out_auth_register_sendcode *)json;
                    if (data.status){
                        [userDefaultManager saveM_ID:object.m_id];
                        [userDefaultManager saveUserPass:[NSString stringWithFormat:@"%@+|+%@", [NSString stringWithFormat:@"%@%@", _countryCode, _phoneNumber.text], _password.text]];
                        
                        ConfirmationViewController *view = [[ConfirmationViewController alloc] initWithNibName:@"ConfirmationViewController" bundle:nil];
                        view.country_id = country_id;
                        [view setPhoneNumber:[NSString stringWithFormat:@"%@", [_phoneNumber text]]];
                        [self.navigationController pushViewController:view animated:TRUE];
                        
                    }else{
                        [AppHelper showMessageBox:nil message:data.message];
                    }
                    
                    [_signUpButton setEnabled:TRUE];
                    
                } ErrorHandlure:^(NSError *error) {
                    
                }];
            }
        }
    }else{
         [AppHelper showMessageBox:nil message:NSLocalizedString(@"Invalid phone number.",)];
    }

}


- (IBAction)touchShowHidePasswordButton:(id)sender {
    if (!isShowPass){
        
        isShowPass = YES;
        [_showHidePasswordButton setImage:imgHidePass forState:UIControlStateNormal];
        [_password setSecureTextEntry:NO];
        
    }else{
        
        isShowPass = NO;
        [_showHidePasswordButton setImage:imgShowPass forState:UIControlStateNormal];
        [_password setSecureTextEntry:YES];
    }
    _password.font = nil;
    _password.font = _phoneNumber.font;
    
}


- (void)enableSignUpButton
{
    [_signUpButton setTitle:NSLocalizedString(@"Sign Up",) forState:UIControlStateNormal];
    [_signUpButton setEnabled:TRUE];
}

- (void)displayErrorMessage:(NSString*)message
{
    if (notificationView != nil)
    {
        [notificationView removeFromSuperview];
    }
    
    notificationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 50)];
    UILabel *errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -3, 250, 0)];
    errorLabel.text = message;
    [errorLabel setTextAlignment:NSTextAlignmentCenter];
    [errorLabel setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:15]];
    errorLabel.lineBreakMode = NSLineBreakByWordWrapping;
    errorLabel.numberOfLines = 0;
    [errorLabel setTextColor:[UIColor redColor]];
    
    CGSize maximumLabelSize = CGSizeMake(250, FLT_MAX);
    CGSize expectedLabelSize = [errorLabel.text sizeWithFont:errorLabel.font constrainedToSize:maximumLabelSize lineBreakMode:errorLabel.lineBreakMode];
    [errorLabel setFrame:CGRectMake(errorLabel.frame.origin.x, errorLabel.frame.origin.y, expectedLabelSize.width, expectedLabelSize.height)];
    
    [notificationView addSubview:errorLabel];
    [notificationView setFrame:CGRectMake(notificationView.frame.origin.x, notificationView.frame.origin.y, expectedLabelSize.width, expectedLabelSize.height)];
    
    if (IS_IPHONE_5)
        [notificationView setCenter: CGPointMake(self.view.frame.size.width / 2, 148)];
    else
        if (IS_IPHONE_4)
            [notificationView setCenter: CGPointMake(self.view.frame.size.width / 2, 180)];
    
    [self.view addSubview:notificationView];
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [textField resignFirstResponder];
//    return NO;
//}

#define MAX_LENGTH 20

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length >= MAX_LENGTH && range.length == 0)
    {
        return NO; // return NO to not change text
    }
    else
    {return YES;}
}

#pragma mark - Handle Show/Hide Keyboard
- (void)keyboardWillShow:(NSNotification *) notif{
    NSDictionary *userInfo = [notif userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGFloat yFrame = self.view.bounds.size.height - (_signUpButton.frame.origin.y + _signUpButton.bounds.size.height + 10);
    CGFloat offSet = yFrame - kbSize.height;
    
    if (offSet < 0) {
        [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
            self.view.frame = CGRectMake(0, offSet, self.view.bounds.size.width, self.view.bounds.size.height);
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *) notif{
    
    NSDictionary *userInfo = [notif userInfo];
    [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    }];
}

@end
