//
//  UIButton+Extension.m
//  Bloomer
//
//  Created by Tran Thai Tan on 6/2/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "UIButton+Extension.h"

@implementation UIButton (Extension)

- (void)setUnderlineForButtonWithTitle:(NSString *)title{
    NSMutableAttributedString * titleString = [[NSMutableAttributedString alloc]initWithString:title];
    [titleString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:(NSUnderlineStyleSingle)] range:NSMakeRange(0, [titleString length])];
    [self setAttributedTitle:titleString forState:UIControlStateNormal];
}

- (void)highlight:(BOOL)enabled
{
    if (enabled)
    {
        self.backgroundColor = [UIColor colorFromHexString:@"#202021"];
        self.layer.borderColor = [UIColor clearColor].CGColor;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else
    {
        self.backgroundColor = [UIColor clearColor];
        [self setDefaultBorder];
        [self setTitleColor:[UIColor colorFromHexString:@"#C7C7C7"] forState:UIControlStateNormal];
    }
}

- (void)setStatusEnable:(BOOL)enable{
    if (enable) {
        [self setEnabled:YES];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor colorFromHexString:@"#B0252A"]];
    }else{
        [self setEnabled:NO];
        [self setBackgroundColor:[UIColor colorFromHexString:@"#B9C0C7"]];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    }
}

- (void)setWhiteButtonEnable:(BOOL)enable{
    [self setEnabled:enable];
    if (enable) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    }
    
}

- (void) setStatusGetVerifyCode:(BOOL) enable{
    [self setEnabled:enable];
    if (enable) {
        [self setTitleColor:[UIColor colorFromHexString:@"#1C5C9A"] forState:UIControlStateNormal];
    }else{
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    }
}

- (void)setStatusEnable:(BOOL)enable WithButtonType:(BUTTON_TYPE)type{
    switch (type) {
        case GETVERIFYCODE_BUTTON:
            [self setStatusGetVerifyCode:enable];
            break;
            
        default:
            break;
    }
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state{
    [self sd_setImageWithURL:url forState:state];
}

@end
