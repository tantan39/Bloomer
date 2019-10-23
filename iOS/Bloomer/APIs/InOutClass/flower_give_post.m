//
//  flower_give_post.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 10/23/15.
//  Copyright © 2015 Glassegg. All rights reserved.
//

#import "flower_give_post.h"

@implementation flower_give_post

-(id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token num_flower:(long long)num_flower postID:(NSString *)post_id {
self = [super init];
    
    if(self)
    {
        _access_token = access_token;
        _device_token = device_token;
        _num_flower = num_flower;
        _post_id = post_id;
    }
    
    return self;
    
}

-(id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token num_flower:(long long)num_flower postID:(NSString *)post_id receiver:(NSInteger)receiver{
    self = [super init];
    
    if(self)
    {
        _access_token = access_token;
        _device_token = device_token;
        _num_flower = num_flower;
        _post_id = post_id;
        _receiver = receiver;
    }
    
    return self;
    
}

//-(NSString *)createStringJSON {
//    NSMutableDictionary *flower = [[NSMutableDictionary alloc] init];
//    NSDictionary *auth = [[NSDictionary alloc] initWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token, k_DEVICE_TOKEN, nil];
//    NSDictionary *given = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithLongLong:_num_flower], k_FLOWER, _post_id, k_POST_ID, nil];
//    
//    [flower setObject:auth forKey:k_AUTH];
//    [flower setObject:given forKey:k_GIVEN];
//    
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:flower options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    return result;
//}

- (NSDictionary *)encodeToJSON{
    NSMutableDictionary *flower = [[NSMutableDictionary alloc] init];
    NSDictionary *auth = [[NSDictionary alloc] initWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token, k_DEVICE_TOKEN, nil];
    NSDictionary *given = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithLongLong:_num_flower], k_FLOWER, _post_id, k_POST_ID, nil];
    
    [flower setObject:auth forKey:k_AUTH];
    [flower setObject:given forKey:k_GIVEN];
    
    return flower;
}

@end
