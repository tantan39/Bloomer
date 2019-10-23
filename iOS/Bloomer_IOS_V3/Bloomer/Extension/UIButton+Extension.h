//
//  UIButton+Extension.h
//  Bloomer
//
//  Created by Tran Thai Tan on 6/2/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Extension.h"
#import "UIView+Extension.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <QuartzCore/QuartzCore.h>

typedef enum ButtonType {
    GETVERIFYCODE_BUTTON
} BUTTON_TYPE;

@interface UIButton (Extension)
- (void) setUnderlineForButtonWithTitle:(NSString *) title;
- (void)highlight:(BOOL)enabled;
- (void) setStatusEnable:(BOOL) enable;
- (void) setWhiteButtonEnable:(BOOL) enable;
- (void) setStatusEnable:(BOOL) enable WithButtonType:(BUTTON_TYPE) type;
- (void) setImageWithURL:(NSURL *) url forState:(UIControlState)state;
- (void) setIconEdgeInset;
- (void) addShadow;
@end
