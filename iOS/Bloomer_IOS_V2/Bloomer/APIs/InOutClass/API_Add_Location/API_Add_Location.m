//
//  API_Add_Location.m
//  Bloomer
//
//  Created by Thanh Tu Nguyen on 3/9/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "API_Add_Location.h"

@implementation API_Add_Location

- (instancetype)initWithParams:(inputAddLocation *)params{
    self = [super initWith:[APIDefine profile_addLocation] Params:[params encodeToJSON]];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return  (BaseJSON *)[[out_name_update alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[out_name_update alloc] init];
}

@end
