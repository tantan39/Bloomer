//
//  password.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/27/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "password.h"

@implementation password

- (id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token secret_client:(NSString *)secret_client credential:(NSString *)credential {
    self = [super init];
    
    if (self) {
        _access_token = access_token;
        _device_token = device_token;
        _secret_client = secret_client;
        _credential = credential;
    }
    
    return self;
}

//- (NSString *)createStringJSON {
//    NSDictionary *auth = [NSDictionary dictionaryWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token,k_DEVICE_TOKEN, nil];
//    NSDictionary *profile = [NSDictionary dictionaryWithObjectsAndKeys:_secret_client, k_SECRET_CLIENT, _credential, k_CREDENTIAL, nil];
//    
//    NSMutableDictionary *upload = [[NSMutableDictionary alloc] init];
//    
//    [upload setObject:auth forKey:k_AUTH];
//    [upload setObject:profile forKey:k_PROFILE];
//    
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:upload options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    return result;
//}

- (NSDictionary *)encodeToJSON{
    NSDictionary *auth = [NSDictionary dictionaryWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token,k_DEVICE_TOKEN, nil];
    NSDictionary *profile = [NSDictionary dictionaryWithObjectsAndKeys:_secret_client, k_SECRET_CLIENT, _credential, k_CREDENTIAL, nil];
    
    NSMutableDictionary *upload = [[NSMutableDictionary alloc] init];
    
    [upload setObject:auth forKey:k_AUTH];
    [upload setObject:profile forKey:k_PROFILE];
    
    return upload;
}

@end
