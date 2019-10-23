//
//  RightRoundCornerLabel.m
//  MyChartDemo
//
//  Created by Ahri on 7/20/17.
//  Copyright © 2017 Bloomer. All rights reserved.
//

#import "RightRoundCornerLabel.h"
#import "UIColor+Extension.h"

@interface RightRoundCornerLabel ()

@property (nonatomic, weak) UILabel *myLabel;

@end

@implementation RightRoundCornerLabel

// load from nib
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}

// custom init with frame
- (id)initWithFrame:(CGRect)aRect {
    if (self = [super initWithFrame:aRect]) {
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (int i = 0; i < self.subviews.count; i++) {
        [self.subviews[i] removeFromSuperview];
    }
    [self customRoundCornerForSuperview];
    UIView *shadowView = [self insertShadowView];
    [self insertLabel:shadowView];
}

- (void)customRoundCornerForSuperview {
    self.layer.opaque = true;
    self.layer.shouldRasterize = true;
    self.layer.rasterizationScale = UIScreen.mainScreen.scale;
    self.backgroundColor = UIColor.clearColor;
    CGFloat superViewRadius = self.bounds.size.height / 2;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                               byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight
                                                     cornerRadii:CGSizeMake(superViewRadius, superViewRadius)];
    CAShapeLayer *superViewLayer = [CAShapeLayer layer];
    superViewLayer.frame = self.bounds;
    [superViewLayer setPath:path.CGPath];
    superViewLayer.masksToBounds = true;
    self.layer.mask = superViewLayer;
}

- (UIView *)insertShadowView {
    // Add Shadow to UIView
    CGFloat leftMargin = 0.f;
    CGFloat topMargin = 0.4f;
    CGFloat rightMargin = 2.0f;
    CGFloat bottomMargin = 3.5f;
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(leftMargin, topMargin,
                                                                  self.frame.size.width - rightMargin,
                                                                  self.frame.size.height - bottomMargin)];
    shadowView.layer.opaque = true;
    shadowView.layer.shouldRasterize = true;
    shadowView.layer.rasterizationScale = UIScreen.mainScreen.scale;
    
    CGFloat shadowCornerRadius = CGRectGetHeight(shadowView.bounds) / 2;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:shadowView.bounds
                                                     byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight
                                                           cornerRadii:CGSizeMake(shadowCornerRadius, shadowCornerRadius)];
    shadowView.layer.shadowPath = shadowPath.CGPath;
    shadowView.layer.masksToBounds = false;
    shadowView.backgroundColor = UIColor.clearColor;
    shadowView.layer.shadowColor = UIColor.grayColor.CGColor;
    shadowView.layer.shadowOpacity = 0.45f;
    shadowView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
    return shadowView;
}

- (void)insertLabel:(UIView *)shadowView {
    // Add UILabel on top of shadowView
    UILabel *label = [[UILabel alloc] initWithFrame:shadowView.bounds];
    label.layer.shouldRasterize = true;
    label.layer.rasterizationScale = UIScreen.mainScreen.scale;
    CGFloat labelRadius = label.bounds.size.height / 2;
    UIBezierPath *labelPath = [UIBezierPath bezierPathWithRoundedRect:label.bounds
                                                    byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight
                                                          cornerRadii:CGSizeMake(labelRadius, labelRadius)];
    CAShapeLayer *labelMaskLayer = [CAShapeLayer layer];
    labelMaskLayer.frame = label.bounds;
    [labelMaskLayer setPath:labelPath.CGPath];
    label.layer.mask = labelMaskLayer;
    
    [label setFont:[UIFont fontWithName:@"SFUIDisplay-Regular" size:18]];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.backgroundColor = UIColor.whiteColor;
    if (self.labelTitle != nil) {
        [label setText:self.labelTitle];
    }
    
    [shadowView addSubview:label];
    [self addSubview:shadowView];
    self.myLabel = label;
}

@end
