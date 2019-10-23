//
//  ProfileMenuViewController.h
//  Xinh
//
//  Created by Truong Thuan Tai on 12/1/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileMenuButtonTableViewCell.h"
#import "ProfileMenuPopUpViewController.h"
#include "SWRevealViewController.h"
#import "SettingsViewController.h"
#import "MyProfileViewController.h"
#import "out_profile_fetch.h"
#import "UserDefaultManager.h"
#import "avatar_attached_using.h"
#import "out_avatar_attached.h"
#import "SponsorListViewController.h"
#import "profile_update_about_me_using.h"
#import "profile_update_about_me.h"
#import "PaymentViewController.h"
#import "image_photo.h"
#import "profile_me_using.h"

@interface ProfileMenuViewController : UIViewController <UITableViewDataSource, UITableViewDataSource, UIImagePickerControllerDelegate, avatar_attachedDelegate, himageDelegate, profile_updateAboutMeDelegate, profile_meDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomNotification;
@property (weak, nonatomic) IBOutlet UIImageView *bigAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *smallAvatar;
@property (weak, nonatomic) IBOutlet UITextField *status;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *rank;
@property (strong ,nonatomic) hImage* avatarImageAPI;
@property (weak, nonatomic) IBOutlet UILabel *flowerValue;
@property (weak, nonatomic) IBOutlet UILabel *sponsorValue;
- (IBAction)backgroundTap:(id)sender;
- (IBAction)editDidEnd:(id)sender;
- (IBAction)touchEditStatusButton:(id)sender;
- (IBAction)touchEditAvatarButton:(id)sender;
- (IBAction)touchSmallAvatarButton:(id)sender;
@property (weak, nonatomic) SWRevealViewController* reveal;
@property (weak, nonatomic) IBOutlet UILabel *nameNotification;
@property (weak, nonatomic) IBOutlet UILabel *messageNotification;
@property (weak, nonatomic) IBOutlet UIImageView *avataNotification;
-(void)updateNotification:(NSString*) name message:(NSString*)message andAvata:(NSString*) image;

@end
