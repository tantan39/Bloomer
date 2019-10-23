//
//  out_transaction_check.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 8/11/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "out_transaction_check.h"

@implementation out_transaction_check

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        _isDel = [[json objectForKey:k_IS_DEL] boolValue];
    }
    return self;
}

@end
