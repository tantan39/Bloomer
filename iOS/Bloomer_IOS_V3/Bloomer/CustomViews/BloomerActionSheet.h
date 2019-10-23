//
//  ImagePickerPopUpViewController.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 6/15/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BloomerActionSheet : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) void (^selectIndex)(NSInteger);
@property (strong, nonatomic) NSArray * list;
@property (assign, nonatomic) BOOL isShowCanel;
@property (strong,nonatomic) NSString * textCancel;
@property (weak, nonatomic) UIView *ownerView;

+ (id) createInView:(UIView *)view data: (NSArray*)data selectIndex: (void(^)(NSInteger)) selectIndex;
- (IBAction)touchBackground:(id)sender;
- (void)showWithAnimation:(BOOL)animated;

@end
