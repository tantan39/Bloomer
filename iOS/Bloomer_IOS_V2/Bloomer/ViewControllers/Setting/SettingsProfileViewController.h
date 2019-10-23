//
//  SettingsProfileViewController.h
//  Xinh
//
//  Created by Truong Thuan Tai on 12/10/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsProfileTableViewCell.h"
#import "SettingsEditViewController.h"
#import "RaceViewController.h"
#import "SWRevealViewController.h"
#import "profile_update.h"
#import "profile_update_using.h"
#import "out_profile_update.h"
#import "profile_me_using.h"
#import "out_profile_fetch.h"
#import "UserDefaultManager.h"
#import "image_photo.h"
#import "avatar_attached_using.h"
#import "out_avatar_attached.h"

@interface SettingsProfileViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, profile_meDelegate, profile_updateDelegate,avatar_attachedDelegate>
@property (strong, nonatomic) IBOutlet UITableView *buttonList;
@property (strong, nonatomic) IBOutlet UIButton *homePageButton;
@property (strong, nonatomic) IBOutlet UILabel *info;
@property (strong, nonatomic) IBOutlet UIImageView *avatar;
- (IBAction)touchAvatarButton:(id)sender;
@end
