//
//  BellNotificationCustomView.h
//  Bloomer
//
//  Created by Tan Tan on 11/20/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Extension.h"
#import "UIView+DCAnimationKit.h"
#import "Support.h"
NS_ASSUME_NONNULL_BEGIN

@protocol BellNotificationCustomViewDelegate <NSObject>

- (void) bellNotification_didSelect;

@end

@interface BellNotificationCustomView : UIView

@property (weak,nonatomic) id<BellNotificationCustomViewDelegate> delegate;
- (void)updateNumbersNotification:(NSInteger) numb;
@end

NS_ASSUME_NONNULL_END
