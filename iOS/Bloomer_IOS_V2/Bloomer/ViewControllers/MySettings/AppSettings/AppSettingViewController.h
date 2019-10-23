//
//  AppSettingViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/30/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API_Notification_Setting.h"
#import "UserDefaultManager.h"

@interface AppSettingViewController : UIViewController

@property (assign, nonatomic) BOOL all;
@property (assign, nonatomic) BOOL chat;
@property (assign, nonatomic) BOOL race;
@property (assign, nonatomic) BOOL following;
@property (assign, nonatomic) BOOL follower;
@property (assign, nonatomic) BOOL app;
@property (weak, nonatomic) IBOutlet UISwitch *allSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *chatSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *raceSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *followingSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *followerSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *appSwitch;
- (IBAction)touchFollowing:(id)sender;
- (IBAction)touchFollower:(id)sender;

@end
