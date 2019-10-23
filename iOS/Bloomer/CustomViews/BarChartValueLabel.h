//
//  ValueLabelForBarchart.h
//  MyChartDemo
//
//  Created by Ahri on 7/14/17.
//  Copyright © 2017 Bloomer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Extension.h"

@interface BarChartValueLabel : UIView

@property (weak, nonatomic) NSMutableArray<NSNumber *> *barChartValues;

@property (nonatomic, strong) UIColor *chartValueColor;

- (void)setTitleWithColor;

@end
