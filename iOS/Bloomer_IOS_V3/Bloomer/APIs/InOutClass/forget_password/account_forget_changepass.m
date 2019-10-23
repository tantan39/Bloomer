//
//  account_forget_changepass.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/10/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "account_forget_changepass.h"

@implementation account_forget_changepass

-(id)initWithCredential:(NSString*)credential secretClient:(NSString*)secret_client deviceToken:(NSString*)device_token appID:(NSInteger)app_id
{
    self= [super init];
    if(self)
    {
        _credential = credential;
        _secret_client = secret_client;
        _device_token = device_token;
        _app_id = app_id;
    }
    return self;
}

//-(NSString *) createStringJSON
//{
//    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:_credential, k_CREDENTIAL, _secret_client, k_SECRET_CLIENT, _device_token, k_DEVICE_TOKEN,[NSNumber numberWithInteger:_app_id], k_APP_ID, nil];
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
//    NSString* result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    return result;
//}

- (NSDictionary *)encodeToJSON{
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:_credential, k_CREDENTIAL, _secret_client, k_SECRET_CLIENT, _device_token, k_DEVICE_TOKEN,[NSNumber numberWithInteger:_app_id], k_APP_ID, nil];

    return info;
}


@end
