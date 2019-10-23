//
//  ImagePickerPopUpViewController.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 6/15/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarView.h"
#import "MKNumberBadgeView.h"
#import "API_Avatar_Attached.h"
#import "API_Profile_Gallery_Fetches.h"

@protocol ImagePickerPopUpVCDelegate <NSObject>

- (void) selectedImageFromImagePicker:(UIImage *) image;

@end

@interface ImagePickerPopUpViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) MKNumberBadgeView* badgeNumber;
@property (weak, nonatomic) UIViewController *parentView;
@property (weak, nonatomic) NSString *raceName;
@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) NSString* tag;
@property (assign, nonatomic) BOOL isUploadAvatar;

@property (weak,nonatomic) id<ImagePickerPopUpVCDelegate> delegate;

- (IBAction)touchBackground:(id)sender;

- (void)showInView:(UIView *)aView animated:(BOOL)animated;

@end
