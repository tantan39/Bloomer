//
//  UIView+Extension.h
//  Bloomer
//
//  Created by Tran Thai Tan on 6/2/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Extension.h"
@interface UIView (Extension)

- (void) roundedBorderCornerForTextField;

- (void) roundedBorderCornerForButton;

- (void) roundedBorderCornerForGenderButton;

- (void) setStyleWhiteButton;

- (void) setDefaultBorder;

- (void) roundCornersWithCorners:(UIRectCorner ) corners Radius:(CGFloat) radius;

- (NSArray*)getConstraintsWithParent:(UIView*)parentView top:(CGFloat)top bottom:(CGFloat)bottom left:(CGFloat)left right:(CGFloat)right;

@end
