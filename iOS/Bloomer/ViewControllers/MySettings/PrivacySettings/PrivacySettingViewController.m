//
//  PrivacySettingViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/30/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "PrivacySettingViewController.h"
#import "AppHelper.h"

@interface PrivacySettingViewController () {
    UserDefaultManager *userDefaultManager;
}

@end

@implementation PrivacySettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    userDefaultManager = [[UserDefaultManager alloc] init];
    
    if (_share)
    {
        [_shareSwitch setOn:YES animated:YES];
    }
    else
    {
        [_shareSwitch setOn:NO animated:YES];
    }
    
    [self initNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupLanguage];
}

- (void) initNavigationBar
{
    [AppHelper setTitleViewForNavigationBar:self.navigationItem title:NSLocalizedString(@"Privacy Settings", nil)];
}

- (IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupLanguage
{
    self.labelSharePrivacy.text = [AppHelper getLocalizedString:@"AppSettings.sharePrivacy"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchShareSwitch:(id)sender {
    private_share *param;
    if (_shareSwitch.isOn) {
        param = [[private_share alloc] initWithAccess_Token:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] allow_share:TRUE];
    }
    else
    {
        param = [[private_share alloc] initWithAccess_Token:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] allow_share:FALSE];
    }
    
    if (param) {
        API_Private_ShareUpdate *api = [[API_Private_ShareUpdate alloc] initWithParams:param];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            if (!response.status)
            {
                [AppHelper showMessageBox:nil message:response.message];
            }
        } ErrorHandlure:^(NSError *error) {
            
        }];
    }
}

- (IBAction)touchBlockList:(id)sender {
    BlockListsViewController *view = [[BlockListsViewController alloc] initWithNibName:@"BlockListsViewController" bundle:nil];
    
    [self.navigationController pushViewController:view animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


@end
