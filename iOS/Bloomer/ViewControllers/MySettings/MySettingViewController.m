//
//  MySettingViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 2/26/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "MySettingViewController.h"
#import "AppDelegate.h"
#include <sys/sysctl.h>
#include <sys/utsname.h>

@interface MySettingViewController () {
    UserDefaultManager *userDefaultManager;
    out_profile_setting *profileSetting;
    out_profile_fetch * user;
}
@end

@implementation MySettingViewController

// MARK: - Functions

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [self.labelVersion setText:[NSString stringWithFormat:@"%@b%@", version, build]];
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    profileSetting = [[out_profile_setting alloc] init];
    
    self.buttonLikeFacebook.layer.cornerRadius = self.buttonLikeFacebook.frame.size.height / 2;
    self.buttonLikeFacebook.clipsToBounds = TRUE;
    
    self.buttonHelpAndFeedback.layer.cornerRadius = self.buttonHelpAndFeedback.frame.size.height / 2;
    self.buttonHelpAndFeedback.clipsToBounds = TRUE;
    
    self.buttonLogOut.layer.cornerRadius = self.buttonLogOut.frame.size.height / 2;
    self.buttonLogOut.clipsToBounds = TRUE;
    
    self.buttonInviteFriends.layer.cornerRadius = self.buttonInviteFriends.frame.size.height / 2;
    self.buttonInviteFriends.clipsToBounds = TRUE;
    
    self.buttonFreeFlowers.layer.cornerRadius = self.buttonFreeFlowers.frame.size.height / 2;
    self.buttonFreeFlowers.clipsToBounds = TRUE;
    
    // Remove bottom separators for social buttons
    CGFloat cellWidth = self.inviteFriendsCell.bounds.size.width;
    self.inviteFriendsCell.separatorInset = UIEdgeInsetsMake(0, [[UIScreen mainScreen] bounds].size.width, 0, 0);
    
    [self initNavigationBar];
    [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner startAnimating];
}

- (void)initNavigationBar
{
    [AppHelper setTitleViewForNavigationBar:self.navigationItem title:NSLocalizedString(@"Settings", nil)];
}

-(void) checkPassUser
{
    if([profileSetting.mobile isEqual:[NSNull null]])
    {
        [_changePassLabel setText:NSLocalizedString(@"SetPassword.Label",nil)];
        return;
    }
    
    out_profile_fetch *profile = [userDefaultManager getUserProfileData];
    _isSetPass = profile.pass;
    if(!_isSetPass)
    {
        [_changePassLabel setText:NSLocalizedString(@"SetPassword.Label",nil)];
    }
    else
    {
        [_changePassLabel setText:NSLocalizedString(@"Change Password",nil)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadProfileSetting];
    NSString * bundle=[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString * version=[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    switch ([APIDefine getEnvironment]) {
        case DEVELOPMENT:
            [self.labelVersion setText:[NSString stringWithFormat:@"Dev v%@b%@",version, bundle]];
            break;
        case STAGING:
            [self.labelVersion setText:[NSString stringWithFormat:@"Staging v%@b%@",version, bundle]];
            break;
        default:
            [self.labelVersion setText:[NSString stringWithFormat:@"LIVE v%@b%@",version, bundle]];
            break;
    }
    
    NSIndexPath*    selection = [self.tableView indexPathForSelectedRow];
    if (selection) {
        [self.tableView deselectRowAtIndexPath:selection animated:YES];
    }
    
}

- (void)loadProfileSetting {
    API_Profile_SettingFetches *api = [[API_Profile_SettingFetches alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken]];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        out_profile_setting * data = (out_profile_setting *) jsonObject;
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        if (response.status)
        {
            profileSetting = data;
            [userDefaultManager saveChatSetting:profileSetting.number_chatting];
            [self checkPassUser];
        }
        else
        {
            [AppHelper showMessageBox:nil message:response.message];
        }
    } ErrorHandlure:^(NSError *error) {
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];

    }];
}

- (void)loadEditProfileViewController
{
    EditProfileViewController *editProfileViewController = [[EditProfileViewController alloc] initWithNibName:@"EditProfileViewController" bundle:nil];
    editProfileViewController.hidesBottomBarWhenPushed = TRUE;
    
    [self.navigationController pushViewController:editProfileViewController animated:YES];
}

- (void)loadAccountSettingViewController
{
    AccountSettingViewController *view = [[AccountSettingViewController alloc] initWithNibName:@"AccountSettingViewController" bundle:nil];
    view.profileSettings = profileSetting;
    [self.navigationController pushViewController:view animated:TRUE];
}

