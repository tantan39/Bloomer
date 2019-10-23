//
//  MatchingFlowerPopUpView.m
//  Bloomer
//
//  Created by Steven on 9/29/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "MatchingFlowerPopUpView.h"
#import "AppHelper.h"
#import "UILabel+Extension.h"
#import <stdlib.h>
#import "UIView+Extension.h"

@interface MatchingFlowerPopUpView ()
{
}

@property (strong, nonatomic) NSMutableArray *flowerViews;

@end

@implementation MatchingFlowerPopUpView

+ (id)createInView:(UIView*)view flowers:(NSInteger)flowers
{
    MatchingFlowerPopUpView *popupView = [[NSBundle mainBundle] loadNibNamed:@"MatchingFlowerPopUpView" owner:view options:nil][0];
    popupView.translatesAutoresizingMaskIntoConstraints = false;
    popupView.ownerView = view;
//    [popupView.labelBottom setFlowers:flowers imageString:@"Icon_Flower_White"];
    switch (flowers) {
        case 2:
            popupView.iconBonusMultiplier.image = [UIImage imageNamed:@"Icon_Triple"];
            break;
        case 1:
            popupView.iconBonusMultiplier.image = [UIImage imageNamed:@"Icon_Double"];
            break;
    }
    
    [popupView showWithAnimated:true];
//    [popupView randomFlowers];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [popupView removeAnimate];
    });
    
    return popupView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.mainView.layer.cornerRadius = self.mainView.frame.size.width / 2;
    self.mainView.clipsToBounds = true;
    
    self.flowerViews = [[NSMutableArray alloc] init];
    
    [self setupLanguage];
}

- (void)setupLanguage
{
    self.labelTop.text = [AppHelper getLocalizedString:@"matchingFlowerPopUp.topTitle"];
}

// MARK: - Required Functions
- (void)showAnimate
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        self.mainViewWidth.constant = 200;
        [UIView animateWithDuration:1 animations:^{
            [self layoutIfNeeded];
            self.mainView.alpha = 1;
            self.mainView.layer.cornerRadius = self.mainView.bounds.size.width / 2;
        } completion:^(BOOL finished) {
//            [self animateFlowers];
        }];
    }];
}

- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (void)showWithAnimated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.ownerView addSubview:self];
        [self.ownerView addConstraints:[self getConstraintsWithParent:self.ownerView top:0 bottom:0 left:0 right:0]];
        [self.ownerView layoutIfNeeded];
        
        if (animated)
        {
            [self showAnimate];
        }
    });
}

- (void)randomFlowers
{
    CGSize screenSize = UIScreen.mainScreen.bounds.size;
    CGFloat spacingX = 50;
    CGFloat spacingY = 30;
    CGFloat startX = -20;
    CGFloat startY = 70;
    CGFloat minSize = 20;
    CGFloat maxSize = 50;
    
    double nRows = ceil((screenSize.height - (startY * 3)) / (spacingY + (maxSize + minSize) / 2));
//    double maxElementsInARow = ceil((screenSize.width + 50) / (spacingX + maxSize));
    double maxElementsInARow = 7;
    NSInteger minElementsInARow = 4;
    
    NSLog(@"Row : %f", ceil(nRows));
    NSLog(@"Column : %f", ceil(maxElementsInARow));
    
    for (NSInteger i = 0; i < nRows; i++)
    {
        NSInteger thisRowTotalElement = [self randomInRangeWithMin:minElementsInARow max:maxElementsInARow];
        NSInteger thisRowStartY = startY + (i * (spacingY + (maxSize + minSize) / 2));
        CGFloat nextX = i % 2 ? startX + maxSize : startX;
        
        for (NSInteger j = 0; j < thisRowTotalElement; j++)
        {
            CGFloat maxSizeChance = [self randomInRangeWithMin:1 max:5];
            CGFloat size = maxSizeChance == 3 ? [self randomInRangeWithMin:40 max:50] : [self randomInRangeWithMin:20 max:30];
            CGFloat eSpacingX = [self randomInRangeWithMin:spacingX / 2 max:spacingX];
            CGFloat eSpacingY = [self randomInRangeWithMin:0 max:spacingY];
            
            UIImage *flower = [UIImage imageNamed:@"Icon_Flower_Gradient"];
            UIImageView *view = [[UIImageView alloc] initWithImage:flower];
            view.frame = CGRectMake(nextX + eSpacingX, thisRowStartY + eSpacingY, size, size);
//            view.alpha = 0;
            view.transform = CGAffineTransformMakeScale(0, 0);
            
            nextX += size + eSpacingX;
            
            [self addSubview:view];
            [self sendSubviewToBack:view];
            [self.flowerViews addObject:view];
        }
    }
}

- (void)animateFlowers
{
    for (NSInteger i = 0; i < self.flowerViews.count; i++)
    {
        UIView *view = self.flowerViews[i];
        
//        [UIView animateWithDuration:0.75 delay:([self randomInRangeWithMin:0 max:4] * 0.25) options:UIViewAnimationOptionCurveLinear animations:^{
//            view.alpha = 1;
//        } completion:^(BOOL finished) {
//        }];
        
        [UIView animateWithDuration:1 delay:([self randomInRangeWithMin:1 max:4] * 0.25) usingSpringWithDamping:0.3 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (NSInteger)randomInRangeWithMin:(NSInteger)min max:(NSInteger)max
{
    return min + arc4random_uniform((uint32_t)(max - min + 1));
}


@end
