//
//  UIShadeView.h
//  Bloomer
//
//  Created by Le Chau Tu on 8/21/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIShadeView : UIView

@property (assign, nonatomic) BOOL blur;

-(id)initWithFrame:(CGRect)frame withBlur:(BOOL)blur;
-(id)initWithCoder:(NSCoder *)aDecoder withBlur:(BOOL)blur;

-(void)showInView:(UIView *)view withAnimation:(BOOL)animated;
-(void)showInView:(UIView *)view withAnimation:(BOOL)animated withMaskFrame:(CGRect)frame;
-(void)showInView:(UIView *)view withAnimation:(BOOL)animated withMaskFrame:(CGRect)frame withCornerRadius:(CGFloat)cornerRadius;

@end
