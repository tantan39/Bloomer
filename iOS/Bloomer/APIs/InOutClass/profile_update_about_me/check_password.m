//
//  check_password.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/20/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "check_password.h"

@implementation check_password

- (id)initWithAccess_Token:(NSString *)access_token device_token:(NSString *)device_token secret_client:(NSString *)secret_client credential:(NSString *)credential {
    if(self)
    {
        _access_token = access_token;
        _device_token = device_token;
        _secret_client = secret_client;
        _credential = credential;
    }
    return self;
}

//- (NSString *)createStringJSON {
//    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//    
//    NSMutableDictionary *auth = [NSMutableDictionary dictionaryWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token, k_DEVICE_TOKEN, nil];
//    
//    NSMutableDictionary *profile = [[NSMutableDictionary alloc] init];
//    [profile setObject:_secret_client forKey:k_SECRET_CLIENT];
//    [profile setObject:_credential forKey:k_CREDENTIAL];
//    
//    [dictionary setObject:auth forKey:k_AUTH];
//    [dictionary setObject:profile forKey:k_PROFILE];
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
    
    NSMutableDictionary *profile = [[NSMutableDictionary alloc] init];
    [profile setObject:_secret_client forKey:k_SECRET_CLIENT];
    [profile setObject:_credential forKey:k_CREDENTIAL];
    
    [dictionary setObject:auth forKey:k_AUTH];
    [dictionary setObject:profile forKey:k_PROFILE];
    
    return dictionary;
}


@end
