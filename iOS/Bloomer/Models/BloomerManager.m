//
//  BloomerManager.m
//  Bloomer
//
//  Created by Tran Thai Tan on 11/29/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerManager.h"

@implementation BloomerManager

+ (instancetype) shareInstance{
    static BloomerManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {
        _countryID = 1;
        _country_short_name = @"vn";
    }
    return self;
}

@end
