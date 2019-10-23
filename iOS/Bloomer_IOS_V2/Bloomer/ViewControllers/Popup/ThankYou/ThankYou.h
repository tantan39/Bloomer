//
//  ThankYou.h
//  Bloomer
//
//  Created by VanLuu on 8/4/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Support.h"

@interface ThankYou : UIImageView
-(void) repositionToPoint:(CGPoint)point;
-(void) updatePotistion:(CGPoint)point andFrame:(CGRect)frame;
- (void)createAtPoint:(CGPoint)point andFrame:(CGRect)frame;
- (id)initWithStyle:(NSInteger)style atPoint:(CGPoint)point;
- (id)initWithStyle:(NSInteger)style atPoint:(CGPoint)point frame:(CGRect)frame;
- (void)clear;

- (NSInteger)popupStyle;
- (void)setPopupStyle:(NSInteger)newValue;

@end
