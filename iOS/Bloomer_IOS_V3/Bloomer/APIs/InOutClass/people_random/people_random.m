//
//  people_random.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 7/23/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "people_random.h"

@implementation people_random

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        _uid = [[json objectForKey:k_UID] integerValue];
        _avatar = [json objectForKey:k_AVATAR];
        _color_code = [json objectForKey:k_COLOR_CODE];
    }
    return self;
}

@end
