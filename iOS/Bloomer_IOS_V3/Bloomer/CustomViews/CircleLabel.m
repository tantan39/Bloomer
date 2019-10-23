//
//  CustomRoundDisplayLabel.m
//  MyChartDemo
//
//  Created by Ahri on 7/18/17.
//  Copyright © 2017 Bloomer. All rights reserved.
//

#import "CircleLabel.h"
#import "UIColor+Extension.h"

@interface CircleLabel () {
}

@end

@implementation CircleLabel

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
    
    [self customRoundShape];
}

- (void)customRoundShape {
    self.layer.shouldRasterize = true;
    self.layer.rasterizationScale = UIScreen.mainScreen.scale;
    
    if (self.backgroundColor == nil) {
        self.backgroundColor = [UIColor rgb:176 green:36 blue:42];
    }
    if (self.customTextColor == nil) {
        self.customTextColor = UIColor.whiteColor;
    }
    self.textAlignment = NSTextAlignmentCenter;
    self.font = [UIFont systemFontOfSize:14.f weight:UIFontWeightMedium];
    self.textColor = self.customTextColor;
    self.layer.masksToBounds = true;
    self.layer.cornerRadius = self.frame.size.height / 2;
    self.layer.backgroundColor = self.backgroundColor.CGColor;
    
    self.translatesAutoresizingMaskIntoConstraints = false;
}

- (void)setButtonColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor {
    if (backgroundColor == nil) {
        backgroundColor = [UIColor rgb:176 green:36 blue:42];
    }
    if (textColor == nil) {
        textColor = UIColor.whiteColor;
    }
    self.backgroundColor = backgroundColor;
    self.textColor = textColor;
}

@end
