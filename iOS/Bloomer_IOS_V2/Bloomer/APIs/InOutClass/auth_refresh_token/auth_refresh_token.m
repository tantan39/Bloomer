//
//  auth_refresh_token.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/23/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "auth_refresh_token.h"

@implementation auth_refresh_token

-(id)initWithDevice_Token:(NSString*)device_token access_token:(NSString*)access_token refresh_token:(NSString*)refresh_token secret_client:(NSString*)secret_client
{
    self= [super init];
    if(self)
    {
        _device_token = device_token;
        _secret_client = secret_client;
        _access_token = access_token;
        _refresh_token = refresh_token;
    }
    return self;
}

//-(NSString *) createStringJSON
//{
//    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:_device_token, k_DEVICE_TOKEN, _access_token, k_ACCESS_TOKEN, _refresh_token, k_REFRESH_TOKEN, _secret_client, k_SECRET_CLIENT, nil];
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
//    NSString* result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    return result;
//}

- (NSDictionary *)encodeToJSON{
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:_device_token, k_DEVICE_TOKEN, _access_token, k_ACCESS_TOKEN, _refresh_token, k_REFRESH_TOKEN, _secret_client, k_SECRET_CLIENT, nil];
    //    NSError *error;
    //    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
    //    NSString* result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return info;
}

@end
