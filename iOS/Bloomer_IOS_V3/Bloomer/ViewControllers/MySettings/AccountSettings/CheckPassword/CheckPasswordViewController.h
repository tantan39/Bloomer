//
//  CheckPasswordViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/20/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API_CheckPassword.h"
#import "UserDefaultManager.h"
#import <CommonCrypto/CommonDigest.h>
#import "ConfirmationViewController.h"
#import "API_Profile_ChangeMobile.h"

@interface CheckPasswordViewController : UIViewController 
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) NSString* phoneNumber;

@property (weak, nonatomic) IBOutlet UIButton *showPassButton;

@end