- (void)loadChatSettingViewController
{
    ChatSettingViewController *view = [[ChatSettingViewController alloc] initWithNibName:@"ChatSettingViewController" bundle:nil];
    [self.navigationController pushViewController:view animated:TRUE];
}

- (void)loadChangePasswordViewController
{
    ChangesPasswordViewController *view = [[ChangesPasswordViewController alloc] initWithNibName:@"ChangesPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:view animated:YES];
}

-(void)loadSetPasswordViewController
{
    if([profileSetting.mobile isEqual:[NSNull null]])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:NSLocalizedString(@"MobileNotSet.message", nil)
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"PopUpMarketing.buttonClose", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            UpdatePhoneNumberViewController *updatePhoneVC = [[UpdatePhoneNumberViewController alloc] initWithNibName:@"UpdatePhoneNumberViewController" bundle:nil];
            [self.navigationController pushViewController:updatePhoneVC animated:YES];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    else {
        SetPasswordViewController *view = [[SetPasswordViewController alloc] initWithNibName:@"SetPasswordViewController" bundle:nil];
        [self.navigationController pushViewController:view animated:YES];
    }
}

- (void)loadPrivacySettingViewController
{
    PrivacySettingViewController *view = [[PrivacySettingViewController alloc] initWithNibName:@"PrivacySettingViewController" bundle:nil];
    view.share = profileSetting.private_share;
    
    [self.navigationController pushViewController:view animated:YES];
}

- (void)loadAppSettingViewController
{
    AppSettingViewController *view = [[AppSettingViewController alloc] initWithNibName:@"AppSettingViewController" bundle:nil];
    view.all = profileSetting.all;
    view.chat = profileSetting.chat;
    view.race = profileSetting.race;
    view.app = profileSetting.app;
    view.follower = profileSetting.flower;
    view.following = profileSetting.follow;
    
    [self.navigationController pushViewController:view animated:YES];
}

- (void)loadTermViewController
{
    TermAndPolicyViewController *view = [[TermAndPolicyViewController alloc] initWithNibName:@"TermAndPolicyViewController" bundle:nil];
    view.urlString = [APIDefine termsOfUseLink];
    view.isTerm = YES;
    
    [self.view endEditing:TRUE];
    [self.navigationController pushViewController:view animated:TRUE];
}

// MARK: - Actions
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)touchButtonLikeFacebook:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: l_FACEBOOK]];
}

- (IBAction)touchHelpAndFeedbackButton:(id)sender {
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"Bloomer v.1.0.1"];
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
        NSString* content = [NSString stringWithFormat:NSLocalizedString(@"I have some great ideas on making Bloomer cooler.\n Here are what Bloomer needs to improve:\n1.\n2.\n3.\n--------\nDevice : %@ ; %@ %@",nil),platform,[UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion ];
        [mail setMessageBody:content isHTML:NO];
        [mail setToRecipients:@[e_SUPPORT]];
        
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        NSLog(@"This device cannot send email");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"This device cannot send email",nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        ErrorMessageView* messView = [[ErrorMessageView alloc]initWithMessage:NSLocalizedString(@"This device cannot send email",nil)];
//        [self.view addSubview:messView];
        [alertView show];
    }
}

