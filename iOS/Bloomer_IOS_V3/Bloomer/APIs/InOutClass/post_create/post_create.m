//
//  post_create.m
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/15/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import "post_create.h"

@implementation post_create

- (id)initWithAccessToken:(NSString* )access_token device_token:(NSString *)device_token payloads:(NSMutableArray *)payloads {
    
    self = [super init];
    
    if(self)
    {
        _access_token = access_token;
        _device_token = device_token;
        _payloads = [[NSMutableArray alloc] init];
        
        for (int i = 0 ; i < payloads.count; i++) {
            payload *temp = (payload *) [payloads objectAtIndex:i];

            NSDictionary *pay = [NSDictionary dictionaryWithObjectsAndKeys:temp.photo_id, k_PHOTO_ID, temp.caption, k_CAPTION, temp.tags, k_TAGS, nil];
            [_payloads addObject:pay];
        }
    }
    
    return self;
}

- (NSDictionary *)encodeToJSON{
        NSDictionary *auth = [NSDictionary dictionaryWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token, k_DEVICE_TOKEN, nil];
    
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
        [dictionary setObject:auth forKey:k_AUTH];
        [dictionary setObject:_payloads forKey:k_PAYLOAD];
    
        return dictionary;
}

//-(NSString *) createStringJSON
//{
//    NSDictionary *auth = [NSDictionary dictionaryWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token, k_DEVICE_TOKEN, nil];
//
//    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//
//    [dictionary setObject:auth forKey:k_AUTH];
//    [dictionary setObject:_payloads forKey:k_PAYLOAD];
//
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//
//    return result;
//}

@end
