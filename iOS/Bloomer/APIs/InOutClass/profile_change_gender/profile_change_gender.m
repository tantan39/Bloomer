//
//  profile_change_gender.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 7/24/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "profile_change_gender.h"

@implementation profile_change_gender

-(id)initWithAccess_Token:(NSString *)access_token device_token:(NSString*)device_token gender:(NSInteger)gender
{
    self = [super init];
    
    if(self)
    {
        _access_token = access_token;
        _device_token = device_token;
        _gender = gender;
    }
    
    return self;
}

//-(NSString *) createStringJSON
//{
//    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//    
//    [dictionary setObject:_access_token forKey:k_ACCESS_TOKEN];
//    [dictionary setObject:_device_token forKey:k_DEVICE_TOKEN];
//    [dictionary setObject:[NSNumber numberWithInteger:_gender] forKey:k_GENDER];
//    
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
//    NSString* result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    return result;
//    
//}

- (NSDictionary *)encodeToJSON{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setObject:_access_token forKey:k_ACCESS_TOKEN];
    [dictionary setObject:_device_token forKey:k_DEVICE_TOKEN];
    [dictionary setObject:[NSNumber numberWithInteger:_gender] forKey:k_GENDER];
    
    return dictionary;
}

@end

