//
//  RepositionViewController.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 5/15/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "image_photo.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"
#import "out_auth_register_verifycode.h"
#import "UserDefaultManager.h"
#import "MKNumberBadgeView.h"

@interface RepositionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UIView *gridView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;

@property (weak, nonatomic) NSString *postID;
@property (weak, nonatomic) NSString *photoURL;
@property (weak, nonatomic) UIImageView *needRepositionPhoto;
@property (weak, nonatomic) NSMutableArray *croppedRects;
@property (assign, nonatomic) NSInteger currentIndex;
@property (strong, nonatomic) image_photo *imagePhotoAPI;

@end
