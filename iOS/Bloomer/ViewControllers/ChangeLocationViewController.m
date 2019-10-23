//
//  ChangeLocationViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/27/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "ChangeLocationViewController.h"

@interface ChangeLocationViewController () {
    UserDefaultManager *userDefaultManager;
}

@end

@implementation ChangeLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:NO];
    userDefaultManager = [[UserDefaultManager alloc] init];
    
    _locationName.text = _locationReceived;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchChange:(id)sender {
    location *param = [[location alloc] initWithAccess_Token:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] locationID:_locationID];
    if (param) {
        API_Profile_Location *api = [[API_Profile_Location alloc] initWithParams:param];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            if (response.status) {
                EditProfileViewController *view = (EditProfileViewController *)_parentView;
                [view loadProfileMeUsingAPI];
                
                [self.navigationController popToViewController:_parentView animated:YES];
            } else {
                [AppHelper showMessageBox:nil message:response.message];
            }
        } ErrorHandlure:^(NSError *error) {
            
        }];
    }
    

}

@end
