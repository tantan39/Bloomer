//
//  setting_update.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/17/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "setting_update.h"

@implementation setting_update

-(id)initWithAccessToken:(NSString*)access_token device_token:(NSString*)device_token chatting:(NSInteger)chatting
{
    self = [super init];
    
    if(self)
    {
        _access_token = access_token;
        _device_token = device_token;
        _chatting = chatting;
    }
    
    return self;
}

//-(NSString *) createStringJSON
//{
//    NSDictionary* auth = [NSDictionary dictionaryWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token, k_DEVICE_TOKEN, nil];
//    
//    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:auth, k_AUTH, [NSNumber numberWithInteger:_chatting], @"nchat", nil];
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
//    NSString* result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    return result;
//}

- (NSDictionary *)encodeToJSON{
    NSDictionary* auth = [NSDictionary dictionaryWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token, k_DEVICE_TOKEN, nil];
    
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:auth, k_AUTH, [NSNumber numberWithInteger:_chatting], @"nchat", nil];

    return info;
}

@end
