//
//  API_PostUserFetches.m
//  Bloomer
//
//  Created by Ahri on 8/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_WinnersClub.h"

@implementation API_WinnersClub

- (id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token
                      gsb:(NSInteger)gsb gender:(NSInteger)gender uid:(NSNumber *)lastUid {
    NSDictionary *params = @{
                             k_ACCESS_TOKEN: access_token,
                             k_DEVICE_TOKEN: device_token,
                             k_GSB: @(gsb).stringValue,
                             k_GENDER: @(gender).stringValue,
                             k_UID: lastUid == nil ? [NSNull null] : lastUid.stringValue
                             };
    
    self = [super initWith:[APIDefine getClubWinnersFetchLink] Params:params];
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
