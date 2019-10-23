//
//  Spinner.h
//  Xinh
//
//  Created by Truong Thuan Tai on 12/19/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Spinner : UIView
-(id)initWithFrame:(CGRect)frame Color:(UIColor*)color;
- (void)startAnimating;
- (void)stopAnimating;
@end
