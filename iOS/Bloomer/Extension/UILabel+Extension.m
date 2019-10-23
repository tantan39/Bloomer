//
//  UILabel+Extension.m
//  Bloomer
//
//  Created by Steven on 12/11/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

- (void)setFlowers:(NSInteger)flowers
{
    NSTextAttachment *textAttactment = [[NSTextAttachment alloc] init];
    textAttactment.image = [UIImage imageNamed:@"Icon_Flower"];
    
    NSAttributedString *stringAttactment = [NSAttributedString attributedStringWithAttachment:textAttactment];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld ", (long)flowers] attributes:@{NSFontAttributeName: self.font}];
    [string appendAttributedString:stringAttactment];
    
    self.attributedText = string;
}

- (void)setFlowers:(NSInteger)flowers image:(UIImage*)image
{
    NSTextAttachment *textAttactment = [[NSTextAttachment alloc] init];
    textAttactment.image = image;
    
    NSAttributedString *stringAttactment = [NSAttributedString attributedStringWithAttachment:textAttactment];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld ", (long)flowers] attributes:@{NSFontAttributeName: self.font}];
    [string appendAttributedString:stringAttactment];
    
    self.attributedText = string;
}

- (void)setFlowers:(NSInteger)flowers imageString:(NSString*)imageString
{
    NSTextAttachment *textAttactment = [[NSTextAttachment alloc] init];
    textAttactment.image = [UIImage imageNamed:imageString];
    
    NSAttributedString *stringAttactment = [NSAttributedString attributedStringWithAttachment:textAttactment];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld ", (long)flowers] attributes:@{NSFontAttributeName: self.font}];
    [string appendAttributedString:stringAttactment];
    
    self.attributedText = string;
}

@end
