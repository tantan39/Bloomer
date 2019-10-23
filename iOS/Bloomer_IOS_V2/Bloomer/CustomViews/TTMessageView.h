//
//  TTMessageView.h
//  MessageView
//
//  Created by Tan Tan on 6/24/17.
//  Copyright © 2017 Tan Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Extension.h"
@interface TTMessageView : UIView{
    NSTimer * timerHideAuto;
}

+ (instancetype) shareInstance;

+ (void) showMessageUnderNavBar:(UIViewController *) viewController Message:(NSString *) message;

+ (void) showMessageUnderNavBar:(UIViewController *) viewController Message:(NSString *) message Timer:(BOOL) timer;

@property (nonatomic,strong) UILabel * messageLabel;

@end
