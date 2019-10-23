//
//  RedTextButton.h
//  MyChartDemo
//
//  Created by Ahri on 7/20/17.
//  Copyright © 2017 Bloomer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupButtonWithColor : UIButton

@property (nonatomic, strong) NSMutableArray<GroupButtonWithColor *> *buttonsGroup;
@property (nonatomic, strong) UIColor *touchupColor;
@property (nonatomic, strong) UIColor *normalColor;

- (void)setGroupButtonNormalColor:(UIColor *)color touchUpColor:(UIColor *)touchUpColor;
- (void)didTouchButton;

@end
