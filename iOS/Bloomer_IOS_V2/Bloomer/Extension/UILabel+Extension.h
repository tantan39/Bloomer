//
//  UILabel+Extension.h
//  Bloomer
//
//  Created by Steven on 12/11/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)

- (void)setFlowers:(NSInteger)flowers;
- (void)setFlowers:(NSInteger)flowers image:(UIImage*)image;
- (void)setFlowers:(NSInteger)flowers imageString:(NSString*)imageString;

@end
