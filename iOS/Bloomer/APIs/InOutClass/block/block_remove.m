//
//  block_remove.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 5/8/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "block_remove.h"

@implementation block_remove

-(id)initWithAccessToken:(NSString*)access_token device_token:(NSString*)device_token uid:(NSInteger)uid
{
    self = [super init];
    
    if(self)
    {
        _access_token = access_token;
        _device_token = device_token;
        _uid = uid;
    }
    
    return self;
}

//-(NSString *) createStringJSON
//{
//    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token, k_DEVICE_TOKEN, [NSNumber numberWithInteger:_uid], k_UID, nil];
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
//    NSString* result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    return result;
//}

- (NSDictionary *)encodeToJSON{
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token, k_DEVICE_TOKEN, [NSNumber numberWithInteger:_uid], k_USER_ID, nil];

    return info;
}

@end
