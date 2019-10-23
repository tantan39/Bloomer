//
//  SimpleHorizontalBarChart.m
//  MyChartDemo
//
//  Created by Ahri on 7/14/17.
//  Copyright © 2017 Bloomer. All rights reserved.
//

#import "SimpleHorizontalBarChart.h"
#import "UIColor+Extension.h"

@interface SimpleHorizontalBarChart () {
    CGFloat chartCornerRadius;
}

@end

@implementation SimpleHorizontalBarChart

// load from nib
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initDefaultStatistics];
    }
    return self;
}

// custom init with frame
- (id)initWithFrame:(CGRect)aRect {
    if (self = [super initWithFrame:aRect]) {
        [self initDefaultStatistics];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIView *v in [self subviews]) {
        [v removeFromSuperview];
    }
    [self drawBarchartBackground];
    [self drawForegroundRect];
    [self animeCharRect];
}

- (void)initDefaultStatistics {
    chartCornerRadius = self.frame.size.height / 2;
    if (self.startColor == nil) {
        self.startColor = [UIColor rgb:147 green:57 blue:62];
    }
    if (self.endColor == nil) {
        self.endColor = [UIColor rgb:200 green:68 blue:75];
    }
    if (self.animationDuration == nil) {
        self.animationDuration = @1.5;
    }
}

- (void)drawBarchartBackground {
    self.backgroundColor = UIColor.whiteColor;
    self.layer.cornerRadius = chartCornerRadius;
    
    // Add Border to bar chart
//    self.layer.borderColor = [UIColor rgb:240 green:240 blue:240].CGColor;
//    self.layer.borderWidth = 1.0f;
    
    /* Add Shadow to bar chart */
    // Performance Optimization for Layer
    self.layer.opaque = true;
    self.layer.shouldRasterize = true; // cache it
    self.layer.rasterizationScale = UIScreen.mainScreen.scale;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                    cornerRadius:3.5f];
    self.layer.shadowPath = path.CGPath;
    self.layer.masksToBounds = false;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.2f;
    self.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
}

- (void)drawForegroundRect {
    UIView *frontRect = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, self.bounds.size.height)];
    frontRect.layer.opaque = true;
    frontRect.layer.masksToBounds = true;
    frontRect.layer.cornerRadius = chartCornerRadius;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.opaque = true;
    gradient.frame = frontRect.frame;
    gradient.colors = @[(id)self.startColor.CGColor, (id)self.endColor.CGColor];
    [gradient setStartPoint:CGPointMake(0.0, 0.5)];
    [gradient setEndPoint:CGPointMake(1.0, 0.5)];
    [frontRect.layer insertSublayer:gradient atIndex:0];
    
    [self addSubview:frontRect];
}

- (void)animeCharRect {
    if (self.ratio == nil) {
        return;
    }
    UIView *frontRect = self.subviews.firstObject;
    CGFloat newWidth = self.bounds.size.width * [self.ratio floatValue];
    [UIView animateWithDuration:1.0 animations:^(void) {
        [frontRect setFrame:CGRectMake(0, 0, newWidth, self.bounds.size.height)];
        [frontRect.layer.sublayers.firstObject setFrame:CGRectMake(0, 0, newWidth, self.bounds.size.height)];
    }];
}

@end
