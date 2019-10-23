//
//  UpdateAvatarSignUpVC.m
//  Bloomer
//
//  Created by Tran Thai Tan on 6/7/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "UpdateAvatarSignUpVC.h"

@interface UpdateAvatarSignUpVC () <ImagePickerPopUpVCDelegate>{
    UserDefaultManager *userDefaultManager;
    out_profile_fetch *profileData;
    ImagePickerPopUpViewController *imagePickerPopup;
    Spinner * spinner;
}

@end

@implementation UpdateAvatarSignUpVC 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    spinner = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).spinner;
    userDefaultManager = [[UserDefaultManager alloc] init];
    profileData = [userDefaultManager getUserProfileData];
    
    [_btnChangePicture setUnderlineForButtonWithTitle:NSLocalizedString(@"UpdateAvatar.ChangePicture", nil)];
    [_btnSkip setUnderlineForButtonWithTitle:NSLocalizedString(@"UpdateAvatar.SkipThisStep", nil)];
    [_btnComplete roundedBorderCornerForButton];
    [_btnComplete setStatusEnable:NO];
    
    _imgvAvatar.layer.borderWidth = 2;
    _imgvAvatar.layer.borderColor = [UIColor colorFromHexString:@"#E4E4E4"].CGColor;
    _imgvAvatar.layer.cornerRadius = _imgvAvatar.frame.size.width / 2;
    _imgvAvatar.clipsToBounds = YES;

    _imgvAvatar.layer.borderWidth = 1;
    _imgvAvatar.layer.borderColor = [UIColor colorFromHexString:@"#E4E4E4"].CGColor;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [[self navigationController] setNavigationBarHidden:TRUE animated:YES];
    
    if (self.avatarUpdate) {
        self.imgvAvatar.image = self.avatarUpdate;
    }
}

- (void) showActionSheet{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    imagePickerPopup = [[ImagePickerPopUpViewController alloc] initWithNibName:@"ImagePickerPopUpViewController" bundle:nil];
    imagePickerPopup.parentView = self;
    imagePickerPopup.delegate = self;
    imagePickerPopup.isUploadAvatar = true;
    [imagePickerPopup showInView:[[[UIApplication sharedApplication] delegate] window] animated:TRUE];
}

- (IBAction)btnBack_Pressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnChangePicture_Pressed:(id)sender {
    [self showActionSheet];
}


- (IBAction)btnComplete_Pressed:(id)sender {
    [spinner startAnimating];
    [self uploadAvatarWith:self.imgvAvatar.image];
}

- (IBAction)btnSkip_Pressed:(id)sender {
    [spinner startAnimating];
    auth_register *params = [[auth_register alloc] initWithScreenName:self.registerModel.screen_name
                                                             Photo_ID:@""
                                                         Access_Token:[userDefaultManager getAccessToken]
                                                         Device_Token:[userDefaultManager getDeviceToken]
                                                          Location_ID:self.registerModel.location_id
                                                             Birthday:@""
                                                               Gender:self.registerModel.gender
                                                          invite_code:nil];
//    auth_register_using *registerAPI = [[auth_register_using alloc] init];
//    [registerAPI selectInput:params];
//    registerAPI.myDelegate = self;
//    [registerAPI connect];
    [self requestResgisterWithData:params];
}

- (void) uploadAvatarWith:(UIImage *) img{
    API_Avatar_Attached *avatarAPI = [[API_Avatar_Attached alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                                             device_token:[userDefaultManager getDeviceToken]
                                                                                    image:img];
    [avatarAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        out_avatar_attached * data = (out_avatar_attached *) jsonObject;
        if (response.status)
        {
            auth_register *params = [[auth_register alloc] initWithScreenName:self.registerModel.screen_name
                                                                     Photo_ID:data.photo_id
                                                                 Access_Token:[userDefaultManager getAccessToken]
                                                                 Device_Token:[userDefaultManager getDeviceToken]
                                                                  Location_ID:self.registerModel.location_id
                                                                     Birthday:@""
                                                                       Gender:self.registerModel.gender
                                                                  invite_code:nil];
            //        auth_register_using *registerAPI = [[auth_register_using alloc] init];
            //        [registerAPI selectInput:params];
            //        registerAPI.myDelegate = self;
            //        [registerAPI connect];
            [self requestResgisterWithData:params];
        }
        else
        {
            [spinner stopAnimating];
            //        [self.buttonComplete setEnabled:TRUE];
            [AppHelper showMessageBox:NSLocalizedString(@"Alert.Title.ErrorMessage",nil) message:response.message];
            
        }
    } ErrorHandlure:^(NSError *error) {
        [spinner stopAnimating];
    }];
}

- (void) requestResgisterWithData:(auth_register *) params{
    if (params) {
        
        API_Auth_Register * api = [[API_Auth_Register alloc] initWithParams:params];
        [api postRequest:^(BaseJSON * json, RestfulResponse * data) {
            
            out_auth_authorize * object = (out_auth_authorize *) json;
            if (data.status)
            {
                [userDefaultManager getUserProfileData].gender = self.registerModel.gender;
                [userDefaultManager saveAccessToken:object.access_token];
                [userDefaultManager saveRefresh_Token:object.refresh_token];
                [userDefaultManager saveCredentialEjab:[userDefaultManager decryptDESByKey:[userDefaultManager getAppKey] data:object.cridential_ejab iv:[userDefaultManager getAppSecret]]];
                [userDefaultManager setDidPostDailyLocalNotification:false];
                [LocalNotificationHelper removeAllLocalNotifications];
                
                [self requestGetProfileMeWith:object.access_token DeviceToken:[userDefaultManager getDeviceToken]];
                
                
            }else{
                [spinner stopAnimating];
                [AppHelper showMessageBox:nil message:data.message];
            }
            
        } ErrorHandlure:^(NSError * error) {
            [spinner stopAnimating];
        }];
    }
}

- (void) requestGetProfileMeWith:(NSString *) accessToken DeviceToken:(NSString *) deviceToken{
    if (accessToken && deviceToken) {
        API_Profile_Me * api = [[API_Profile_Me alloc] initWithAccessToken:accessToken
                                                                      device_token:deviceToken];
        [api getRequest:^(BaseJSON * json, RestfulResponse * objStatus) {
            out_profile_fetch * data = (out_profile_fetch *) json;
            [spinner stopAnimating];
            if (objStatus.status)
            {
                [userDefaultManager saveUserProfileData:data];
                [userDefaultManager removeM_ID];
                profileData = data;
                TabBarViewController *view = [[TabBarViewController alloc] initWithNibName:@"TabBarViewController" bundle:nil];
                [self.navigationController pushViewController:view animated:TRUE];
            }else{
                [AppHelper showMessageBox:[AppHelper getLocalizedString:@"Alert.Title.ErrorMessage"] message:objStatus.message];
            }
        } ErrorHandlure:^(NSError * error) {
            [spinner stopAnimating];
        }];
    }

}

#pragma mark - ImagePickerPopUpVCDelegate
- (void)selectedImageFromImagePicker:(UIImage *)image{
    if (image) {
        self.imgvAvatar.image = image;
        [_btnComplete setStatusEnable:YES];
    }
}

@end
