//
//  auth_authorize.m
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/8/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import "auth_authorize.h"

@implementation auth_authorize


-(id)initWithCredential:(NSString *)credential secretClient:(NSString *)secret_client deviceToken:(NSString *)device_token country_id:(NSInteger )country_id appID:(NSInteger)app_id notification_token:(NSString*)notification_token
{
    self= [super init];
    if(self)
    {
        _credential = credential;
        _secret_client = secret_client;
        _device_token = device_token;
        _app_id = app_id;
        _country_id = country_id;
        _notification_token = notification_token;
    }
    return self;
}

- (NSDictionary *)encodeToJSON{
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:_credential, k_CREDENTIAL, _device_token, k_DEVICE_TOKEN, _secret_client, k_SECRET_CLIENT, [NSNumber numberWithInteger:_app_id], k_APP_ID, [NSNumber numberWithInteger:_country_id], k_COUNTRY_ID,_notification_token, k_NOTIFICATION_TOKEN, nil];
    
    return info;
}

@end
