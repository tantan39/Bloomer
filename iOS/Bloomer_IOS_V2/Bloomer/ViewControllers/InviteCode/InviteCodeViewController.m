//
//  InviteCodeViewController.m
//  Bloomer
//
//  Created by Steven on 12/20/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "InviteCodeViewController.h"
#import "UserDefaultManager.h"
#import "AppHelper.h"

@interface InviteCodeViewController ()
{
    UserDefaultManager *userDefaultManager;
    out_profile_fetch *profileData;
    NSLayoutConstraint* constrains;
}
@end

@implementation InviteCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    profileData = [userDefaultManager getUserProfileData];
    
    [self initNavigationBar];
    
    self.buttonSendInviteCode.layer.cornerRadius = self.buttonSendInviteCode.frame.size.height / 2;
    self.buttonSendInviteCode.layer.borderColor = [UIColor colorFromHexString:@"#202021"].CGColor;
    self.buttonSendInviteCode.layer.borderWidth = 2;
    self.buttonSendInviteCode.clipsToBounds = true;
    
    [self setupLanguage];
    [self getInviteCode];
    
    constrains = [NSLayoutConstraint constraintWithItem:self.buttonSendInviteCode
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.labelCode
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1
                                                                   constant:20];
    constrains.priority = 1000;
    [self.view addConstraint:constrains];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupLanguage
{
    self.labelTitle.text = [AppHelper getLocalizedString:@"InviteCode.labelTitle"];
    self.labelMessage.text = [NSString stringWithFormat:NSLocalizedString(@"InviteCode.labelMessage", nil),0];
    [self.buttonSendInviteCode setTitle:[AppHelper getLocalizedString:@"InviteCode.buttonSendInviteCode"] forState:UIControlStateNormal];
}

- (void)initNavigationBar
{
    [AppHelper setTitleViewForNavigationBar:self.navigationItem title:NSLocalizedString(@"InviteCode.title", nil)];
}

- (void)getInviteCode
{
    API_GetInviteCode *api = [[API_GetInviteCode alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken]];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        if(response.status) {
            Json_InviteCode *model = (Json_InviteCode*)jsonObject;
            self.labelCode.text = model.user_code;
            self.labelMessage.text = [NSString stringWithFormat:NSLocalizedString(@"InviteCode.labelMessage", nil),model.invite_flower];
            if (model.invite_flower > 0) {
                [self.view removeConstraint:constrains];
                [self.view layoutIfNeeded];
            }
            self.labelMessage.hidden = model.invite_flower > 0 ? NO : YES;
        }
    } ErrorHandlure:^(NSError *error) {
        
    }];
}

// MARK: - Actions

- (IBAction)touchButtonSendInviteCode:(id)sender {
//    FBSDKShareLinkContent *shareContent = [[FBSDKShareLinkContent alloc] init];
////    [shareContent setContentTitle:[[AppHelper getLocalizedString:@"InviteCode.shareContent"] stringByReplacingOccurrencesOfString:@"codecode" withString:self.labelCode.text]];
//    [shareContent setContentURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [APIDefine shareInviteCodeLink], self.labelCode.text]]];
//
//    FBSDKMessageDialog *messageDialog = [[FBSDKMessageDialog alloc] init];
//    messageDialog.delegate = self;
//    [messageDialog setShareContent:shareContent];
//    [messageDialog show];
    
    NSURL *sharingUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [APIDefine shareInviteCodeLink], self.labelCode.text]];
    UIActivityViewController *shareActivityController = [[UIActivityViewController alloc] initWithActivityItems:@[sharingUrl] applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAddToReadingList,
                                   UIActivityTypeAirDrop,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll];
    
    shareActivityController.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:shareActivityController animated:YES completion:nil];
}

// MARK: - FBSDKSharingDelegate
- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
    
}

-(void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    
}

-(void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    
}

@end
