//
//  LocalNotificationHelper.h
//  Bloomer
//
//  Created by Steven on 5/17/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "Support.h"

@interface LocalNotificationHelper : NSObject

+ (void)setup;
+ (void)postDailyLocalNotification;
+ (void)removeAllLocalNotifications;

@end
