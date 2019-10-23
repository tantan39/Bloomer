//
//  API_PostUserFetches.m
//  Bloomer
//
//  Created by Ahri on 8/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_ReasonFetch.h"

@implementation API_ReasonFetch

- (id)initWithType:(NSInteger)type {
    NSDictionary *params = @{
                             k_TYPE: @(type).stringValue
                             };
    self = [super initWith:[APIDefine reason_fetchLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json {
    JSON_ReasonFetch *model;
    if (json) {
        model = [[JSON_ReasonFetch alloc] initWithJSON:json];
    }
    return (BaseJSON *)model;
}

@end
