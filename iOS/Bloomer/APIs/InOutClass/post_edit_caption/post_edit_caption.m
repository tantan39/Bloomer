//
//  post_edit_caption.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 5/19/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "post_edit_caption.h"

@implementation post_edit_caption

-(id)initWithAccessToken:(NSString*)access_token Device_Token:(NSString*)device_token Post_ID:(NSString*)post_id Content_Post:(NSString*)content_post
{
    self = [super init];
    
    if(self)
    {
        _access_token = access_token;
        _device_token = device_token;
        _post_id = post_id;
        _content_post = content_post;
    }
    
    return self;
}

//-(NSString *) createStringJSON
//{
//    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token, k_DEVICE_TOKEN, _post_id, k_POST_ID, _content_post, k_CONTENT_POST, nil];
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
//    NSString* result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    return result;
//}

- (NSDictionary *)encodeToJSON{
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token, k_DEVICE_TOKEN, _post_id, k_POST_ID, _content_post, k_CONTENT_POST, nil];

    return info;
}

@end
