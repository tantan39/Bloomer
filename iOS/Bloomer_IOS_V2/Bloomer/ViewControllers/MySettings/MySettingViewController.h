//
//  MySettingViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 2/26/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountSettingViewController.h"
#import "UserDefaultManager.h"
#import "out_auth_logout.h"
#import "TabBarView.h"
#import "out_profile_fetch.h"
#import "profile_update.h"
//#import "profile_update_using.h"
#import "out_profile_update.h"
//#import "avatar_attached_using.h"
#import "out_avatar_attached.h"
#import "out_profile_fetch.h"
#import "setting_update.h"
//#import "profile_setting_using.h"
#import "out_profile_setting_fetch.h"
#import "EditProfileViewController.h"
#import "ChangesPasswordViewController.h"
#import "API_Profile_SettingFetches.h"
#import "ChatSettingViewController.h"
#import "PrivacySettingViewController.h"
#import "AppSettingViewController.h"
#import "InviteCodeViewController.h"
#import "RedeemInviteCodeViewController.h"
#import <MessageUI/MessageUI.h>
#import "API_Auth_Logout.h"
#import "API_Check_Pass_User.h"
#import "SetPasswordViewController.h"
#import "UpdatePhoneNumberViewController.h"

@interface MySettingViewController : UITableViewController < UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate, FBSDKAppInviteDialogDelegate,UIAlertViewDelegate>


@property (weak, nonatomic) IBOutlet UITableViewCell *inviteFriendsCell;
@property (weak, nonatomic) IBOutlet UIButton *buttonInviteFriends;
@property (weak, nonatomic) IBOutlet UIButton *buttonLikeFacebook;
@property (weak, nonatomic) IBOutlet UIButton *buttonHelpAndFeedback;
@property (weak, nonatomic) IBOutlet UIButton *buttonLogOut;
@property (weak, nonatomic) IBOutlet UIButton *buttonFreeFlowers;
@property (strong, nonatomic) IBOutlet UILabel *labelVersion;
@property (strong, nonatomic) NSString * numberMobile;
@property (assign, nonatomic) BOOL isSetPass;

@property (weak, nonatomic) IBOutlet UILabel *changePassLabel;

- (IBAction)touchButtonLikeFacebook:(id)sender;
- (IBAction)touchHelpAndFeedbackButton:(id)sender;
- (IBAction)touchButtonLogOut:(id)sender;
- (IBAction)touchButtonInviteFriends:(id)sender;
- (IBAction)touchButtonFreeFlowers:(id)sender;

@end
