//
//  UpdateAvatarSignUpVC.h
//  Bloomer
//
//  Created by Tran Thai Tan on 6/7/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Extension.h"
#import "TabBarViewController.h"
#import "LocalNotificationHelper.h"
#import "ImagePickerPopUpViewController.h"
#import "UIImage+Utilities.h"
#import "API_Auth_Register.h"
#import "API_Profile_Me.h"
#import "API_Avatar_Attached.h"
@interface UpdateAvatarSignUpVC : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgvAvatar;
@property (weak, nonatomic) IBOutlet UIButton *btnChangePicture;

@property (weak, nonatomic) IBOutlet UIButton *btnComplete;
@property (weak, nonatomic) IBOutlet UIButton *btnSkip;
@property UIImage * avatarUpdate;

@property auth_register * registerModel;


@end
