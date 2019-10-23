//
//  SimpleHorizontalBarChart.h
//  MyChartDemo
//
//  Created by Ahri on 7/14/17.
//  Copyright © 2017 Bloomer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleHorizontalBarChart : UIView

@property (strong, nonatomic) UIColor *startColor;
@property (strong, nonatomic) UIColor *endColor;
@property (strong, nonatomic) NSNumber *ratio;
@property (strong, nonatomic) NSNumber *animationDuration;

- (void)animeCharRect;

@end
