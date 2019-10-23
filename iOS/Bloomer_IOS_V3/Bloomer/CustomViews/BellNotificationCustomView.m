//
//  BellNotificationCustomView.m
//  Bloomer
//
//  Created by Tan Tan on 11/20/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "BellNotificationCustomView.h"

@interface BellNotificationCustomView(){
    UIButton * notiButton;
    UILabel *lblNotiNumber;
    NSTimer *bellSwingTimer;
}

@end

@implementation BellNotificationCustomView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self finalInit];
    }
    return self;
}

- (void) finalInit{
    notiButton = [[UIButton alloc] initWithFrame:self.bounds];
    
    [notiButton setImage:[UIImage imageNamed:@"icon_bell"] forState:UIControlStateNormal];
    [notiButton addTarget:self action:@selector(touchNotificationButton:) forControlEvents:UIControlEventTouchUpInside];
//    [notiButton layer].anchorPoint = CGPointMake(0.5, 0.4);
    
    [self addSubview:notiButton];
    
    [self initLabelNotifNumber];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0")) {
        notiButton.translatesAutoresizingMaskIntoConstraints = NO;
        [notiButton setContentEdgeInsets:UIEdgeInsetsMake(10, 16, 10, 20)];
    }
    
}

- (void) initLabelNotifNumber{
    lblNotiNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 17, 13)];
    lblNotiNumber.textAlignment = NSTextAlignmentCenter;
    [lblNotiNumber setFont:[UIFont boldSystemFontOfSize:9]];

    lblNotiNumber.hidden = YES;
    lblNotiNumber.backgroundColor = [UIColor whiteColor];
    lblNotiNumber.layer.cornerRadius = lblNotiNumber.frame.size.height /2;
    lblNotiNumber.layer.masksToBounds = YES;
    lblNotiNumber.layer.borderWidth = 1.0;
    lblNotiNumber.layer.borderColor = [UIColor colorFromHexString:@"#0xB22225"].CGColor;
    lblNotiNumber.textColor = [UIColor colorFromHexString:@"#0xB22225"];
    
    lblNotiNumber.frame = CGRectMake(notiButton.frame.size.width - 1.5 * lblNotiNumber.frame.size.width,
                                     notiButton.frame.size.width / 2 - lblNotiNumber.frame.size.height / 1.3,
                                     lblNotiNumber.frame.size.width, lblNotiNumber.frame.size.height );
    [notiButton addSubview:lblNotiNumber];
}

- (void)updateNumbersNotification:(NSInteger)numb {
    [bellSwingTimer invalidate];
    bellSwingTimer = nil;
    if (numb > 0)
    {
        [lblNotiNumber setText:[@(numb) stringValue]];
        lblNotiNumber.hidden = NO;
        
        [notiButton setImage:[UIImage imageNamed:@"icon_bell"] forState:UIControlStateNormal];
        
        
        bellSwingTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self
                                                        selector:@selector(swingNotiBellView:)
                                                        userInfo:notiButton repeats:true];
    }else{
        [notiButton setImage:[UIImage imageNamed:@"icon_bell"] forState:UIControlStateNormal];
        [lblNotiNumber setText:@""];
        lblNotiNumber.hidden = YES;
    }
}

- (IBAction)touchNotificationButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(bellNotification_didSelect)]) {
        [self.delegate bellNotification_didSelect];
    }
}

- (void)swingNotiBellView:(NSTimer *)_timer {
    if (notiButton) {
        [notiButton swing:nil];
    }
}

- (void)alignBellIconToTheLeftForiOS11 {
    // Fix Notification bell got shifted to the right in iOS 11
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0")) {
        UIView *view = self;
        while (![view isKindOfClass:[UINavigationBar class]] && view.superview != nil) {
            view = view.superview;
            if ([view isKindOfClass:[UIStackView class]] && view.superview != nil) {
                [view.superview addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-8.0]];
                [view.superview addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:-4.0]];
                break;
            }
        }
    }
}
@end
