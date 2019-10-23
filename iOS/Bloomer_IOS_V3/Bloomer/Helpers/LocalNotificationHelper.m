//
//  LocalNotificationHelper.m
//  Bloomer
//
//  Created by Steven on 5/17/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "LocalNotificationHelper.h"
#import "AppHelper.h"

@implementation LocalNotificationHelper

+ (void)setup
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0"))
    {
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionAlert|UNAuthorizationOptionSound|UNAuthorizationOptionBadge  completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (error == nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIApplication.sharedApplication registerForRemoteNotifications];
                });
            }
        }];
    }
    else
    {
        [UIApplication.sharedApplication registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
}

+ (void)postDailyLocalNotification
{
    //    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0"))
    //    {
    //        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //        [calendar setTimeZone:[NSTimeZone localTimeZone]];
    //        NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitTimeZone fromDate:[NSDate date]];
    //
    //        UNMutableNotificationContent *notificationContent = [[UNMutableNotificationContent alloc] init];
    //        notificationContent.title = @"Bloomer";
    //        notificationContent.body = @"Please sign in";
    //        notificationContent.sound = [UNNotificationSound defaultSound];
    //
    //        UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponents repeats:true];
    //        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"Bloomer.DailySignInNotification" content:notificationContent trigger:trigger];
    //        UNUserNotificationCenter
    //    }
    //    else
    //    {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:24*60*60];
    localNotification.alertTitle = [AppHelper getLocalizedString:@"Notification.dailyLocalNotificationTitle"];
    localNotification.alertBody = [AppHelper getLocalizedString:@"Notification.dailyLocalNotificationBody"];
    localNotification.timeZone = [NSTimeZone localTimeZone];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.repeatInterval = NSCalendarUnitDay;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    //    }
}

+ (void)removeAllLocalNotifications
{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removeAllDeliveredNotifications];
    [center removeAllPendingNotificationRequests];
    [UIApplication.sharedApplication cancelAllLocalNotifications];
}

@end
