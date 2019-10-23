//
//  SelectCityViewController.m
//  Bloomer
//
//  Created by Thanh Tu Nguyen on 3/9/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "SelectCityViewController.h"
#import "SelectScreenViewController.h"

@interface SelectCityViewController ()
{
    UserDefaultManager *userDefaultManager;
    
}

@end

@implementation SelectCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    userDefaultManager = [[UserDefaultManager alloc] init];
    [_tittleSelectCity setText:NSLocalizedString(@"selectCity.tittle",nil)];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [_cityLabel1 setText:NSLocalizedString(@"citylabel1.title", nil)];
    [_cityLabel2 setText:NSLocalizedString(@"citylabel2.title", nil)];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if(self.complete) {
        self.complete();
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addLocation2:(id)sender {
    [self addLocation:2];
}
- (IBAction)addLocation1:(id)sender {
    [self addLocation:1];
}

-(void) addLocation:(NSInteger) location
{
//    [self.navigationController popViewControllerAnimated:YES];
    [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner startAnimating];
    inputAddLocation *param = [[inputAddLocation alloc] initWithLocation:location access_token:[userDefaultManager getAccessToken] device_id:[userDefaultManager getDeviceToken]];
    if (param) {
        API_Add_Location *api = [[API_Add_Location alloc] initWithParams:param];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
            if (!response.status) {
                [TTMessageView showMessageUnderNavBar:self Message:response.message];
            } else {
                [self loadProfileInfo];
            }
        } ErrorHandlure:^(NSError *error) {
            [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        }];
    }
}

- (void)loadProfileInfo
{
    API_Profile_Me * api = [[API_Profile_Me alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken]];
    [api getRequest:^(BaseJSON * json, RestfulResponse *objStatus) {
        out_profile_fetch * object = (out_profile_fetch *) json;
        if (objStatus.status)
        {
            [userDefaultManager saveUserProfileData:object];
        }
        [self.navigationController popViewControllerAnimated:YES];
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    } ErrorHandlure:^(NSError * error) {
        [self.navigationController popViewControllerAnimated:YES];
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];
}



@end
