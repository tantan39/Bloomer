//
//  profile_update.m
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/11/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import "profile_update.h"

@implementation profile_update

-(id)initWithAccess_Token:(NSString *)access_token device_token:(NSString*)device_token screen_name:(NSString *)screen_name mobile:(NSString *)mobile gender:(NSInteger)gender living_in:(NSString *)living_in about_me:(NSString *)about_me birthday:(NSString *)birthday
{
    self = [super init];
    if(self)
    {
        _access_token = access_token;
        _device_token = device_token;
        _screen_name = screen_name;
        _mobile = mobile;
        _gender = gender;
        _living_in = living_in;
        _about_me = about_me;
        _birthday = birthday;
    }
    
    return self;
}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(NSString *) createStringJSON
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary* auth = [NSMutableDictionary dictionaryWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token, k_DEVICE_TOKEN, nil];
    NSMutableDictionary* account = [[NSMutableDictionary alloc] init];
    [account setObject:_screen_name forKey:k_SCREEN_NAME];
    [account setObject:_mobile forKey:k_MOBILE];
    [account setObject:[NSNumber numberWithInteger:_gender] forKey:k_GENDER];
    [account setObject:_living_in forKey:k_LIVING_IN];
    [account setObject:_about_me forKey:k_ABOUT_ME];
    [account setObject:_birthday forKey:k_BIRTHDAY];
    [dictionary setObject:auth forKey:k_AUTH];
    [dictionary setObject:account forKey:k_ACCOUNT];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    NSString* result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return result;
    
}

@end
