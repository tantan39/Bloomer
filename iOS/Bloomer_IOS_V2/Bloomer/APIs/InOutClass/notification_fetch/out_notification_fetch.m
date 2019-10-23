//
//  out_notification_fetch.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/18/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "out_notification_fetch.h"

@implementation out_notification_fetch

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        _notifications = [[NSMutableArray alloc] init];
        
        NSArray *array = [json objectForKey:@"notifications"];
        for (NSInteger i = 0; i < array.count; i++)
        {
            NSDictionary *notif = [array objectAtIndex:i];
            notification *temp = [[notification alloc] initWithJSON:notif];
            
            [_notifications addObject:temp];
        }
    }
    return self;
}

@end
