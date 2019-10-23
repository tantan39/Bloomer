//
//  ChangeGenderViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/28/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "ChangesGenderViewController.h"

@interface ChangesGenderViewController () {
    UserDefaultManager *userDefaultManager;
    out_profile_fetch *profileData;
}

@end

@implementation ChangesGenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    userDefaultManager = [[UserDefaultManager alloc] init];
    
    if ([userDefaultManager getGender] == 0) {
        [_genderLabel setText:NSLocalizedString(@"MALE", nil) ];
        _gender = MALE;
    } else {
        [_genderLabel setText:NSLocalizedString(@"FEMALE",nil)];
        _gender = FEMALE;
    }
    [self initNavigationBar];
}

- (void) initNavigationBar {
    [AppHelper setTitleViewForNavigationBar:self.navigationItem title:NSLocalizedString(@"Change Gender", nil)];
}

- (IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchChange:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Are you sure that you want to change gender?",)
                                                                   message:NSLocalizedString(@"Your received flowers will be reset to 0.",)
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"CancelPopupRace.title",) style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Yes",) style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                genders *param = [[genders alloc] initWithAccess_Token:[userDefaultManager getAccessToken]
                                                                                          device_token:[userDefaultManager getDeviceToken]
                                                                                                gender:self.gender];
                                                if (param) {
                                                    API_Profile_ChangingGender *api = [[API_Profile_ChangingGender alloc] initWithParams:param];
                                                    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                                                        if (response.status) {
                                                            [userDefaultManager saveGender:self.gender];
                                                            [self.navigationController popViewControllerAnimated:true];
                                                            
                                                        } else {
                                                            [AppHelper showMessageBox:nil message:response.message];
                                                        }
                                                    } ErrorHandlure:^(NSError *error) {
                                                    }];
                                                }
                                            }]];
    [self presentViewController:alert animated:true completion:nil];
}

- (IBAction)touchTermsOfUse:(id)sender {
    TermAndPolicyViewController *view = [[TermAndPolicyViewController alloc] initWithNibName:@"TermAndPolicyViewController" bundle:nil];
    view.urlString = [APIDefine termsOfUseLink];
    view.isTerm = YES;
    [self.view endEditing:TRUE];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    [self.navigationController pushViewController:view animated:TRUE];
}

- (IBAction)touchPrivacyPolicy:(id)sender {
    TermAndPolicyViewController *view = [[TermAndPolicyViewController alloc] initWithNibName:@"TermAndPolicyViewController" bundle:nil];
    view.urlString = [APIDefine privacyPolicyLink];
    view.isTerm = NO;
    [self.view endEditing:TRUE];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    [self.navigationController pushViewController:view animated:TRUE];
}

@end
