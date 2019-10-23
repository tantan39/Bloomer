//
//  API_WinnersClubSearch.m
//  Bloomer
//
//  Created by Ahri on 10/14/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_WinnersClubSearch.h"

@implementation API_WinnersClubSearch

- (id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token
                      gsb:(NSInteger)gsb gender:(NSInteger)gender page:(NSInteger)page
                     size:(NSInteger)size term:(NSString *)term {
    NSDictionary *params = @{
                             k_ACCESS_TOKEN: access_token,
                             k_DEVICE_TOKEN: device_token,
                             k_GSB: @(gsb).stringValue,
                             k_GENDER: @(gender).stringValue,
                             k_TERM: term,
                             K_PAGE: @(page).stringValue,
                             k_SIZE: @(size).stringValue
                             };
    
    self = [super initWith:[APIDefine getClubWinnersSearchLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json {
    JSON_WinnersClub *model;
    if (json) {
        model = [[JSON_WinnersClub alloc] initWithJSON:json];
    }
    return (BaseJSON *)model;
}

@end
