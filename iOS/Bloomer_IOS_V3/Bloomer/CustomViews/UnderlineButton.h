//
//  UnderlineButton.h
//  Bloomer
//
//  Created by Tran Thai Tan on 6/5/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Extension.h"
@interface UnderlineButton : UIButton{
    UIColor * activeColor;
    UIColor * deactiveColor;
}

@property UIView * underLineView;
- (void) setStatusEnable:(BOOL) enable;

@end
