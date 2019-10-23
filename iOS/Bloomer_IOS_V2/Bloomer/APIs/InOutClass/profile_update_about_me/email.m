//
//  email.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/13/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "email.h"

@implementation email

- (id)initWithAccess_Token:(NSString *)access_token device_token:(NSString *)device_token email:(NSString *)email {
    self = [super init];
    if(self)
    {
        _access_token = access_token;
        _device_token = device_token;
        _email = email;
    }
    return self;
}

//- (NSString *)createStringJSON {
//    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//    
//    NSMutableDictionary *auth = [NSMutableDictionary dictionaryWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token, k_DEVICE_TOKEN, nil];
//    
//    NSMutableDictionary *profile = [[NSMutableDictionary alloc] init];
//    [profile setObject:_email forKey:k_EMAIL];
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
    [profile setObject:_email forKey:k_EMAIL];
    
    [dictionary setObject:auth forKey:k_AUTH];
    [dictionary setObject:profile forKey:k_PROFILE];
    
    return dictionary;
}

@end
