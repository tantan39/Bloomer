//
//  UpdateInfoFBViewController.h
//  Bloomer
//
//  Created by Phan Van Thanh Dat on 11/27/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API_Auth_Register.h"
#import "BLSwitchControl.h"
#import "ActiveSubstringTextView.h"
#import "UserDefaultManager.h"
#import "AppDelegate.h"
#import "API_Auth_FBRegister.h"
#import "MFTextField.h"
#import "MyProfileViewController.h"
#import "EmailDuplicateViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UpdateInfoFBViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) IBOutlet BLSwitchControl *gender;
@property (strong, nonatomic) IBOutlet MFTextField *nameTF;
@property (strong, nonatomic) IBOutlet UIButton *doneBtn;
@property (strong, nonatomic) IBOutlet UILabel *policyLable;
@property (strong, nonatomic) IBOutlet ActiveSubstringTextView *policyTV;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightBottomConstrainBtnDone;

@property (assign, nonatomic) NSInteger country_id;

- (IBAction)changeGender:(id)sender;
- (IBAction)touchDoneBtn:(id)sender;
@end

NS_ASSUME_NONNULL_END
