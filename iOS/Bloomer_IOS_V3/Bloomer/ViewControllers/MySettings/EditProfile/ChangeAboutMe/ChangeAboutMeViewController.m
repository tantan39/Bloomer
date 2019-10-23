//
//  ChangeAboutMeViewController.m
//  Bloomer
//
//  Created by Phan Van Thanh Dat on 12/11/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "ChangeAboutMeViewController.h"

@interface ChangeAboutMeViewController ()  {
    UserDefaultManager *userDefaultManager;
    UITextView* textviewhide;
}

@end

@implementation ChangeAboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    userDefaultManager = [[UserDefaultManager alloc] init];
    self.profileData = [userDefaultManager getUserProfileData];
    self.aboutMeTV.delegate = self;
    [self setData];
    [self initButtonBar];
    self.aboutMeTV.placeholder = [AppHelper getLocalizedString:@"ChangeAboutMeViewController.placeholderTextview"];
    textviewhide.font = self.aboutMeTV.font;
}

- (void)viewDidAppear:(BOOL)animate {
    [super viewDidAppear:animate];
    [self.aboutMeTV becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:TRUE];
}

- (void) setData {
    self.aboutMeTV.text = self.profileData.about_me;
    self.heightConstraintTV.constant = [AppHelper getHightTextView:self.profileData.about_me font:self.aboutMeTV.font with:self.aboutMeTV.frame.size.width];
    [self.view layoutIfNeeded];
    [self textViewDidChange:self.aboutMeTV];
}

- (void) initButtonBar {
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle: [AppHelper getLocalizedString:@"ChangeAboutMeViewController.save"]  style:UIBarButtonItemStylePlain target:self action:@selector(touchsaveButton)];
    saveButton.tintColor = [UIColor rgb:74 green:144 blue:226];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:/*notificationButton,*/ saveButton, nil]];
    
    self.navigationItem.title = [AppHelper getLocalizedString:@"ChangeAboutMeViewController.title"];
}
- (IBAction)touchBackground:(id)sender {
    [self.view endEditing:TRUE];
}

- (void)touchsaveButton {
    [self.view endEditing:TRUE];
    
    if ([self.aboutMeTV.text isEqualToString: self.profileData.about_me]) {
        [self.navigationController popViewControllerAnimated:TRUE];
        return; 
    }
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
    caption_update *params = [[caption_update alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] status:self.aboutMeTV.text];
    if (params) {
        API_Profile_UpdateStatus *api = [[API_Profile_UpdateStatus alloc] initWithParams:params];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
            if (response.status) {
                self.updateStatus(self.aboutMeTV.text);
                [self.navigationController popViewControllerAnimated:TRUE];
            } else {
                [AppHelper showMessageBox:nil message:response.message];
            }
        } ErrorHandlure:^(NSError *error) {
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        }];
    }
    
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
        [self.view layoutIfNeeded];
    }];
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView {
    self.lengAboutMeLabel.text = [NSString stringWithFormat: @"%lu/120", (unsigned long)(textView.text.length)];
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length + string.length > 20 && range.length == 0) {
        return NO;
    }
    return YES;
}

@end
