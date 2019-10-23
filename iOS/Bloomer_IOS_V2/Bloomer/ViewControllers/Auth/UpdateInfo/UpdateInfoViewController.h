//
//  UpdateInfoViewController.h
//  Bloomer
//
//  Created by Tran Thai Tan on 12/5/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextField+Extension.h"
//#import "API_Avatar_Attached.h"
#import "UserDefaultManager.h"
#import "API_Auth_Register.h"
#import "AppDelegate.h"
#import "API_LoadLocation.h"
#import "MFTextField.h"
#import "ImagePickerPopUpViewController.h"

@interface UpdateInfoViewController : UIViewController<UITextFieldDelegate,UINavigationControllerDelegate,ImagePickerPopUpVCDelegate>

@property (assign,nonatomic) NSInteger countryID;
@property (weak, nonatomic) IBOutlet UIImageView *imgvAvatar;
@property (weak, nonatomic) IBOutlet MFTextField *tfBirthDay;
@property (weak, nonatomic) IBOutlet MFTextField *tfLocation;
@property (weak, nonatomic) IBOutlet UIButton *btnGallery;

@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnSkip;

@property ImagePickerPopUpViewController * imagePickerPopup;
@property (strong,nonatomic) UIImage * imgUpload;
@property (strong, nonatomic) UIDatePicker *dateTimePicker;

@end
