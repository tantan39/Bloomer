//
//  ValueLabelForBarchart.m
//  MyChartDemo
//
//  Created by Ahri on 7/14/17.
//  Copyright © 2017 Bloomer. All rights reserved.
//

#import "BarChartValueLabel.h"

@interface BarChartValueLabel() {
    CGFloat subViewOffset;
    CGFloat labelMargin;
}

@end

@implementation BarChartValueLabel

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
    subViewOffset = 0.5f;
    labelMargin = 3.f;
    [self customSupviewRoundShape];
    UIView *shadowView = [self insertShadowView];
    [self insertLabel:shadowView];
    [self customFontForLabel];
}

- (void)customSupviewRoundShape {
    [self setBackgroundColor:UIColor.clearColor];
    self.layer.masksToBounds = true;
    self.layer.cornerRadius = self.frame.size.height / 2;
}

- (UIView *)insertShadowView {
    // Add Shadow to bar chart
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(subViewOffset, subViewOffset,
                                                                  self.frame.size.width - labelMargin,
                                                                  self.frame.size.height - labelMargin)];
    shadowView.layer.opaque = true;
    shadowView.layer.shouldRasterize = true; // cache it
    shadowView.layer.rasterizationScale = UIScreen.mainScreen.scale;
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:shadowView.bounds
                                                          cornerRadius:CGRectGetHeight(shadowView.bounds) / 2];
    shadowView.layer.shadowPath = shadowPath.CGPath;
    shadowView.layer.masksToBounds = false;
    shadowView.backgroundColor = UIColor.clearColor;
    shadowView.layer.shadowColor = [UIColor grayColor].CGColor;
    shadowView.layer.shadowOpacity = 0.2f;
    shadowView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    [self addSubview:shadowView];
    
    return shadowView;
}

- (void)insertLabel:(UIView *)shadowView {
    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(subViewOffset, subViewOffset,
                                                                    self.frame.size.width - labelMargin,
                                                                    self.frame.size.height - labelMargin)];
    valueLabel.layer.opaque = true;
    valueLabel.layer.shouldRasterize = true;
    valueLabel.layer.rasterizationScale = UIScreen.mainScreen.scale;
    
    valueLabel.backgroundColor = UIColor.whiteColor;
    valueLabel.layer.masksToBounds = true;
    valueLabel.layer.cornerRadius = valueLabel.frame.size.height / 2;
    [shadowView addSubview:valueLabel];
}

- (void)customFontForLabel {
    UILabel *valueLabel = (UILabel *) self.subviews[0].subviews[0];
    [valueLabel setFont:[UIFont systemFontOfSize:12.f weight:UIFontWeightRegular]];
    [valueLabel setTextAlignment:NSTextAlignmentCenter];
}

- (void)setTitleWithColor {
    UILabel *valueLabel = (UILabel *)self.subviews[0].subviews[0];
    if (valueLabel && self.barChartValues.count > 0) {
        NSMutableAttributedString *text;
        if (self.barChartValues.count == 2) {
            [valueLabel setText:[NSString stringWithFormat:@"%li / %li",
                                 (long)[self.barChartValues[0] integerValue],
                                 (long)[self.barChartValues[1] integerValue]]];
            
            text = [[NSMutableAttributedString alloc] initWithAttributedString: valueLabel.attributedText];
        } else {
            [valueLabel setText:[NSString stringWithFormat:@"%li",
                                 (long)[self.barChartValues[0] integerValue]]];
            text = [[NSMutableAttributedString alloc] initWithAttributedString: valueLabel.attributedText];
        }
        
        if (self.chartValueColor == nil) {
            self.chartValueColor = [UIColor rgb:174 green:14 blue:25];
        }
        int curScore = (int) [self.barChartValues[0] integerValue];
        NSString *curScoreStrValue = [NSString stringWithFormat:@"%d", curScore];
        [text addAttribute:NSForegroundColorAttributeName
                     value:self.chartValueColor
                     range:NSMakeRange(0, [curScoreStrValue length])];
        [valueLabel setAttributedText: text];
    }
}

@end
