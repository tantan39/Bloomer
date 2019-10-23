//
//  UploadingPicturesViewController.h
//  Xinh
//
//  Created by Truong Thuan Tai on 12/17/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDefaultManager.h"
#import "post_create.h"
#import "API_PostCreate.h"
//#import "out_post_create.h"
#import "API_Avatar_Attached.h"
#import "out_avatar_attached.h"
#import "TabBarView.h"
#import "MKNumberBadgeView.h"
#import "ChoosingBannersViewController.h"
#import "childs.h"

@interface UploadingPicturesViewController : UIViewController <UITextViewDelegate,  UIGestureRecognizerDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *uploadedPhoto;
@property (weak, nonatomic) IBOutlet UITextView *editorField;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;
@property (weak, nonatomic) UIImage *chosenImage;
@property (weak, nonatomic) NSMutableArray *tag;
@property (weak, nonatomic) MKNumberBadgeView *badgeNumber;
@property (weak, nonatomic) UIViewController *parentView;
@property (weak, nonatomic) IBOutlet UILabel *lblPlaceholder;

- (IBAction)touchUploadButton:(id)sender;
- (IBAction)handlSingleTap:(id)sender;
@end
