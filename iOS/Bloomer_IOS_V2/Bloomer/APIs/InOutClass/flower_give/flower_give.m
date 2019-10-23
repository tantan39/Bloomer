//
//  flower_give.m
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/12/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import "flower_give.h"

@implementation flower_give

-(id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token num_flower:(long long)num_flower model:(NSInteger)model key:(NSString *)key ckey:(NSString *)ckey
{
    self = [super init];
    
    if(self)
    {
        _access_token = access_token;
        _device_token = device_token;
        _num_flower = num_flower;
        _model = model;
        _key = key;
        _ckey = ckey;
    }
    
    return self;
}

- (NSDictionary *)encodeToJSON{
    NSMutableDictionary *auth = [[NSMutableDictionary alloc] init];
    [auth setObject:_access_token forKey:k_ACCESS_TOKEN];
    [auth setObject:_device_token forKey:k_DEVICE_TOKEN];
    
    NSMutableDictionary *given = [[NSMutableDictionary alloc] init];
    [given setObject:[NSNumber numberWithLongLong:_num_flower] forKey:k_FLOWER];
    [given setObject:[NSNumber numberWithInteger:_model] forKey:k_MODEL];
    [given setObject:_key forKey:k_KEY];
    [given setObject:_ckey forKey:k_CKEY];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:auth forKey:k_AUTH];
    [dictionary setObject:given forKey:k_GIVEN];

    return dictionary;
}

@end


//#pragma mark - GIVING TO CHAT
//@implementation flower_give_chat
//
//-(id)initWithAccessToken:(NSString *)access_token device_token:(NSString*)device_token num_flower:(long long)num_flower receiver:(NSInteger)receiver
//{
//    self = [super init];
//    
//    if(self)
//    {
//        _access_token = access_token;
//        _device_token = device_token;
//        _num_flower = num_flower;
//        _receiver = receiver;
//    }
//    
//    return self;
//    
//}
//
//-(NSString *)createStringJSON {
//    NSMutableDictionary* flower = [[NSMutableDictionary alloc] init];
//    [flower setObject:_access_token forKey:k_ACCESS_TOKEN];
//    [flower setObject:_device_token forKey:k_DEVICE_TOKEN];
//    [flower setObject:[NSNumber numberWithLongLong:_num_flower] forKey:k_NUM_FLOWER];
//    [flower setObject:[NSNumber numberWithInteger:_receiver] forKey:k_RECEIVER];
//    
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:flower options:NSJSONWritingPrettyPrinted error:&error];
//    NSString* result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    return result;
//}
//
//
//@end
