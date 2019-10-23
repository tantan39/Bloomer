//
//  notification_setting.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/30/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "notification_setting.h"

@implementation notification_setting

- (id)initWithAccess_Token:(NSString *)access_token device_token:(NSString *)device_token notification:(BOOL)notification chat:(BOOL)chat follow:(BOOL)follow flower:(BOOL)flower app:(BOOL)app race:(BOOL)race {
    self = [super init];
    if(self)
    {
        _access_token = access_token;
        _device_token = device_token;
        _notifications = notification;
        _chat = chat;
        _follow = follow;
        _flower = flower;
        _app = app;
        _race = race;
    }
    return self;
}

//-(NSString *)createStringJSON {
//    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//    
//    NSMutableDictionary *auth = [NSMutableDictionary dictionaryWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token, k_DEVICE_TOKEN, nil];
//    
//    NSMutableDictionary *notification = [[NSMutableDictionary alloc] init];
//    [notification setObject:[NSNumber numberWithBool:_notifications] forKey:@"notification"];
//    [notification setObject:[NSNumber numberWithBool:_chat] forKey:@"notification_chat"];
//    [notification setObject:[NSNumber numberWithBool:_race] forKey:@"notification_race"];
//    [notification setObject:[NSNumber numberWithBool:_follow] forKey:@"notification_follow"];
//    [notification setObject:[NSNumber numberWithBool:_flower] forKey:@"notification_flower"];
//    [notification setObject:[NSNumber numberWithBool:_app] forKey:@"notification_app"];
//    
//    [dictionary setObject:auth forKey:k_AUTH];
//    [dictionary setObject:notification forKey:@"notifications"];
//    
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    
//    return result;
//}

- (NSDictionary *)encodeToJSON{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *auth = [NSMutableDictionary dictionaryWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token, k_DEVICE_TOKEN, nil];
    
    NSMutableDictionary *notification = [[NSMutableDictionary alloc] init];
    [notification setObject:[NSNumber numberWithBool:_notifications] forKey:@"notification"];
    [notification setObject:[NSNumber numberWithBool:_chat] forKey:@"notification_chat"];
    [notification setObject:[NSNumber numberWithBool:_race] forKey:@"notification_race"];
    [notification setObject:[NSNumber numberWithBool:_follow] forKey:@"notification_follow"];
    [notification setObject:[NSNumber numberWithBool:_flower] forKey:@"notification_flower"];
    [notification setObject:[NSNumber numberWithBool:_app] forKey:@"notification_app"];
    
    [dictionary setObject:auth forKey:k_AUTH];
    [dictionary setObject:notification forKey:@"notifications"];
    
    return dictionary;
}

@end
