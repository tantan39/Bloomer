//
//  UpdateSignUpViewController.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/3/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarView.h"
#import "auth_register.h"
//#import "auth_register_using.h"
#import "out_auth_authorize.h"
#import "UserDefaultManager.h"
#import "out_profile_fetch.h"
#import "TabBarViewController.h"
//#import "profile_me_using.h"
#import "out_profile_fetch.h"
#import "TWPhotoPickerController.h"
#import "ImagePickerPopUpViewController.h"
//#import "avatar_attached_using.h"
#import "ChooseLocationViewController.h"
#import "ChoosingAvatarViewController.h"

@interface UpdateSignUpViewController : UIViewController<UIGestureRecognizerDelegate, TWPhotoPickerDelegate, UITextFieldDelegate>
//@property (weak, nonatomic) IBOutlet UIImageView *avatar;
//@property (weak, nonatomic) IBOutlet UIButton *buttonAddPhoto;
//@property (weak, nonatomic) IBOutlet UIView *firstDot;
//@property (weak, nonatomic) IBOutlet UIView *secondDot;
//@property (weak, nonatomic) IBOutlet UIView *thirdDot;
@property (weak, nonatomic) IBOutlet UIButton *buttonMale;
@property (weak, nonatomic) IBOutlet UIButton *buttonFemale;
@property (weak, nonatomic) IBOutlet UIButton *buttonComplete;
//@property (weak, nonatomic) IBOutlet UIImageView *iconBubbleTriangle;
//@property (weak, nonatomic) IBOutlet UIImageView *iconBubbleTriangleError;
//@property (weak, nonatomic) IBOutlet UIView *bubbleErrorView;
//@property (weak, nonatomic) IBOutlet UIView *bubbleView;
@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
@property (weak, nonatomic) IBOutlet UITextField *tfIDName;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewCenterYConstraint;
@property (weak, nonatomic) IBOutlet UIButton *buttonChooseLocation;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonErrorWidth;
@property (weak, nonatomic) IBOutlet UILabel *labelErrorMessage;
//@property (weak, nonatomic) IBOutlet UIView *mainView;
//@property (weak, nonatomic) IBOutlet UITextField *textFieldInviteCode;

@property (weak, nonatomic) IBOutlet UILabel *labelErrorDisplay;
@property (weak, nonatomic) IBOutlet UIView *errorDisplayView;

@property (strong, nonatomic) TabBarView *tabbar;
//@property (assign, nonatomic) BOOL isUploadedPhoto;
@property (assign, nonatomic) NSInteger gender;
//@property (assign, nonatomic) NSInteger location_id;

@property auth_register * authRegister;

- (IBAction)touchDoneButton:(id)sender;
- (IBAction)touchAvatarButton:(id)sender;
- (IBAction)touchBackButton:(id)sender;
- (IBAction)touchChooseLocation:(id)sender;
- (IBAction)touchButtonMale:(id)sender;
- (IBAction)touchButtonFemale:(id)sender;
- (IBAction)touchButtonExplaination:(id)sender;
- (IBAction)touchButtonError:(id)sender;

@end
