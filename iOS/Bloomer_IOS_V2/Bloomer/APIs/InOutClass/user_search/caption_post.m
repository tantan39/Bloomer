//
//  caption_post.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/27/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "caption_post.h"

@implementation caption_post

- (id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token post_id:(NSString *)post_id caption:(NSString *)caption {
    self = [super init];
    
    if (self) {
        _access_token = access_token;
        _device_token = device_token;
        _post_id = post_id;
        _caption = caption;// [caption stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    return self;
}

//- (NSString *)createStringJSON {
//    NSDictionary *auth = [NSDictionary dictionaryWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token,k_DEVICE_TOKEN, nil];
//    NSDictionary *profile = [NSDictionary dictionaryWithObjectsAndKeys:_post_id, k_POST_ID, _caption, k_CAPTION, nil];
//    
//    NSMutableDictionary *upload = [[NSMutableDictionary alloc] init];
//    
//    [upload setObject:auth forKey:k_AUTH];
//    [upload setObject:profile forKey:k_PAYLOAD];
//    
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:upload options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    return result;
//}

- (NSDictionary *)encodeToJSON{
    NSDictionary *auth = [NSDictionary dictionaryWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token,k_DEVICE_TOKEN, nil];
    NSDictionary *profile = [NSDictionary dictionaryWithObjectsAndKeys:_post_id, k_POST_ID, _caption, k_CAPTION, nil];
    
    NSMutableDictionary *upload = [[NSMutableDictionary alloc] init];
    
    [upload setObject:auth forKey:k_AUTH];
    [upload setObject:profile forKey:k_PAYLOAD];
    
    return upload;
}

@end
