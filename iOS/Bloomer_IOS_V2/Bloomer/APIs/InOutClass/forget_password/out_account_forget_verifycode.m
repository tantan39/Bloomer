//
//  out_account_forget_verifycode.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/10/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "out_account_forget_verifycode.h"

@implementation out_account_forget_verifycode

//-(void)extractData:(NSDictionary*) data
//{
//    _f_id = [[data objectForKey:k_F_ID] integerValue];
//}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        _f_id = [[json objectForKey:k_F_ID] integerValue];
    }
    return self;
}

@end
