//
//  message_send.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/2/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "message_send.h"

@implementation message_send

-(id)initWithMessage:(NSString*)message rev:(NSInteger)rev resType:(NSInteger)resType timestamp:(NSInteger)timestamp timestamp_relative:(NSString*)timestamp_relative
{
    self = [super init];
    
    if(self)
    {
        _message = message;
        _rev = rev;
        _resource = resType;
        _timestamp = timestamp;
        _timestamp_relative = timestamp_relative;
    }
    
    return self;
}

-(id)initWithMessage:(NSString*)message rev:(NSInteger)rev resType:(NSInteger)resType
{
    self = [super init];
    
    if(self)
    {
        _message = message;
        _rev = rev;
        _resource = resType;
    }
    
    return self;
}

//-(NSString *) createStringJSON
//{
//    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:_message, k_MESSAGE, [NSNumber numberWithInteger:_rev], k_REV,[NSNumber numberWithInteger:_resource],k_RESOURCE , nil];
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
//    NSString* result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    return result;
//}

- (NSDictionary *)encodeToJSON{
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:_message, k_MESSAGE, [NSNumber numberWithInteger:_rev], k_REV,[NSNumber numberWithInteger:_resource],k_RESOURCE , nil];

    return info;
}

@end
