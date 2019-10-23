//
//  API_Profile_AddBanners.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/24/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Profile_AddBanners.h"

@implementation API_Profile_AddBanners

- (instancetype)initWithParams:(banners_add *)params{
    self = [super initWith:[APIDefine profile_bannerAddLink] Params:[params encodeToJSON]];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return  (BaseJSON *)[[out_banner_add alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[out_banner_add alloc] init];
}

@end
