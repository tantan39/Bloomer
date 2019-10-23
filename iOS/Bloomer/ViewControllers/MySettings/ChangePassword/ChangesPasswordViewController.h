//
//  ChangesPasswordViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/27/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API_Profile_ChangePassword.h"
#import "UserDefaultManager.h"
#import "UITextField+Extension.h"
#import "UIColor+Extension.h"
#import "TTMessageView.h"
#import "NSString+Extension.h"

@interface ChangesPasswordViewController : UIViewController 
@property (weak, nonatomic) IBOutlet UITextField *currentPassword;
@property (weak, nonatomic) IBOutlet UITextField *passwordNew;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) IBOutlet UIButton *showCurrentPassButton;
@property (weak, nonatomic) IBOutlet UIButton *showNewPassButton;
@property (weak, nonatomic) IBOutlet UIButton *showConfirmPassButton;
@property (weak, nonatomic) IBOutlet UILabel *currentPassLabel;

@property (weak, nonatomic) IBOutlet UILabel *confirmPassLabel;

@property (weak, nonatomic) IBOutlet UILabel * lblNewPass;


- (IBAction)touchViewCurrentPassword:(id)sender;
- (IBAction)touchViewPasswordNew:(id)sender;

@end
