//
//  NotificationPopup.h
//  Bloomer
//
//  Created by Tai Truong on 10/5/15.
//  Copyright © 2015 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationPopup : UIView

@property (strong, nonatomic) UILabel *popupLabel;

- (void)setLabelText:(NSString*)text;

@end
