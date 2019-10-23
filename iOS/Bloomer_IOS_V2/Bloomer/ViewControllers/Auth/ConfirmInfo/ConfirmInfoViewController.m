//
//  ConfirmViewController.m
//  Bloomer
//
//  Created by Tran Thai Tan on 11/28/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "ConfirmInfoViewController.h"
#import "AppDelegate.h"

@interface ConfirmInfoViewController (){
    UserDefaultManager * userDefaultManager;
    Auth_FBRegisterParams * fbObject;
}

@end

@implementation ConfirmInfoViewController
@synthesize spinner,imgAvatar;

- (instancetype)initWithNib{
    self = [super initWithNibName:@"ConfirmInfoViewController" bundle:nil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    userDefaultManager = [[UserDefaultManager alloc] init];
    spinner = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).spinner;
    [self setupViews];
    
    fbObject = [[BloomerManager shareInstance] auth_FBRegister];
    
    [self configUIWithData:fbObject];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:TRUE animated:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void) setupViews{

    [self.tfName setupUnderline];
    [self.tfGender setDatasource:@[NSLocalizedString(@"IamFemale", nil),NSLocalizedString(@"IamMale", nil)] inView:self.containerView];    self.tfGender.delegate = self;
    [self.tfPhoneNumber setupUnderline];
    
    self.btnNext.layer.cornerRadius = self.btnNext.frame.size.height/2;
}

- (void) configUIWithData:(Auth_FBRegisterParams *) object{
    if (object) {
        self.tfName.text = object.fb_name;
        NSString * strGender = object.fb_gender == 1 ? NSLocalizedString(@"IamMale", nil) : NSLocalizedString(@"IamFemale", nil);
        self.tfGender.text = strGender;
        self.tfPhoneNumber.text = object.phoneNumber;
    }
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return textField != _tfPhoneNumber && textField != _tfGender;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

- (void)textFieldSelectedIndex:(NSInteger)index textfield:(TTTextField *)sender{
    [[[BloomerManager shareInstance] auth_FBRegister] setFb_gender:index];
}

- (void) showActionSheet{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.imagePickerPopup = [[ImagePickerPopUpViewController alloc] initWithNibName:@"ImagePickerPopUpViewController" bundle:nil];
    self.imagePickerPopup.parentView = self;
    self.imagePickerPopup.delegate = self;
    self.imagePickerPopup.isUploadAvatar = true;
    [self.imagePickerPopup showInView:[[[UIApplication sharedApplication] delegate] window] animated:TRUE];
}

- (IBAction)btnBack_Pressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnNext_Pressed:(id)sender {
    if ([self.tfName validateDisplayName]) {
        [self uploadAvatarWith:imgAvatar];
    }else{
        [AppHelper showMessageBox:nil message:NSLocalizedString(@"DisplaynameInvalid", nil)];
    }
}

- (void) uploadAvatarWith:(UIImage *) img{
    API_Avatar_Attached *avatarAPI = [[API_Avatar_Attached alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                                         device_token:[userDefaultManager getDeviceToken]
                                                                                image:img];
    [spinner startAnimating];
    [avatarAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        out_avatar_attached * data = (out_avatar_attached *) jsonObject;
        [spinner stopAnimating];
        if (response.status){
            [[[BloomerManager shareInstance] auth_FBRegister] setPhoto_id:data.photo_id];
            ChooseLocationViewController * chooseLocationVC = [[ChooseLocationViewController alloc] initWithNibName:@"ChooseLocationViewController" bundle:nil];
            [self.navigationController pushViewController:chooseLocationVC animated:YES];
        }
        else{
            [AppHelper showMessageBox:NSLocalizedString(@"Alert.Title.ErrorMessage",nil) message:response.message];
        }
    } ErrorHandlure:^(NSError *error) {
        [spinner stopAnimating];
    }];
}
@end
