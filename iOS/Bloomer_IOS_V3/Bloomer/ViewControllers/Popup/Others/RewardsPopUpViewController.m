//
//  RewardsPopUpViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 10/6/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "RewardsPopUpViewController.h"

@interface RewardsPopUpViewController ()

@end

@implementation RewardsPopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor clearColor];
    
    CALayer *ScrlViewLayer = [_popUpView layer];
    [ScrlViewLayer setMasksToBounds:NO];
    //[ScrlViewLayer setShadowColor:[[UIColor lightGrayColor] CGColor]];
    //[ScrlViewLayer setShadowOpacity:10.0];
    //[ScrlViewLayer setShadowRadius:20.0];
    //[ScrlViewLayer setShadowOffset:CGSizeMake(0, 0)];
    [ScrlViewLayer setShouldRasterize:NO];
    [ScrlViewLayer setCornerRadius:20.0];
    [ScrlViewLayer setBorderColor:[UIColor lightGrayColor].CGColor];
    [ScrlViewLayer setBorderWidth:0.0];
    [ScrlViewLayer setShadowPath:[UIBezierPath bezierPathWithRect:_popUpView.bounds].CGPath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAnimate
{
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
}

- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [aView addSubview:self.view];
        if (animated) {
            [self showAnimate];
        }
    });
}

@end
