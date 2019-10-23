//
//  ChangeCaptionViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/21/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "ChangeCaptionViewController.h"
#import "NotificationHelper.h"

@interface ChangeCaptionViewController () {
    UserDefaultManager *userDefaultManager;
}

@end

@implementation ChangeCaptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    self.statusTextView.layer.cornerRadius = 20;
    self.statusTextView.layer.borderWidth = 1;
    self.statusTextView.layer.borderColor = [UIColor colorWithRed:0.831 green:0.831 blue:0.831 alpha:1.0].CGColor;
    self.statusTextView.text = self.caption;
    self.charCountLabel.text = [NSString stringWithFormat:@"%lu%@", (unsigned long)self.caption.length,
                                NSLocalizedString(@"ChangeCaption.charCountLabelText",)];
    
    [self initNavigationBar];
}

- (void)initNavigationBar {
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done",) style:UIBarButtonItemStyleDone target:self action:@selector(touchDoneButton)];
    doneButton.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItems:@[doneButton]];

    [AppHelper setTitleViewForNavigationBar:self.navigationItem title:NSLocalizedString(@"Edit Status", nil)];
}

- (IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchDoneButton {
    caption_update *params = [[caption_update alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                            device_token:[userDefaultManager getDeviceToken] status:self.statusTextView.text];
    if (params) {
        API_Profile_UpdateStatus *api = [[API_Profile_UpdateStatus alloc] initWithParams:params];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            if (response.status) {
                EditProfileViewController *view = (EditProfileViewController *)_parentView;
                [view loadProfileMeUsingAPI];
                [NotificationHelper postNotificationForUpdatingAboutMe:self.statusTextView.text];

                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [AppHelper showMessageBox:nil message:response.message];
            }
        } ErrorHandlure:^(NSError *error) {
            
        }];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK: - TextView Delegates

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"])
    {
        return NO;
    }
    return textView.text.length + (text.length - range.length) <= 140;
}

- (void)textViewDidChange:(UITextView *)textView {
    self.charCountLabel.text = [NSString stringWithFormat:@"%lu%@", (unsigned long)textView.text.length,
                                NSLocalizedString(@"ChangeCaption.charCountLabelText",)];
}

@end
