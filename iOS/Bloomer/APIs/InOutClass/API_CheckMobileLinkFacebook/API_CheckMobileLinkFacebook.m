//
//  API_CheckMobileLinkFacebook.m
//  Bloomer
//
//  Created by Steven on 3/11/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "API_CheckMobileLinkFacebook.h"
#import "APIDefine.h"
#import "BaseJSON.h"

@implementation API_CheckMobileLinkFacebook

- (instancetype)initWithMobile:(NSString *)mobile countryID:(NSInteger)countryID deviceToken:(NSString *)deviceToken
{
    NSDictionary *parameters = @{
                                 @"mobile": mobile,
                                 @"country_id": [NSNumber numberWithInteger:countryID],
                                 @"device_id": deviceToken
                                 };
    self = [super initWith:[APIDefine auth_checkMobileLinkFacebook] Params:parameters];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json
{
    JSON_CheckMobileLinkFacebook *model;
    if (json)
    {
        model = [[JSON_CheckMobileLinkFacebook alloc] initWithJSON:json];
    }
    return (BaseJSON *)model;
}

@end
