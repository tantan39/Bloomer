//
//  NSMutableAttributedString+Extension.h
//  Bloomer
//
//  Created by Ahri on 10/11/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (Extension)

- (void)setColorForText:(NSString *)textToFind withColor:(UIColor *)color;
- (void)setBoldForText:(NSString *)textToFind fontSize:(CGFloat)fontSize;

@end
