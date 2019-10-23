//
//  TWPhotoPickerController.h
//  InstagramPhotoPicker
//
//  Created by Emar on 12/4/14.
//  Copyright (c) 2014 wenzhaot. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TWPhotoPickerDelegate <NSObject>

- (void)photoPickerControllerDidCancel;

@end

@interface TWPhotoPickerController : UIViewController

@property (nonatomic, copy) void(^cropBlock)(UIImage *image);
@property (weak, nonatomic) id<TWPhotoPickerDelegate> delegate;

@end
