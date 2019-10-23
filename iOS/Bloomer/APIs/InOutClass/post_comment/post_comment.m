//
//  post_comment.m
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/15/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import "post_comment.h"

@implementation post_comment

-(id)initWithAccessToken:(NSString*)access_token device_token:(NSString *)device_token post_id:(NSString *)post_id comment:(NSString *)comment
{
    self = [super init];
    
    if(self)
    {
        _access_token = access_token;
        _device_token = device_token;
        _post_id = post_id;
        _comment = comment;
    }
    
    return self;
}

//- (NSString *)createStringJSON
//{
//    NSDictionary *auth = [NSDictionary dictionaryWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token, k_DEVICE_TOKEN, nil];
//    NSDictionary *payload = [NSDictionary dictionaryWithObjectsAndKeys:_post_id, k_POST_ID, _comment, k_COMMENT, nil];
//    
//    NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
//    [info setObject:auth forKey:k_AUTH];
//    [info setObject:payload forKey:k_PAYLOAD];
//    
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    
//    return result;
//}

- (NSDictionary *)encodeToJSON{
    NSDictionary *auth = [NSDictionary dictionaryWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token, k_DEVICE_TOKEN, nil];
    NSDictionary *payload = [NSDictionary dictionaryWithObjectsAndKeys:_post_id, k_POST_ID, _comment, k_COMMENT, nil];
    
    NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
    [info setObject:auth forKey:k_AUTH];
    [info setObject:payload forKey:k_PAYLOAD];
    
    return info;
}

@end
