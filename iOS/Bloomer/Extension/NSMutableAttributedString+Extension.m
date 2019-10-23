//
//  NSMutableAttributedString+Extension.m
//  Bloomer
//
//  Created by Ahri on 10/11/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "NSMutableAttributedString+Extension.h"

@implementation NSMutableAttributedString (Extension)

- (void)setColorForText:(NSString *)textToFind withColor:(UIColor *)color {
    NSRange range = [self.mutableString rangeOfString:textToFind options:NSCaseInsensitiveSearch];
    if (range.location != NSNotFound) {
        [self addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
}

- (void)setBoldForText:(NSString *)textToFind fontSize:(CGFloat)fontSize {
    NSRange range = [self.mutableString rangeOfString:textToFind options:NSCaseInsensitiveSearch];
    if (range.location != NSNotFound) {
        [self beginEditing];
        [self addAttribute:NSFontAttributeName
                     value:[UIFont fontWithName:@"SFUIDisplay-Bold" size:fontSize]
                     range:range];
        [self endEditing];
    }
}

@end
