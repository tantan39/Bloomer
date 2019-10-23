//
//  API_Anonymous_LoadLocation.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/8/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Anonymous_LoadLocation.h"

@implementation API_Anonymous_LoadLocation

- (instancetype)init{
    self = [super initWith:[APIDefine anonymous_load_location_racesLink] Params:nil];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        out_location_load * model = [[out_location_load alloc] initWithJSON:json];
        return (BaseJSON *) model;
    }
    return (BaseJSON *) [[out_location_load alloc] init];
}

@end
