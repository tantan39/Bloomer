//
//  CreatePasswordViewController.h
//  Bloomer
//
//  Created by Tran Thai Tan on 11/29/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ConfirmInfoViewController.h"
#import "UserDefaultManager.h"
#import "UpdateInfoViewController.h"
@interface CreatePasswordViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@property (strong,nonatomic) NSString * phoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *btnShowHidePass;

@end
