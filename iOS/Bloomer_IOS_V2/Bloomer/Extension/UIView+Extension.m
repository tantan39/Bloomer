//
//  UIView+Extension.m
//  Bloomer
//
//  Created by Tran Thai Tan on 6/2/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)roundedBorderCornerForTextField
{
    self.layer.cornerRadius = 20;
    self.clipsToBounds = YES;
}

- (void)roundedBorderCornerForButton
{
    self.layer.cornerRadius = 23;
    self.clipsToBounds = YES;
}

- (void)roundedBorderCornerForGenderButton{
    self.layer.cornerRadius = 15;
    self.clipsToBounds = YES;
}

- (void)setStyleWhiteButton{
    self.layer.cornerRadius = 23;
    self.clipsToBounds = YES;
    self.layer.borderWidth = 2;
    self.layer.borderColor =  [UIColor colorFromHexString:@"#202021"].CGColor;
}

- (void)setDefaultBorder{
    CGFloat borderWidth = 1.0;
    UIColor * borderColor = [UIColor colorFromHexString:@"#C7C7C7"];
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = borderColor.CGColor;
}

- (void)roundCornersWithCorners:(UIRectCorner )corners Radius:(CGFloat)radius{
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.frame = self.bounds;
    layer.path = maskPath.CGPath;
    
    self.layer.mask = layer;
}

- (NSArray*)getConstraintsWithParent:(UIView*)parentView top:(CGFloat)top bottom:(CGFloat)bottom left:(CGFloat)left right:(CGFloat)right {
    
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:left];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:right];
    NSLayoutConstraint *topConstrains = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:top];
    NSLayoutConstraint *bottomConstrains = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:bottom];
    
    return @[leading, trailing, topConstrains, bottomConstrains];
}

@end

