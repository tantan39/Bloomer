//
//  out_auth_register_sendcode.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/8/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "out_auth_register_sendcode.h"

@implementation out_auth_register_sendcode

- (instancetype)initWithJSON:(NSDictionary *)json{

    self = [super init];
    if (self) {
        @try {
            _m_id = [[json objectForKey:k_M_ID] integerValue];
        } @catch (NSException *exception) {
            NSLog(@"_m_id error %@",exception.description);
        }
        _unverify = [[json objectForKey:@"unverify"] boolValue];
        _status = [[json objectForKey:k_STATUS] boolValue];

    }
    
    return self;
}

@end
