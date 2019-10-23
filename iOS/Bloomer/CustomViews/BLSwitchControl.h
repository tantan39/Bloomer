//
//  BLSwitchControl.h
//  Bloomer
//
//  Created by Tan Tan on 10/11/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppHelper.h"
#import "UIColor+Extension.h"
@interface BLSwitchControl : UIControl

@property (assign,nonatomic) NSInteger selectedIndex;

@end

@interface ItemView : UIView
@property (strong,nonatomic) UIImageView * icon;
@property (strong,nonatomic) UILabel * lblTitle;

- (instancetype) initWithIcon:(UIImage *) icon Title:(NSString *) title;
@end
