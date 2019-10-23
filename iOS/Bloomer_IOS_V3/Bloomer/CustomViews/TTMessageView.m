//
//  TTMessageView.m
//  MessageView
//
//  Created by Tan Tan on 6/24/17.
//  Copyright © 2017 Tan Tan. All rights reserved.
//

#import "TTMessageView.h"

#define NOTIFICATION_VIEW_FRAME_HEIGHT          35.0f
#define Y_StartPoint                            -35.0f
#define LABEL_MESSAGE_FONT_SIZE                 13.0f
#define NOTIFICATION_VIEW_SHOWING_DURATION                  3.0f
#define NOTIFICATION_VIEW_SHOWING_ANIMATION_TIME            0.3f

@implementation TTMessageView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

+ (instancetype)shareInstance{
    static  TTMessageView * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TTMessageView alloc] init];
    });
    
    return instance;
}

- (instancetype)init{
    self = [super initWithFrame:CGRectMake(0, Y_StartPoint, [[UIScreen mainScreen] bounds].size.width, NOTIFICATION_VIEW_FRAME_HEIGHT)];
    if (self) {
        
        [self setUpUI];
    }
    
    return self;
}

- (void) setUpUI{
//    self.backgroundColor = [UIColor colorFromHexString:@"#EFEFEF"];
    self.backgroundColor = [UIColor colorWithRed:76/255 green:77/255 blue:78/255 alpha:1];
    [self initMessageLabel];
}


- (void) initMessageLabel{
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    
    self.messageLabel.font = [UIFont systemFontOfSize:LABEL_MESSAGE_FONT_SIZE];
    [self.messageLabel setTextColor:[UIColor whiteColor]];
    [self.messageLabel setTextAlignment:NSTextAlignmentCenter];
    self.messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.messageLabel.numberOfLines = 2;
    [self addSubview:self.messageLabel];
}

#pragma mark - Show Message
- (void)showMessageUnderNavBarWithTimer:(UIViewController *)viewController Message:(NSString *)message{
    if (viewController.navigationController.navigationBar) {
        if (message) {
            self.messageLabel.text = message;
        }else{
            self.messageLabel.text = @"";
        }
        
        CGRect frame = self.frame;
        frame.origin.y = Y_StartPoint;
        self.frame = frame;
        
        [viewController.view addSubview:self];
        
        [UIView animateWithDuration:NOTIFICATION_VIEW_SHOWING_ANIMATION_TIME delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
                CGRect frame = self.frame;
                frame.origin.y += frame.size.height;
                self.frame = frame;
            
        } completion:nil];
        
        timerHideAuto = [NSTimer scheduledTimerWithTimeInterval:NOTIFICATION_VIEW_SHOWING_DURATION
                                                          target:self
                                                        selector:@selector(hideMessageView)
                                                        userInfo:nil
                                                         repeats:NO];
        
    }
}

- (void)showMessageUnderNavBar:(UIViewController *)viewController Message:(NSString *)message{
    if (viewController.navigationController.navigationBar) {
        if (message) {
            self.messageLabel.text = message;
        }else{
            self.messageLabel.text = @"";
        }
        
        CGRect frame = self.frame;
        frame.origin.y = Y_StartPoint;
        self.frame = frame;
        
        [viewController.view addSubview:self];
        
        [UIView animateWithDuration:NOTIFICATION_VIEW_SHOWING_ANIMATION_TIME delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            CGRect frame = self.frame;
            frame.origin.y += frame.size.height;
            self.frame = frame;
            
        } completion:nil];
        
    }
}

- (void) hideMessageView{
    [UIView animateWithDuration:NOTIFICATION_VIEW_SHOWING_ANIMATION_TIME
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         CGRect frame = self.frame;
                         frame.origin.y = Y_StartPoint;
                         self.frame = frame;
                         
                     } completion:^(BOOL finished) {
                         
                         [self removeFromSuperview];
                         
                         if (timerHideAuto) {
                             [timerHideAuto invalidate];
                             timerHideAuto = nil;
                         }
                         
                     }];

}

#pragma mark - Static function
+ (void)showMessageUnderNavBar:(UIViewController *)viewController Message:(NSString *)message{
    [[TTMessageView shareInstance] showMessageUnderNavBarWithTimer:viewController Message:message];
}

+ (void)showMessageUnderNavBar:(UIViewController *)viewController Message:(NSString *)message Timer:(BOOL)timer{
    if (timer) {
        [[TTMessageView shareInstance] showMessageUnderNavBarWithTimer:viewController Message:message];
    }else{
        [[TTMessageView shareInstance] showMessageUnderNavBar:viewController Message:message];
    }
}
@end
