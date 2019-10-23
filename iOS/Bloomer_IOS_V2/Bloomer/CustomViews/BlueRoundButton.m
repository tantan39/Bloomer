//
//  BlueRoundButton.m
//  MyChartDemo
//
//  Created by Ahri on 7/20/17.
//  Copyright © 2017 Bloomer. All rights reserved.
//

#import "BlueRoundButton.h"
#import "UIColor+Extension.h"

@implementation BlueRoundButton

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
    
    [self customButtonShape];
}

- (void)customButtonShape {
    self.layer.opaque = true;
    self.layer.shouldRasterize = true; // cache it
    self.layer.rasterizationScale = UIScreen.mainScreen.scale;
    
    self.backgroundColor = [UIColor rgb:77 green:142 blue:223];
    [self setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.titleLabel setFont:[UIFont systemFontOfSize:15.f weight:UIFontWeightMedium]];
    self.layer.masksToBounds = true;
    if (self.cornerRadius != nil) {
        self.layer.cornerRadius = [self.cornerRadius floatValue];
    } else {
        self.layer.cornerRadius = self.frame.size.height / 2;
    }
}

- (void)setButtonColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor {
    if (backgroundColor == nil) {
        backgroundColor = [UIColor rgb:77 green:142 blue:223];
    }
    if (textColor == nil) {
        textColor = UIColor.whiteColor;
    }
    self.backgroundColor = backgroundColor;
    [self setTitleColor:textColor forState:UIControlStateNormal];
}

@end
