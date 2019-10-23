//
//  profile_update_about_me.m
//  Xinh
//
//  Created by Nguyen Thanh Tu on 12/18/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import "profile_update_about_me.h"

@implementation profile_update_about_me

-(id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token andAbout_me:(NSString *)me {
    
    self = [super init];
    if(self)
    {
        _access_token =  access_token;
        _about_me = me;
        _device_token = device_token;
    }
    
    return self;
}

//-(NSString *)createStringJSON {
//    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//    
//    NSMutableDictionary *auth = [NSMutableDictionary dictionaryWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token, k_DEVICE_TOKEN, nil];
//    
//    NSMutableDictionary *account = [[NSMutableDictionary alloc] init];
//    [account setObject:_about_me forKey:k_ABOUT_ME];
//    
//    [dictionary setObject:auth forKey:k_AUTH];
//    [dictionary setObject:account forKey:k_ACCOUNT];
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
    
    NSMutableDictionary *account = [[NSMutableDictionary alloc] init];
    [account setObject:_about_me forKey:k_ABOUT_ME];
    
    [dictionary setObject:auth forKey:k_AUTH];
    [dictionary setObject:account forKey:k_ACCOUNT];
    
    return dictionary;
}

@end
