//
//  AppSettingViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/30/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "AppSettingViewController.h"
#import "Spinner.h"
#import "AppDelegate.h"

@interface AppSettingViewController () {
    UserDefaultManager *userDefaultManager;
    Spinner *spinner;
}

@end

@implementation AppSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    userDefaultManager = [[UserDefaultManager alloc] init];
    
    spinner = ((AppDelegate*)[UIApplication sharedApplication].delegate).spinner;
    
    [_chatSwitch setOn:_chat animated:YES];
    [_raceSwitch setOn:_race animated:YES];
    [_appSwitch setOn:_app animated:YES];
    [self validateAllButtonState];
    
    [self initNavigationBar];
}

- (void) initNavigationBar
{
    [AppHelper setTitleViewForNavigationBar:self.navigationItem title:NSLocalizedString(@"App Settings", nil)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchFollowing:(id)sender {
    if (_followingSwitch.isOn) {
        _following = TRUE;
    } else {
        _following = FALSE;
    }
}

- (IBAction)touchFollower:(id)sender {
    if (_followerSwitch.isOn) {
        _follower = TRUE;
    } else {
        _follower = FALSE;
    }
}

- (IBAction)touchSwitch:(UISwitch *)sender {
    if (sender == _chatSwitch) {
        _chat = _chatSwitch.isOn;
    } else if (sender == _raceSwitch) {
        _race = _raceSwitch.isOn;
    } else if (sender == _appSwitch) {
        _app = _appSwitch.isOn;
    } else {
        _chat = _race = _app = _allSwitch.isOn;
        [_chatSwitch setOn:_allSwitch.isOn animated:YES];
        [_raceSwitch setOn:_allSwitch.isOn animated:YES];
        [_appSwitch setOn:_allSwitch.isOn animated:YES];
    }
    [self validateAllButtonState];
    [self pushSetting];
}

-(void)validateAllButtonState {
    [_allSwitch setOn:_chatSwitch.isOn && _raceSwitch.isOn && _appSwitch.isOn animated:YES];
    _all = _allSwitch.isOn;
}

-(void)pushSetting {
    notification_setting *param = [[notification_setting alloc] initWithAccess_Token:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] notification:_all chat:_chat follow:_following flower:_follower app:_app race:_race];
    if (param) {
        [spinner startAnimating];
        API_Notification_Setting *api = [[API_Notification_Setting alloc] initWithParams:param];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            [spinner stopAnimating];
            if (response.status)
            {
                NSLog(@"qwerty");
            }
            else
            {
                [AppHelper showMessageBox:nil message:response.message];
            }
        } ErrorHandlure:^(NSError *error) {
            [spinner stopAnimating];
        }];
    }
}
@end
