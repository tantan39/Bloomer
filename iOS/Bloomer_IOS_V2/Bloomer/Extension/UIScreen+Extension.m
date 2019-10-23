//
//  UIScreen+Extension.m
//  Bloomer
//
//  Created by Tan Tan on 9/6/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "UIScreen+Extension.h"

@implementation UIScreen (Extension)

+ (BOOL)isRetina{
    return [[UIScreen mainScreen] scale] == 2.0f;
}

+ (BOOL)isRetinaHD{
    return [[UIScreen mainScreen] scale] == 3.0f;
}

@end
