//
//  sendcode.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/8/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "sendcode.h"

@implementation sendcode

- (id)initWithCredential:(NSString*)credential Secret_Client:(NSString*)secret_client App_ID:(NSInteger)app_id Country_ID:(NSInteger)country_id DeviceID:(NSString *)deviceId voice:(BOOL)voice
{
    self = [super init];
    
    if(self)
    {
        _credential = credential;
        _secret_client = secret_client;
        _app_id = app_id;
        _country_id = country_id;
        _device_id = deviceId;
        _voice = voice;
//        _gender = gender;
    }
    
    return self;
}

//- (NSString *) createStringJSON
//{
//    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:_credential, k_CREDENTIAL, _secret_client, k_SECRET_CLIENT, [NSNumber numberWithInteger:_app_id], k_APP_ID, [NSNumber numberWithInteger:_country_id], k_COUNTRY_ID, _device_id,k_DEVICE_TOKEN, nil];
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    return result;
//}

- (NSDictionary *)encodeToJSON{
    
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:_credential, k_CREDENTIAL, _secret_client, k_SECRET_CLIENT, [NSNumber numberWithInteger:_app_id], k_APP_ID, [NSNumber numberWithInteger:_country_id], k_COUNTRY_ID, _device_id,k_DEVICE_TOKEN, _voice, @"voice", nil];
    
    return info;
}

@end
