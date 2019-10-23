//
//  username_update.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/21/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "username_update.h"

@implementation username_update

- (id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token username:(NSString *)username {
    self = [super init];
    
    if (self) {
        _access_token = access_token;
        _device_token = device_token;
        _username = username;
    }
    
    return self;
}

//- (NSString *)createStringJSON {
//    NSDictionary *auth = [NSDictionary dictionaryWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token,k_DEVICE_TOKEN, nil];
//    NSDictionary *profile = [NSDictionary dictionaryWithObjectsAndKeys:_username, k_USERNAME, nil];
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
    NSDictionary *profile = [NSDictionary dictionaryWithObjectsAndKeys:_username, k_USERNAME, nil];
    
    NSMutableDictionary *upload = [[NSMutableDictionary alloc] init];
    
    [upload setObject:auth forKey:k_AUTH];
    [upload setObject:profile forKey:k_PROFILE];
    

    return upload;
}

@end
