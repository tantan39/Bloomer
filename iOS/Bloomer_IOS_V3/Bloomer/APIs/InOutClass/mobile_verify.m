//
//  mobile_verify.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/23/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "mobile_verify.h"

@implementation mobile_verify

- (id)initWithAccess_Token:(NSString *)access_token device_token:(NSString *)device_token code:(NSString *)codes uid:(NSString *)uid secret_client:(NSString *)secret_client credential:(NSString *)credential {
    self = [super init];
    if(self)
    {
        _access_token = access_token;
        _device_token = device_token;
        _codes = codes;
        _uid = uid;
        _secret_client = secret_client;
        _credential = credential;
    }
    return self;
}

//- (NSString *)createStringJSON {
//    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//    
//    NSMutableDictionary *auth = [NSMutableDictionary dictionaryWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token, k_DEVICE_TOKEN, _uid, k_UID, nil];
//    
//    NSMutableDictionary *profile = [NSMutableDictionary dictionaryWithObjectsAndKeys:_secret_client, k_SECRET_CLIENT, _credential, k_CREDENTIAL, nil];
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
    
    NSMutableDictionary *auth = [NSMutableDictionary dictionaryWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token, k_DEVICE_TOKEN, _uid, k_UID, nil];
    
    NSMutableDictionary *profile = [NSMutableDictionary dictionaryWithObjectsAndKeys:_secret_client, k_SECRET_CLIENT, _credential, k_CREDENTIAL, nil];
    
    [dictionary setObject:auth forKey:k_AUTH];
    [dictionary setObject:profile forKey:k_PROFILE];
    

    
    return dictionary;
}

@end
