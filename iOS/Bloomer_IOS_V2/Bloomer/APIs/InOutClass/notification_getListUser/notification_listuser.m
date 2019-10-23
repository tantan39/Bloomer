//
//  notification_listuser.m
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 12/16/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "notification_listuser.h"

@implementation notification_listuser

-(id) initWithAccessToken:(NSString*) token deviceId:(NSString*) device andNoti_key:(NSString*)key index:(NSInteger)index
{
    self = [super init];
    if(self)
    {
        _accessToken = token;
        _devide_id = device;
        _noti_key = key;
        self.index = index;
    }
    return self;
}

//-(NSString *) createStringJSON
//{
//    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:_accessToken, k_ACCESS_TOKEN, _devide_id, k_DEVICE_TOKEN, [NSNumber numberWithInteger:_user_id], k_USER_ID, _noti_key, k_NOTIFICATION_KEY, [NSNumber numberWithInteger:self.index], @"index", nil];
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
//    NSString* result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    return result;
//}

- (NSDictionary *)encodeToJSON{
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:_accessToken, k_ACCESS_TOKEN, _devide_id, k_DEVICE_TOKEN, [NSNumber numberWithInteger:_user_id], k_USER_ID, _noti_key, k_NOTIFICATION_KEY, [NSNumber numberWithInteger:self.index], @"index", nil];

    return info;
}

@end
