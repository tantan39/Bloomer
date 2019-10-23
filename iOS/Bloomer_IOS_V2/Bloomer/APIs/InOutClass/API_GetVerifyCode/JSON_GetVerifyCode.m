//
//  JSON_GetVerifyCode.m
//  Bloomer
//
//  Created by Tan Tan on 3/6/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "JSON_GetVerifyCode.h"

@implementation JSON_GetVerifyCode

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if(self) {
        _unverify = [[json objectForKey:@"unverify"] boolValue];
        @try {
            _m_id = [[json objectForKey:@"m_id"] integerValue];
        } @catch (NSException *exception) {
            NSLog(@"%@",exception.description);
        }
        
    }
    return self;
}

@end
