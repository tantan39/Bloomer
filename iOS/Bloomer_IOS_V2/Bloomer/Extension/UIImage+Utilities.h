//
//  UIImage+Utilities.h
//  FoodFlow
//
//  Created by Kishikawa Katsumi on 11/09/05.
//  Copyright (c) 2011 Kishikawa Katsumi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UIImage(Utilities)
- (UIImage *)croppedImage:(CGRect)bounds;
- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality;
- (CGAffineTransform)transformForOrientation:(CGSize)newSize;
- (CGRect)convertCropRect:(CGRect)cropRect;
- (UIImage *)compressForUpload:(UIImage *)original :(CGFloat)scale;
-(UIImage *) circleMask;
-(UIImage *) circleMaskWithBorder;
-(UIImage *) normalMask;
+ (void) loadImageFromURL:(NSString *) strURL SuccessBlock:(void(^)(UIImage*) )successBlock;

@end
