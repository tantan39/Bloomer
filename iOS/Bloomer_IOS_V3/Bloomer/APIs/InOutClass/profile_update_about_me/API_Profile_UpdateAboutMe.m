//
//  API_Profile_UpdateAboutMe.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/28/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Profile_UpdateAboutMe.h"

@implementation API_Profile_UpdateAboutMe

- (instancetype)initWithParams:(profile_update_about_me *)params{
    self = [super initWith:[APIDefine profile_update_about_meLink] Params:[params encodeToJSON]];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return  (BaseJSON *)[[out_profile_update alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[out_profile_update alloc] init];
}

@end
