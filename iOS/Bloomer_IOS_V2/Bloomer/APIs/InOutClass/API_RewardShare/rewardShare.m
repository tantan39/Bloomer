//
//  rewardShare.m
//  Bloomer
//
//  Created by Thanh Tu Nguyen on 1/4/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "rewardShare.h"

@implementation rewardShare

-(instancetype)initWithJSON:(NSDictionary *)json {
    self = [super init];
    if(self) {
        _numflower = [[json objectForKey:@"num_flower"] integerValue];
    }
    return self;
}

@end
