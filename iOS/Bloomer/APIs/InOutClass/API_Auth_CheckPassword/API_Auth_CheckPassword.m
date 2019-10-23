//
//  API_CheckPassword.m
//  Bloomer
//
//  Created by Tan Tan on 3/7/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "API_Auth_CheckPassword.h"

@implementation API_Auth_CheckPassword

- (instancetype)initWithPhoneNumb:(NSString *)phoneNumb AppID:(NSInteger)appID CountryID:(NSInteger)countryID{
    NSDictionary * params = @{ k_MOBILE : phoneNumb,
                               k_APP_ID : [NSNumber numberWithInteger:appID],
                               k_COUNTRY_ID : [NSNumber numberWithInteger:countryID]
                               };
    self = [super initWith:[APIDefine auth_checkpasswordLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return (BaseJSON *)[[JSON_CheckPassword alloc] initWithJSON:json];
    }
    return (BaseJSON *)[[JSON_CheckPassword alloc] init];
}


@end
