//
//  UpdateInfoViewController.m
//  Bloomer
//
//  Created by Tran Thai Tan on 12/5/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "UpdateInfoViewController.h"

@interface UpdateInfoViewController (){
    UserDefaultManager * userDefaultManager;
    Spinner * spinner;
    NSInteger locationID;
    NSMutableArray *cityList;
    Auth_FBRegisterParams * fbObject;
    UIColor * activeColor, * deActiveColor;
    UIFont * font;
    NSInteger age;
}

@end

@implementation UpdateInfoViewController

- (instancetype)init{
    NSString * nibName = IS_IPHONE_5 ? @"UpdateInfoViewController_IP5" : @"UpdateInfoViewController";
    self = [super initWithNibName:nibName bundle:nil];

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupViews];
    userDefaultManager = [[UserDefaultManager alloc] init];
    spinner = [(AppDelegate *) [[UIApplication sharedApplication] delegate] spinner];
    activeColor = [UIColor colorFromHexString:@"#B0252A"];
    deActiveColor = [UIColor colorFromHexString:@"#E9E9E9"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.dateTimePicker = [[UIDatePicker alloc] init];
    [self.dateTimePicker setDatePickerMode:UIDatePickerModeDate];
//    [self.dateTimePicker addTarget:self action:@selector(datePicker_ValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.tfBirthDay setInputView:self.dateTimePicker];
    
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    [toolBar setTintColor:[UIColor rgb:0 green:122 blue:255]];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:[AppHelper getLocalizedString:@"StatusChangeButtonOK.Title"] style:UIBarButtonItemStyleDone target:self action:@selector(close_datePicker:)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [self.tfBirthDay setInputAccessoryView:toolBar];
    
    age = 0;
    self.countryID = -1;
    [self getRegions];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [AppHelper changeNavigationBarToWhite:self.navigationController];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    if (self.imgUpload) {
        [self.btnGallery setImage:self.imgUpload forState:UIControlStateNormal];
    }
}

- (void) getRegions{
    cityList = [[NSMutableArray alloc] init];
    API_LoadLocation *API = [[API_LoadLocation alloc] init];
    [spinner startAnimating];
    [API request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        out_location_load * data = (out_location_load *) jsonObject;
        [spinner stopAnimating];
        if (response.status) {
            cityList = data.citys;
        } else {
            [AppHelper showMessageBox:nil message:response.message];
        }
    } ErrorHandlure:^(NSError *error) {
        [spinner stopAnimating];
    }];
}

- (void) setupViews{

//    [[self.tfRegion valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
    
    [self.tfBirthDay setLeftViewWithImage:[UIImage imageNamed:@"icoBirthday"]];
    [self.tfLocation setLeftViewWithImage:[UIImage imageNamed:@"icoLocation"]];
    
    self.btnNext.layer.cornerRadius = 4.0f;
    [self.btnNext setStatusEnable:NO];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.tfLocation) {
        [self showLocationActionSheet];
        return NO;
    }
    return YES;
}

- (IBAction)touchBackground:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)close_datePicker:(id)sender{
    NSDate * birthday = self.dateTimePicker.date;
    NSDate * now = [NSDate date];
    NSDateComponents * components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:birthday toDate:now options:0];
    age = [components year];
    
    NSString * datetime = [NSString stringFromDate:birthday WithFormat:@"dd/MM/yyyy"];
    [self.tfBirthDay setText:datetime];
    
    [self.tfBirthDay resignFirstResponder];
    if (age < 17) {
        [self.tfBirthDay setError:[AppHelper getLocalizedString:@"SignUp.ValidateBirthday"] animated:YES];
    } else {
        [self.tfBirthDay hideValidateError];
    }
    
    if (age >= 17 && self.countryID != -1 ) {
        [self.btnNext setStatusEnable:YES];
    }
}

- (IBAction)btnBack_Pressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) showGalleryActionSheet{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.imagePickerPopup = [[ImagePickerPopUpViewController alloc] initWithNibName:@"ImagePickerPopUpViewController" bundle:nil];
    self.imagePickerPopup.parentView = self;
    self.imagePickerPopup.delegate = self;
    self.imagePickerPopup.isUploadAvatar = true;
    [self.imagePickerPopup showInView:[[[UIApplication sharedApplication] delegate] window] animated:TRUE];
}

- (void) showLocationActionSheet{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    if (cityList) {
        for (city * city in cityList) {
            UIAlertAction * action = [UIAlertAction actionWithTitle:city.city_name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.tfLocation setText:city.city_name];
                self.countryID = city.city_id;
                
                if (age >= 17 && self.countryID != -1 ) {
                    [self.btnNext setStatusEnable:YES];
                }
            }];
            [alert addAction:action];
        }
    }
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:[AppHelper getLocalizedString:@"Cancel"] style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)selectedImageFromImagePicker:(UIImage *)image{
    self.imgUpload = image;
    [self.btnGallery setImage:image forState:UIControlStateNormal];
}

