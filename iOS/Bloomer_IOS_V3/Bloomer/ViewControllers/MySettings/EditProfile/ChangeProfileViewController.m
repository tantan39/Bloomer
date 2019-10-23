//
//  ChangeProfileViewController.m
//  Bloomer
//
//  Created by Phan Van Thanh Dat on 11/20/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "ChangeProfileViewController.h"
@interface ChangeProfileViewController () {
    UserDefaultManager *userDefaultManager;
    CGFloat offSetSave;
}
   @property (nonatomic) CGPoint rectKeyboard;
@end

@implementation ChangeProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    userDefaultManager = [[UserDefaultManager alloc] init];
    self.profileData = [userDefaultManager getUserProfileData];
    self.isChangeUserName = FALSE;
    [self setUp];
    [self setData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [self.view endEditing:TRUE];
}

- (void) setUp {
    [AppHelper setTitleViewForNavigationBar:self.navigationItem title:NSLocalizedString(@"ChangeProfileViewController.title", nil)];
    self.aboutMeTV.placeholder = [AppHelper getLocalizedString:@"ChangeAboutMeViewController.placeholderTextview"];
    self.dislayNameTF.isProfile = TRUE;
    self.userNameTF.isProfile  = TRUE;
    
    self.avatarImage.layer.cornerRadius = self.avatarImage.frame.size.width / 2;
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapper)];
    self.avatarImage.userInteractionEnabled = TRUE;
    [self.avatarImage addGestureRecognizer:gesture];
    
    [self initButtonBar];
}

- (void) setData {
    self.dislayNameTF.text = self.profileData.name;
    self.userNameTF.text = self.profileData.username;
    self.aboutMeTV.text = self.profileData.about_me;
    [self.avatarImage setImageWithAnimationFromURL:[[NSURL alloc] initWithString:self.profileData.avatar] placeHolder:[UIImage imageNamed:@"Icon_Default_Avatar"]];
    
    [self textViewDidChange:self.aboutMeTV];
    [self textEditchange:self.dislayNameTF];
    [self textEditchange:self.userNameTF];
    self.heightConstraintTV.constant = [AppHelper getHightTextView:self.profileData.about_me font:self.aboutMeTV.font with:self.aboutMeTV.frame.size.width];
}

- (void) initButtonBar {
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle: [AppHelper getLocalizedString:@"ChangeProfileViewController.save"]  style:UIBarButtonItemStylePlain target:self action:@selector(touchsaveButton)];
    saveButton.tintColor = [UIColor rgb:74 green:144 blue:226];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:/*notificationButton,*/ saveButton, nil]];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle: [AppHelper getLocalizedString:@"ChangeProfileViewController.cancel"]  style:UIBarButtonItemStylePlain target:self action:@selector(touchCancelButton)];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:/*notificationButton,*/ cancelButton, nil]];
    
}


- (void)touchsaveButton {
    [self.view endEditing:TRUE];
    BOOL isEmpty = FALSE;
    if ([self.dislayNameTF.text isEqualToString: @""]) {
        [self.dislayNameTF setError: [AppHelper getLocalizedString:@"ChangeProfileViewController.displayNameError"] animated:TRUE];
        isEmpty = TRUE;
    }
    
    if ([self.userNameTF.text isEqualToString:@""]) {
        [self.userNameTF setError: [AppHelper getLocalizedString:@"ChangeProfileViewController.userNameError"] animated:TRUE];
        isEmpty = TRUE;
    }
    
    if (isEmpty) {
        return;
    }
    [self updateName];
}

- (void)touchCancelButton {
    [self dismissViewControllerAnimated:TRUE completion:^{
        
    }];
}

- (void) imageTapper {
    UpdateAvatarViewController *view = [[UpdateAvatarViewController alloc] initWithNibName:@"UpdateAvatarViewController" bundle:nil];
    view.hidesBottomBarWhenPushed = TRUE;
    [self.navigationController pushViewController:view animated:TRUE];
}

- (void) pushChangeAboutMe {
    ChangeAboutMeViewController *view = [[ChangeAboutMeViewController alloc] initWithNibName:@"ChangeAboutMeViewController" bundle:nil];
    view.updateStatus = ^(NSString* status) {
        self.profileData.about_me = status;
        [self setData];
        [userDefaultManager saveUserProfileData:self.profileData];
    };
    [self.navigationController pushViewController:view animated:TRUE];
}

