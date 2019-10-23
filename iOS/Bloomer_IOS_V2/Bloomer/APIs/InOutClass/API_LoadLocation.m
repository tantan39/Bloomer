//
//  API_LoadLocation.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/8/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_LoadLocation.h"

@implementation API_LoadLocation

- (instancetype)init{
    self = [super initWith:[APIDefine location_loadLink] Params:nil];
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
