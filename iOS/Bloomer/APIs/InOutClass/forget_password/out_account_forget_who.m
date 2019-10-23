//
//  out_account_forget_who.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/9/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "out_account_forget_who.h"

@implementation out_account_forget_who

-(void)extractData:(NSDictionary*) data
{
    _uid = [[data objectForKey:k_UID] integerValue];
    _f_id = [[data objectForKey:k_F_ID] integerValue];
}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        _uid = [[json objectForKey:k_UID] integerValue];
        _f_id = [[json objectForKey:k_F_ID] integerValue];
    }
    return self;
}

@end
