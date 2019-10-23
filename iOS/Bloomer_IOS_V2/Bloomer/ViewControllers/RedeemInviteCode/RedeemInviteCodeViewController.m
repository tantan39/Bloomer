//
//  RedeemInviteCodeViewController.m
//  Bloomer
//
//  Created by Steven on 12/20/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "RedeemInviteCodeViewController.h"
#import "UserDefaultManager.h"
#import "AppHelper.h"

@interface RedeemInviteCodeViewController ()
{
    UserDefaultManager *userDefaultManager;
}
@end

@implementation RedeemInviteCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userDefaultManager = [[UserDefaultManager alloc] init];
//    self.expireLabel.text = NSLocalizedString(@"RedeemInviteCode.expireMess",);
    
    [self initNavigationController];
    
    self.textFieldCode.delegate = self;
    self.dismissKBGesture.delegate = self;
    
    self.textFieldCode.layer.cornerRadius = self.textFieldCode.frame.size.height / 2;
    self.textFieldCode.clipsToBounds = true;
    
    self.buttonRedeemCode.layer.cornerRadius = self.buttonRedeemCode.frame.size.height / 2;
    self.buttonRedeemCode.layer.borderColor = [UIColor colorFromHexString:@"#202021"].CGColor;
    self.buttonRedeemCode.layer.borderWidth = 2;
    self.buttonRedeemCode.clipsToBounds = true;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setupLanguage];
    
    [self.textFieldCode setText:self.code];
    
    [self.expireView setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    if (!self.redeemInviteCodeSuccess) {
        if (self.RedeemmInviteCodeFailure) {
            self.RedeemmInviteCodeFailure();
        }
    }
}


- (void)initNavigationController
{
    [AppHelper setTitleViewForNavigationBar:self.navigationItem title:NSLocalizedString(@"RedeemInviteCode.title", "")];
}

- (void)setupLanguage
{
    self.labelMessage.text = [AppHelper getLocalizedString:@"RedeemInviteCode.labelMessage"];
    self.textFieldCode.placeholder = [AppHelper getLocalizedString:@"RedeemInviteCode.enterYourCode"];
    [self.buttonRedeemCode setTitle:[AppHelper getLocalizedString:@"RedeemInviteCode.buttonRedeemCode"] forState:UIControlStateNormal];
}

// MARK: - Actions

- (IBAction)dismissKBGesture:(id)sender {
    [self.view endEditing:true];
    [self touchButtonRedeemCode:self.buttonRedeemCode];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    [self.view endEditing:true];
    return YES;
}

- (IBAction)touchButtonRedeemCode:(id)sender {
    if (![self.textFieldCode.text isEqualToString:@""])
    {
        [self.expireView setHidden:YES];
        
        API_VerifyInviteCode *api = [[API_VerifyInviteCode alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] invite_code:self.textFieldCode.text];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            Json_VerifyInviteCode * data = (Json_VerifyInviteCode *) jsonObject;
            if (response.status) {
                self.redeemInviteCodeSuccess = YES;
                out_profile_fetch *profileData = [userDefaultManager getUserProfileData];
                profileData.your_num_flower += data.flower;
                [userDefaultManager saveUserProfileData:profileData];
                
                self.textFieldCode.text = @"";
                
                [AppHelper showMessageBox:nil message:data.message];

            } else {

                self.expireLabel.text = response.message;
                [self.expireView setHidden:NO];
            }
        } ErrorHandlure:^(NSError *error) {
            
        }];
    } else {
        self.expireLabel.text = [AppHelper getLocalizedString:@"RedeemInviteCode.errorEmptyCode"];
        [self.expireView setHidden:NO];
        [self.view endEditing:true];
    }
}


// MARK: - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.textFieldCode) {
        [self touchButtonRedeemCode:self.buttonRedeemCode];
        [textField resignFirstResponder];
        return false;
    }
    return true;
}

// MARK: - UIKeyboard Notifications
- (void)keyboardWillShow:(NSNotification*)notification
{
    CGSize keyboardSize = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSTimeInterval time = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
//    CGFloat delta = [UIScreen mainScreen].bounds.size.height - ([UIScreen mainScreen].bounds.size.height - self.mainView.frame.size.height) / 2 - [UIScreen mainScreen].bounds.size.height + keyboardSize.height;
    
    CGRect buttonFrame = [self.buttonRedeemCode.superview convertRect:self.buttonRedeemCode.frame toView:self.view];
//    buttonFrame = self.buttonRedeemCode.frame;
    CGFloat delta = self.view.bounds.size.height - (buttonFrame.origin.y + buttonFrame.size.height + 20);
    
    self.mainViewCenterYConstraint.constant = delta - keyboardSize.height;
    
    [UIView animateWithDuration:time animations:^{
         [self.view layoutIfNeeded];
    }];

}

- (void)keyboardWillHide:(NSNotification*)notification
{
    self.mainViewCenterYConstraint.constant = 0;
    
    NSTimeInterval time = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:time animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end
