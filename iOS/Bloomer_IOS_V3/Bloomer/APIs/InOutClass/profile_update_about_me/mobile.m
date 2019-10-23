//
//  mobile.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/12/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "mobile.h"

@implementation mobile

- (id)initWithAccess_Token:(NSString *)access_token device_token:(NSString *)device_token mobile:(NSString *)mobile country_id:(NSInteger)country_id {
    if(self)
    {
        _access_token = access_token;
        _device_token = device_token;
        _mobile = mobile;
        _country_id = country_id;
    }
    return self;
}

//- (NSString *)createStringJSON {
//    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//    
//    NSMutableDictionary *auth = [NSMutableDictionary dictionaryWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token, k_DEVICE_TOKEN, nil];
//    
//    NSMutableDictionary *profile = [[NSMutableDictionary alloc] init];
//    [profile setObject:[NSNumber numberWithInteger:_country_id] forKey:k_COUNTRY_ID];
//    [profile setObject:_mobile forKey:k_MOBILE];
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
    [profile setObject:[NSNumber numberWithInteger:_country_id] forKey:k_COUNTRY_ID];
    [profile setObject:_mobile forKey:k_MOBILE];
    
    [dictionary setObject:auth forKey:k_AUTH];
    [dictionary setObject:profile forKey:k_PROFILE];
    
    return dictionary;
}

@end
