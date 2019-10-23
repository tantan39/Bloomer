//
//  SettingsAccountViewController.h
//  Xinh
//
//  Created by Truong Thuan Tai on 12/12/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsProfileTableViewCell.h"
#import "auth_logout_using.h"
#import "out_auth_logout.h"
#import "MainViewController.h"
#import "UserDefaultManager.h"
#import "out_profile_fetch.h"

@interface SettingsAccountViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, auth_logoutDelegate>
- (IBAction)touchLogOutButton:(id)sender;

@end