- (IBAction)touchButtonLogOut:(id)sender {
    
    if(_isSetPass || [profileSetting.mobile isEqual:[NSNull null]] || [profileSetting.mobile isEqualToString:@""])
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"LogoutConfirmAlert.title",nil) message:NSLocalizedString(@"LogoutConfirmAlert.message",nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * actionOK = [UIAlertAction actionWithTitle:NSLocalizedString(@"Yes",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self Logout];
        }];
        
        UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"No",nil) style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:actionOK];
        [alert addAction:actionCancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"LogoutAlert.title",nil)
                                                                       message:NSLocalizedString(@"LogoutAlert.message", nil)
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"LogoutAlertDeny.button",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            double delayInSeconds = 0.2;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self Logout];
            });
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"LogoutAlertAccept.button",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            SetPasswordViewController *view = [[SetPasswordViewController alloc] initWithNibName:@"SetPasswordViewController" bundle:nil];
            
            [self.navigationController pushViewController:view animated:YES];
            view.isLogOut = YES;
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void) Logout
{
    Spinner* spinner = ((AppDelegate*)[UIApplication sharedApplication].delegate).spinner;
    [spinner startAnimating];
    API_Auth_Logout * api = [[API_Auth_Logout alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken]];
    [api getRequest:^(BaseJSON *json, RestfulResponse *data) {
        if (data.status) {
            if([FBSDKAccessToken currentAccessToken]) {
                FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
                [loginManager logOut];
            }
            
            if ([[SocketManager shareInstance] IsConnected]) {
                [[SocketManager shareInstance] closeConnection];
            }
            
            [userDefaultManager removeAccessToken];
            [userDefaultManager removeUserProfileData];
            [userDefaultManager removeCredentialEjab];
            [userDefaultManager removeAuthSession];
            [userDefaultManager removeIsUpdateInformation];
            [userDefaultManager removeRefresh_Token];
            [userDefaultManager saveTransactionID:@""];
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//            [appDelegate.pullNotificationAPI cancelCurrentRequest];
//            [appDelegate.pullAPITimer invalidate];
//            appDelegate.pullAPITimer = nil;
            [appDelegate.badgeNumber removeFromSuperview];
            [appDelegate.chatBadgeNumber removeFromSuperview];
            UINavigationController *navController = (UINavigationController *)UIApplication.sharedApplication.keyWindow.rootViewController;
            SelectScreenViewController *selectScreenViewController = [[SelectScreenViewController alloc] initWithNibName:@"SelectScreenViewController" bundle:nil];
            [navController popToRootViewControllerAnimated:false];
            [navController pushViewController:selectScreenViewController animated:true];
        }
        [spinner stopAnimating];
    } ErrorHandlure:^(NSError * error) {
        [spinner stopAnimating];
    }];
}

- (IBAction)touchButtonInviteFriends:(id)sender {
    InviteCodeViewController *inviteCodeViewController = [[InviteCodeViewController alloc] initWithNibName:@"InviteCodeViewController" bundle:nil];
    [self.navigationController pushViewController:inviteCodeViewController animated:true];
}

- (IBAction)touchButtonFreeFlowers:(id)sender {
    RedeemInviteCodeViewController *redeemInviteCodeViewController = [[RedeemInviteCodeViewController alloc] initWithNibName:@"RedeemInviteCodeViewController" bundle:nil];
    [self.navigationController pushViewController:redeemInviteCodeViewController animated:true];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    [self touchButtonInviteFriends:nil];
                    break;
                case 1:
                    [tableView deselectRowAtIndexPath:indexPath animated:true];
                    [self touchButtonLikeFacebook:nil];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    [self loadEditProfileViewController];
                    break;
                    
                default:
                    [self loadAccountSettingViewController];
                    break;
            }
            
            break;
            
        case 2:
            [self loadChatSettingViewController];
            break;
            
        case 3:
            switch (indexPath.row) {
                case 0:
                    if(_isSetPass) {
                        [self loadChangePasswordViewController];
                    } else {
                        [self loadSetPasswordViewController];
                    }
                    break;
                    
                default:
                    [self loadPrivacySettingViewController];
                    break;
            }
            
            break;
            
        case 4:
            [self loadAppSettingViewController];
            break;
            
        case 5:
            switch (indexPath.row) {
                case 0:
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[APIDefine getrootWebURL],NSLocalizedString( l_FAQ,nil)]] ];
                    [tableView deselectRowAtIndexPath:indexPath animated:true];
                    break;
                    
                case 1:
                    [self loadTermViewController];
                    break;
                    
                default:
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",[APIDefine getrootWebURL],NSLocalizedString( l_WEBSITE,nil)]] ];
                    [tableView deselectRowAtIndexPath:indexPath animated:true];
                    break;
            }
            
            break;
            
        default:
            break;
    }
}

// MARK: - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    ErrorMessageView* messView;
    NSString* s_error=@"";
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
//            s_error=NSLocalizedString(@"You sent the email.",nil);
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
//            s_error=NSLocalizedString(@"",nil);
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
//            s_error=NSLocalizedString(@"",nil);
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            s_error=NSLocalizedString(@"Mail failed:  An error occurred when trying to compose this email",nil);
            messView = [[ErrorMessageView alloc]initWithMessage:s_error];
            [self.view addSubview:messView];
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            s_error=NSLocalizedString(@"An error occurred when trying to compose this email",nil);
            messView = [[ErrorMessageView alloc]initWithMessage:s_error];
            [self.view addSubview:messView];
            break;
    }
   
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// MARK: - FBSDKAppInviteDialogDelegate
- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error
{
    NSLog(@"error : %@", error);
}

- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results
{
    
}

@end
