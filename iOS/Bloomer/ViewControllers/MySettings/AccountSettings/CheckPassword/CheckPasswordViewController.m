//
//  CheckPasswordViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/20/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "CheckPasswordViewController.h"

@interface CheckPasswordViewController () {
    UserDefaultManager *userDefaultManager;
    BOOL isShowPass;
    UIImage * imgShowPass, * imgHidePass;
}

@end

@implementation CheckPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    userDefaultManager = [[UserDefaultManager alloc] init];
    
    [_password setSecureTextEntry:TRUE];
    [self initNavigationBar];
    imgShowPass = [UIImage imageNamed:@"icon_eye"];
    imgHidePass = [UIImage imageNamed:@"icon_offeye"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [AppHelper changeNavigationBarToRed:self.navigationController];
    [_password becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (IBAction)showPassButton_Pressed:(id)sender {
    
    if (isShowPass) {
        isShowPass = NO;
        [_showPassButton setImage:imgShowPass forState:UIControlStateNormal];
        [_password setSecureTextEntry:YES];
    }else{
        isShowPass = YES;
        [_showPassButton setImage:imgHidePass forState:UIControlStateNormal];
        [_password setSecureTextEntry:NO];
    }
    [_password setFont:nil];
    [_password setFont:[UIFont systemFontOfSize:14]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavigationBar {
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done",nil) style:UIBarButtonItemStyleDone target:self action:@selector(touchDoneButton)];
    doneButton.tintColor = [UIColor whiteColor];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:doneButton, nil]];
}

- (void)touchDoneButton {
    if (![_password.text  isEqual: @""]) {
        NSString *userpass = [NSString md5:_password.text];
        NSString *secretClient = [userDefaultManager generateSecretClient];
        NSString *encryptedSecretClient = [userDefaultManager encryptDESByKey:[userDefaultManager getAppKey] data:secretClient iv:[userDefaultManager getAppSecret]];
        NSString *encryptedCridential = [userDefaultManager encryptDESByKey:[userDefaultManager getAppKey] data:userpass iv:secretClient];
        
        check_password *param = [[check_password alloc] initWithAccess_Token:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] secret_client:encryptedSecretClient credential:encryptedCridential];
        if (param) {
            API_CheckPassword *api = [[API_CheckPassword alloc] initWithParams:param];
            [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                if (response.status) {
                    if([_phoneNumber hasPrefix:@"0"]) {
                        _phoneNumber = [_phoneNumber substringFromIndex:1];
                    }
                    
                    mobile *mobileData = [[mobile alloc] initWithAccess_Token:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] mobile:_phoneNumber country_id:[[BloomerManager shareInstance] countryID]];
                    if (mobileData) {
                        API_Profile_ChangeMobile *api = [[API_Profile_ChangeMobile alloc] initWithParams:mobileData];
                        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                            if(response.status) {
                                
                                [userDefaultManager saveUserPass:[NSString stringWithFormat:@"%@+|+%@", [NSString stringWithFormat:@"%@%@", @"0", _phoneNumber], _password.text]];
                                ConfirmationViewController *view = [[ConfirmationViewController alloc] initWithNibName:@"ConfirmationViewController" bundle:nil];
                                view.isMobileVerify = TRUE;
                                view.phoneNumber = _phoneNumber;
                                view.country_id = 1;
                                
                                [self.navigationController pushViewController:view animated:NO];
                            }else{
                                [AppHelper showMessageBox:nil message:response.message];
                            }
                        } ErrorHandlure:^(NSError *error) {
                            
                        }];

                    }

                } else {
                     [AppHelper showMessageBox:nil message:response.message];
                }
            } ErrorHandlure:^(NSError *error) {
                
            }];
        }
        

    } else {
        [AppHelper showMessageBox:nil message:NSLocalizedString(@"InvalidPassword", nil)];
    }
}



@end
