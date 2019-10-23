//
//  GroupButtonWithColor.m
//  MyChartDemo
//
//  Created by Ahri on 7/20/17.
//  Copyright © 2017 Bloomer. All rights reserved.
//

#import "GroupButtonWithColor.h"
#import "UIColor+Extension.h"

@interface GroupButtonWithColor () {
}

@end

@implementation GroupButtonWithColor

// load from nib
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupButton];
    }
    return self;
}

// custom init with frame
- (id)initWithFrame:(CGRect)aRect {
    if (self = [super initWithFrame:aRect]) {
        [self setupButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setupButton {
//    [self addTarget:self action:@selector(didTouchButton) forControlEvents:UIControlEventTouchUpInside];
    if (self.touchupColor == nil) {
        self.touchupColor = [UIColor rgb:37 green:37 blue:41];
    }
    if (self.normalColor == nil) {
        self.normalColor = [UIColor rgb:119 green:119 blue:119];
    }
    [self setTitleColor:self.normalColor forState:UIControlStateNormal];
}

- (void)didTouchButton {
    [self setTitleColor:self.touchupColor forState:UIControlStateNormal];
    [self.titleLabel setFont: [UIFont fontWithName:@"SFProText-Semibold" size:12]];
    for (int i = 0; i < self.buttonsGroup.count; i++) {
        if (self != self.buttonsGroup[i]) {
            [self.buttonsGroup[i] setTitleColor:self.normalColor forState:UIControlStateNormal];
            [self.buttonsGroup[i].titleLabel setFont: [UIFont fontWithName:@"SFProText-Regular" size:12]];
        }
    }
}

- (void)setGroupButtonNormalColor:(UIColor *)color touchUpColor:(UIColor *)touchUpColor {
    self.normalColor = color;
    self.touchupColor = touchUpColor;
    [self setTitleColor:self.normalColor forState:UIControlStateNormal];
}

@end
