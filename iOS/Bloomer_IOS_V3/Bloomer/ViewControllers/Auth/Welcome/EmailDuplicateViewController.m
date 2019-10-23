//
//  EmailDuplicateViewController.m
//  Bloomer
//
//  Created by Phan Van Thanh Dat on 12/4/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "EmailDuplicateViewController.h"
#import "AppHelper.h"
#import "LoginViewController.h"

@interface EmailDuplicateViewController ()

@end

@implementation EmailDuplicateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.btnCancel.layer setCornerRadius:4.0f];
    [self.btnSignIn.layer setCornerRadius:4.0f];
    if (self.message == nil) {
        self.message = @"";
    }
    self.lblMessage.text = [NSString stringWithFormat:[AppHelper getLocalizedString:@"EmailDuplicateViewController.message"], self.message];

}

- (IBAction)touchSignIn:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:^{
        LoginViewController *view = [[LoginViewController alloc] initWithNibName:[AppHelper getScreenNameView:@"LoginViewController"] bundle:nil];
        [self.navicontroller pushViewController:view animated:TRUE];
    }];
}

- (IBAction)touchCancel:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}
@end
