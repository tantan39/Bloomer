//
//  BlueRoundButton.h
//  MyChartDemo
//
//  Created by Ahri on 7/20/17.
//  Copyright © 2017 Bloomer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlueRoundButton : UIButton

@property (nonatomic, strong) NSNumber *cornerRadius;

- (void)setButtonColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor;

@end
