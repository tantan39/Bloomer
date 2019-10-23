//
//  API_Profile_Location.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/16/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Profile_Location.h"

@implementation API_Profile_Location

- (instancetype)initWithParams:(location *)params{
    self = [super initWith:[APIDefine profile_locationLink] Params:[params encodeToJSON]];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return  (BaseJSON *)[[out_name_update alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[out_name_update alloc] init];
}

@end
