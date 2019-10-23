//
//  EnterPasswordViewController.h
//  Bloomer
//
//  Created by Tran Thai Tan on 11/30/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Extension.h"
#import "UITextField+Extension.h"
#import "API_Auth_Authorize.h"
#import "BloomerManager.h"
#import "UserDefaultManager.h"
#import "API_Profile_Me.h"
#import "LocalNotificationHelper.h"
#import "TabBarViewController.h"
@interface EnterPasswordViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (strong,nonatomic) NSString * phoneNumber;
@property (strong,nonatomic) NSString * fbToken;
@property (weak, nonatomic) IBOutlet UIButton *btnShowHidePass;

@end
