//
//  verifycode.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/8/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "verifycode.h"

@implementation verifycode

-(id)initWithCredential:(NSString*)credential Device_Token:(NSString*)device_token notification_token:(NSString*)notification_token Secret_Client:(NSString*)secret_client App_ID:(NSInteger)app_id
{
    self = [super init];
    
    if(self)
    {
        _credential = credential;
        _device_token = device_token;
        _secret_client = secret_client;
        _app_id = app_id;
        _notification_token = notification_token;
    }
    
    return self;
}

//-(NSString *) createStringJSON
//{
//    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:_credential, k_CREDENTIAL, _device_token,k_DEVICE_TOKEN, _secret_client, k_SECRET_CLIENT, [NSNumber numberWithInteger:_app_id], k_APP_ID, _notification_token, k_NOTIFICATION_TOKEN, nil];
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
//    NSString* result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    return result;
//}

- (NSDictionary *)encodeToJSON{
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:_credential, k_CREDENTIAL, _device_token,k_DEVICE_TOKEN, _secret_client, k_SECRET_CLIENT, [NSNumber numberWithInteger:_app_id], k_APP_ID, _notification_token, k_NOTIFICATION_TOKEN, nil];

    return info;
}


@end
