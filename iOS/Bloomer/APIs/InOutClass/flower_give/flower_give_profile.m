//
//  flower_give_profile.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/18/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "flower_give_profile.h"

@implementation flower_give_profile
-(id)initWithAccessToken:(NSString *)access_token device_token:(NSString*)device_token num_flower:(long long)num_flower receiver:(NSInteger)receiver
{
    self = [super init];
    
    if(self)
    {
        _access_token = access_token;
        _device_token = device_token;
        _num_flower = num_flower;
        _receiver = receiver;
    }
    
    return self;
    
}

- (NSDictionary *)encodeToJSON{
    NSMutableDictionary* auth = [[NSMutableDictionary alloc] init];
    [auth setObject:_device_token forKey:k_DEVICE_TOKEN];
    [auth setObject:_access_token forKey:k_ACCESS_TOKEN];
    
    NSMutableDictionary* given = [[NSMutableDictionary alloc] init];
    [given setObject:[NSNumber numberWithLongLong:_num_flower] forKey:k_FLOWER];
    [given setObject:[NSNumber numberWithInteger:_receiver] forKey:k_MODEL];
    
    NSMutableDictionary* flower = [[NSMutableDictionary alloc] init];
    [flower setObject:auth forKey:k_AUTH];
    [flower setObject:given forKey:k_GIVEN];
    
    return flower;
}

@end
