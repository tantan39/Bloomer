//
//  API_ProfileUpdateBirthday.m
//  Bloomer
//
//  Created by Steven on 10/19/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "API_ProfileUpdateBirthday.h"

@implementation API_ProfileUpdateBirthday

- (id)initWithAccessToken:(NSString*)accessToken deviceToken:(NSString*)deviceToken birthday:(NSString*)birthday
{
    NSDictionary *params = @{
                             k_AUTH: @{
                                     k_ACCESS_TOKEN: accessToken,
                                     k_DEVICE_TOKEN: deviceToken
                                     },
                             k_PROFILE: @{
                                     k_BIRTHDAY: birthday
                                     }
                             };
    return [super initWith:[APIDefine profile_updateBirthday] Params:params];
}

- (BaseJSON *)handleJSON:(NSDictionary *)json
{
    if (json)
    {
        return  (BaseJSON *)[[out_name_update alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[out_name_update alloc] init];
}

@end
