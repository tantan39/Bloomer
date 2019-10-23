//
//  ChangeProfileViewController.h
//  Bloomer
//
//  Created by Phan Van Thanh Dat on 11/20/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFTextField.h"
#import "AppHelper.h"
#import "UserDefaultManager.h"
#import "out_profile_fetch.h"
#import "UIImageView+Extension.h"
#import "UpdateAvatarViewController.h"
#import "API_Profile_UpdateName.h"
#import "API_Profile_UpdateUserName.h"
#import "ChangeAboutMeViewController.h"
#import "UITextView+Placeholder.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChangeProfileViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet MFTextField *dislayNameTF;
@property (weak, nonatomic) IBOutlet UILabel *lengthDislayLabel;
@property (weak, nonatomic) IBOutlet MFTextField *userNameTF;
@property (weak, nonatomic) IBOutlet UILabel *lengthUsernamLabel;
@property (weak, nonatomic) IBOutlet UITextView *aboutMeTV;
@property (weak, nonatomic) IBOutlet UILabel *lengthAboutMeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintTV;
@property (assign,nonatomic) BOOL isChangeUserName;

@property (strong, nonatomic) out_profile_fetch *profileData;

@end

NS_ASSUME_NONNULL_END