- (IBAction)touchViewBAckground:(id)sender {
    [self.view endEditing:TRUE];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    CGPoint rect = [textView convertPoint:textView.bounds.origin toView:self.view];
    rect.y = rect.y + textView.frame.size.height;
    self.rectKeyboard = rect;
//    [self pushChangeAboutMe];
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        return NO;
    }
    
    if (textView.text.length + text.length > 120 && range.length == 0) {
        return NO;
    }
    
    NSString* strText = [textView.text stringByAppendingString:text];
    
    if (textView.text.length > 0 && [text isEqualToString:@""]) {
        NSRange ran = NSMakeRange(0, textView.text.length - 1);
        strText = [textView.text substringWithRange:ran];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.heightConstraintTV.constant = [AppHelper getHightTextView:strText font:self.aboutMeTV.font with:self.aboutMeTV.frame.size.width];
        offSetSave = offSetSave + textView.frame.size.height -self.heightConstraintTV.constant;
        if (offSetSave < 0) {
            self.view.frame = CGRectMake(0, self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height + offSetSave, self.view.bounds.size.width, self.view.bounds.size.height);
        }
        [self.view layoutIfNeeded];
    }];
    
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView {
    self.lengthAboutMeLabel.text = [NSString stringWithFormat: @"%lu/120", (unsigned long)(textView.text.length)];
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length + string.length > 20 && range.length == 0) {
        return NO;
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    CGPoint rect = [textField convertPoint:textField.bounds.origin toView:self.view];
    rect.y = rect.y + textField.frame.size.height;
    self.rectKeyboard = rect;
    return TRUE;
}



- (IBAction)textEditchange:(id)sender {
    if (sender == self.dislayNameTF) {
        self.lengthDislayLabel.text = [NSString stringWithFormat: @"%lu/20", (unsigned long)(self.dislayNameTF.text.length)];
        [self.dislayNameTF hideValidateError];
    } else {
//        self.lengthUsernamLabel.text = self.userNameTF.text.length == 0 ? @"seto" : [NSString stringWithFormat: @"%lu/20", (unsigned long)(self.userNameTF.text.length)];
        [self.userNameTF hideValidateError];
    }
}

- (void) updateUsername {
    username_update *param = [[username_update alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] username:self.userNameTF.text];
    if (param) {
        API_Profile_UpdateUserName *api = [[API_Profile_UpdateUserName alloc] initWithParams:param];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
            if (response.status) {
                [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
//                EditProfileViewController *view = (EditProfileViewController *)_parentView;
//                [view loadProfileMeUsingAPI];
                self.profileData.username = self.userNameTF.text;
                [userDefaultManager saveUserProfileData:self.profileData];
                [NotificationHelper postNotificationForUpdatingProfileUsername:self.userNameTF.text];
                
                [self dismissViewControllerAnimated:TRUE completion:^{
                }];
            } else {
                [self.userNameTF setError: response.message animated:TRUE];
//                [AppHelper showMessageBox:nil message:response.message];
            }
        } ErrorHandlure:^(NSError *error) {
        }];
    } else {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }
}

- (void) updateName {
    name_update *param = [[name_update alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] name:self.dislayNameTF.text];
    if (param) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
        API_Profile_UpdateName *api = [[API_Profile_UpdateName alloc] initWithParams:param];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            if (response.status) {
//                EditProfileViewController *view = (EditProfileViewController *)_parentView;
//                [view loadProfileMeUsingAPI];
                [NotificationHelper postNotificationForUpdatingProfileName:self.dislayNameTF.text];
                self.profileData.name = self.dislayNameTF.text;
                [userDefaultManager saveUserProfileData:self.profileData];
                if (!self.isChangeUserName) {
                    [self updateUsername];
                } else {
                    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
                    [self dismissViewControllerAnimated:TRUE completion:^{
                    }];
                }
            } else {
                [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
//                [AppHelper showMessageBox:nil message:response.message];
                [self.dislayNameTF setError: response.message animated:TRUE];
            }
        } ErrorHandlure:^(NSError *error) {
            
        }];
    }
    
}

- (void)keyboardWillShow:(NSNotification *) notif
{
    NSDictionary *userInfo = [notif userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGFloat yFrame = self.view.bounds.size.height - self.rectKeyboard.y;
    CGFloat offSet = yFrame - kbSize.height - 5;
    offSetSave = offSet;
    if (offSet < 0) {
        [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
            self.view.frame = CGRectMake(0, self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height + offSet, self.view.bounds.size.width, self.view.bounds.size.height);
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
