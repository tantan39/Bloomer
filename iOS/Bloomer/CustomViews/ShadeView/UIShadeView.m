//
//  UIShadeView.m
//  Bloomer
//
//  Created by Le Chau Tu on 8/21/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "UIShadeView.h"

@interface UIShadeView () {
    UIBlurEffect *blurEffect;
    UIVisualEffectView *effectView;
    UIView *shadeView;
    
    CGRect holeFrame;
}
@end

@implementation UIShadeView

-(id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame withBlur:NO];
}

-(id)initWithFrame:(CGRect)frame withBlur:(BOOL)blur {
    self = [super initWithFrame:frame];
    if (self) {
        _blur = blur;
        if(blur) {
            [self setupBlurView];
        } else {
            [self setupShadeView];
        }
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithCoder:aDecoder withBlur:NO];
}

-(id)initWithCoder:(NSCoder *)aDecoder withBlur:(BOOL)blur{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _blur = blur;
        if(blur) {
            [self setupBlurView];
        } else {
            [self setupShadeView];
        }
    }
    return self;
}

-(void)setBlur:(BOOL)blur {
    _blur = blur;
    if(blur) {
        [self setupBlurView];
    } else {
        [self setupShadeView];
    }
}

-(void)removeAllSubview {
    if(shadeView != nil) {
        [shadeView removeFromSuperview];
    }
    
    if(effectView != nil) {
        [effectView removeFromSuperview];
    }
}

-(void)setupBlurView {
    [self removeAllSubview];
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = self.bounds;
    effectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:effectView];
}

-(void)setupShadeView {
    [self removeAllSubview];
    shadeView = [[UIView alloc] initWithFrame:self.bounds];
    shadeView.backgroundColor = UIColor.blackColor;
    shadeView.alpha = 0.8;
    shadeView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:shadeView];
}

-(void)showInView:(UIView *)view withAnimation:(BOOL)animated withMaskFrame:(CGRect)frame withCornerRadius:(CGFloat)cornerRadius {
    self.frame = view.bounds;
    [self createMaskWithFrame:frame withCornerRadius:cornerRadius];
    [view addSubview:self];
    if(animated) {
        self.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
            if(finished) {
                NSTimer *timer __attribute__((unused)) = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeWithAnimation) userInfo:nil repeats:NO];
            }
        }];
    }
}

-(void)showInView:(UIView *)view withAnimation:(BOOL)animated {
    [self showInView:view withAnimation:animated withMaskFrame:CGRectZero];
}

-(void)showInView:(UIView *)view withAnimation:(BOOL)animated withMaskFrame:(CGRect)frame {
    [self showInView:view withAnimation:animated withMaskFrame:frame withCornerRadius:0];
}

-(void)removeWithAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

-(void)createMaskWithFrame:(CGRect)frame withCornerRadius:(CGFloat)cornerRadius {
    holeFrame = frame;
    
    UIView *view;
    if (_blur) {
        view = effectView;
    } else {
        view = shadeView;
    }
    //Create mask whose size matches the view
    UIView *maskView = [[UIView alloc] initWithFrame:view.bounds];
    maskView.clipsToBounds = YES;
    maskView.backgroundColor = UIColor.clearColor;
    UIBezierPath *outerBezierPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds cornerRadius:0];
    
    //Create the hole with given frame
    UIBezierPath *innerBezierPath = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:cornerRadius];
    
    //Apply the hole on mask
    [outerBezierPath appendPath:innerBezierPath];
    outerBezierPath.usesEvenOddFillRule = YES;
    
    //Create layer from mask w/ hole on it
    CAShapeLayer *fillLayer = [[CAShapeLayer alloc] init];
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = UIColor.greenColor.CGColor;
    fillLayer.path = outerBezierPath.CGPath;
    
    //Apply layer on maskView
    [maskView.layer addSublayer:fillLayer];
    view.maskView = maskView;
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if(CGRectContainsPoint(holeFrame, point)) {
        [self removeFromSuperview];
        return NO;
    } else {
        return YES;
    }
}

@end
