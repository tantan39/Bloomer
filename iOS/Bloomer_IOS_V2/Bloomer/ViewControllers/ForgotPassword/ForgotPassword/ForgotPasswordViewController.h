//
//  ForgotPasswordViewController.h
//  Bloomer
//
//  Created by Phan Van Thanh Dat on 10/16/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDefaultManager.h"
#import "API_CheckPhoneExist.h"
#import "ConfirmationViewController.h"
#import "TextFieldValidator.h"
#import "EnterPasswordViewController.h"
#import "CountryPickerView.h"
#import "API_Auth_CheckPassword.h"
#import "UIButton+Extension.h"
#import "MFTextField.h"

@interface ForgotPasswordViewController : UIViewController<CountryPickerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet MFTextField *tfPhoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UILabel *lblCountryCode;
@end
