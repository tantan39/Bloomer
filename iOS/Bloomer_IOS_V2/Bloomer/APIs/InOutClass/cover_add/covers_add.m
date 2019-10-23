//
//  covers_add.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 7/21/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "covers_add.h"

@implementation covers_add

- (id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token photos:(NSMutableArray *)photos {
    self = [super init];
    
    if(self)
    {
        _access_token = access_token;
        _device_token = device_token;
        _photos = photos;
    }
    
    return self;
}

//-(NSString *) createStringJSON
//{
//    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token, k_DEVICE_TOKEN, _photos, k_PHOTOS, nil];
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    return result;
//}

- (NSDictionary *)encodeToJSON{
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token, k_DEVICE_TOKEN, _photos, k_PHOTOS, nil];
    return info;
}

@end