- (IBAction)btnSelectAvatar_Pressed:(id)sender {

    [self showGalleryActionSheet];
}

- (IBAction)btnShowBirthday_Pressed:(id)sender {
    [self.tfBirthDay isFirstResponder];
}

- (IBAction)btnShowLocation_Pressed:(id)sender {
    [self showLocationActionSheet];
}

- (IBAction)btnNext_Pressed:(id)sender {
    if (self.imgUpload) {
        [self uploadAvatarWith:self.imgUpload];
    }else{
        auth_register * param = [[auth_register alloc]initWithPhotoID:@"" Access_Token:[userDefaultManager getAccessToken] Device_Token:[userDefaultManager getDeviceToken] BirthDay:self.tfBirthDay.text LocationID:self.countryID];
        if (param) {
            [self registerWithPhoneNumb:param];
        }
    }
    
}

- (IBAction)btnSkip_Pressed:(id)sender {
     [self requestGetProfileMeWith:[userDefaultManager getAccessToken] DeviceToken:[userDefaultManager getDeviceToken]];
}


- (void) uploadAvatarWith:(UIImage *) img{
    if(img) {
        API_Avatar_Attached *avatarAPI = [[API_Avatar_Attached alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                                             device_token:[userDefaultManager getDeviceToken]
                                                                                    image:img];
        [spinner startAnimating];
        [avatarAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            out_avatar_attached * data = (out_avatar_attached *) jsonObject;
            if (response.status){
                auth_register * param = [[auth_register alloc]initWithPhotoID:data.photo_id Access_Token:[userDefaultManager getAccessToken] Device_Token:[userDefaultManager getDeviceToken] BirthDay:self.tfBirthDay.text LocationID:self.countryID];
                if (param) {
                    [self registerWithPhoneNumb:param];
                }
            }
            else
            {
                [spinner stopAnimating];
                [AppHelper showMessageBox:NSLocalizedString(@"Alert.Title.ErrorMessage",nil) message:response.message];
                
            }
        } ErrorHandlure:^(NSError *error) {
            
            [spinner stopAnimating];
        }];
    }
}

- (void) registerWithPhoneNumb:(auth_register *) param{
    [spinner startAnimating];
    API_Auth_Register * api = [[API_Auth_Register alloc] initWithParams:param];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        out_auth_authorize * object = (out_auth_authorize *) jsonObject;
        if (response.status) {
//            [userDefaultManager getUserProfileData].gender = param.gender;
            [userDefaultManager saveAccessToken:object.access_token];
            [userDefaultManager saveRefresh_Token:object.refresh_token];
            [userDefaultManager saveCredentialEjab:[userDefaultManager decryptDESByKey:[userDefaultManager getAppKey] data:object.cridential_ejab iv:[userDefaultManager getAppSecret]]];
            [userDefaultManager setDidPostDailyLocalNotification:false];
            [LocalNotificationHelper removeAllLocalNotifications];
            
            [self requestGetProfileMeWith:object.access_token DeviceToken:[userDefaultManager getDeviceToken]];
        }else{
             [spinner stopAnimating];
            [AppHelper showMessageBox:nil message:response.message];
        }
    } ErrorHandlure:^(NSError *error) {
        [spinner stopAnimating];
    }];
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
                //                profileData = data;
                TabBarViewController *view = [[TabBarViewController alloc] initWithNibName:@"TabBarViewController" bundle:nil];
                [view setSelectedIndex:4];
                UINavigationController *nav = (UINavigationController*)[view.viewControllers objectAtIndex:4];
                MyProfileViewController *myProfileView = (MyProfileViewController*)[nav.viewControllers firstObject];
                [myProfileView showRemindInviteCodePopUpWith:data.invite_flower];

                [self.navigationController pushViewController:view animated:TRUE];
            }else{
                [spinner stopAnimating];
                [AppHelper showMessageBox:[AppHelper getLocalizedString:@"Alert.Title.ErrorMessage"] message:objStatus.message];
            }
        } ErrorHandlure:^(NSError * error) {
            [spinner stopAnimating];
        }];
    }
    
}

#pragma mark - Handle Show/Hide Keyboard
- (void)keyboardWillShow:(NSNotification *) notif
{
    NSDictionary *userInfo = [notif userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGFloat yFrame = self.navigationController.navigationBar.bounds.size.height + self.view.bounds.size.height - (_btnSkip.frame.origin.y + _btnSkip.bounds.size.height );

    CGFloat offSet = yFrame - kbSize.height;
    
    if (offSet < 0) {
        [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
            self.view.frame = CGRectMake(0, offSet, self.view.bounds.size.width, self.view.bounds.size.height);
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *) notif
{
    NSDictionary *userInfo = [notif userInfo];
    CGRect frame = self.view.frame;
    frame.origin.y = self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    
    [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.frame = frame;
    }];
}

@end
