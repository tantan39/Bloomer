//
//  gender.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/28/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "genders.h"

@implementation genders

- (id)initWithAccess_Token:(NSString *)access_token device_token:(NSString *)device_token gender:(NSInteger)gender {
    self = [super init];
    if(self)
    {
        _access_token = access_token;
        _device_token = device_token;
        _gender = gender;
    }
    return self;
}

//-(NSString *)createStringJSON {
//    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//    
//    NSMutableDictionary *auth = [NSMutableDictionary dictionaryWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token, k_DEVICE_TOKEN, nil];
//    
//    NSMutableDictionary *profile = [[NSMutableDictionary alloc] init];
//    [profile setObject:[NSNumber numberWithInteger:_gender] forKey:k_GENDER];
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
    [profile setObject:[NSNumber numberWithInteger:_gender] forKey:k_GENDER];
    
    [dictionary setObject:auth forKey:k_AUTH];
    [dictionary setObject:profile forKey:k_PROFILE];
    
    return dictionary;
}

@end
