//
//  rewardMembership.m
//  Bloomer
//
//  Created by Thanh Tu Nguyen on 8/3/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "RewardMembership.h"

@implementation RewardMembership 

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super init];
    if (self) {
        _Bronze = [json[@"B"] integerValue];
        _Silver = [json[@"S"] integerValue];
        _Gold = [json[@"G"] integerValue];
    }
    return self;
}


@end
