//
//  CustomRankingPanel.m
//  MyChartDemo
//
//  Created by Ahri on 7/17/17.
//  Copyright © 2017 Bloomer. All rights reserved.
//

#import "CustomRankingPanel.h"
#import "UIColor+Extension.h"

@interface CustomRankingPanel () {
}

@end

@implementation CustomRankingPanel

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
    
    [self drawBarchartBackground];
}

- (void)initDefaultStatistics {
    if (self.cornerRadius == nil) {
        self.cornerRadius = @8;
    }
}

- (void)drawBarchartBackground {
    // Add Border to bar chart
    //    self.layer.borderColor = [UIColor rgb:240 green:240 blue:240].CGColor;
    //    self.layer.borderWidth = 1.0f;
    
    // Add Shadow to bar chart
    self.layer.cornerRadius = [self.cornerRadius floatValue];
    self.layer.opaque = true;
    self.layer.shouldRasterize = true; // cache it
    self.layer.rasterizationScale = UIScreen.mainScreen.scale;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                    cornerRadius:[self.cornerRadius floatValue]];
    self.layer.shadowPath = path.CGPath;
    self.layer.masksToBounds = false;
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOpacity = 0.3f;
    self.layer.shadowOffset = CGSizeMake(1.5f, 1.5f);
}

@end
