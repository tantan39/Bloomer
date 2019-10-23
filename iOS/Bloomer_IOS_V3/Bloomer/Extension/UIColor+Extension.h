//
//  UIColor+Extension.h
//  Bloomer
//
//  Created by Steven on 12/17/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (UIColor *)rgb:(int)red green:(int) green blue:(int) blue;

@end
