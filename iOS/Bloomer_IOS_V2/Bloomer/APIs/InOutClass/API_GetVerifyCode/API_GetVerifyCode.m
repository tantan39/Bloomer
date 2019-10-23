//
//  API_GetVerifyCode.m
//  Bloomer
//
//  Created by Tan Tan on 3/6/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "API_GetVerifyCode.h"

@implementation API_GetVerifyCode

- (instancetype)initWithPhoneNumb:(NSString *)phone CountryID:(NSInteger)countryID DeviceID:(NSString *)deviceID{
    
    NSDictionary * params = @{k_MOBILE : phone,
                              k_COUNTRY_ID : [NSNumber numberWithInteger:countryID],
                              k_DEVICE_TOKEN : deviceID
                              };
    
    self = [super initWith:[APIDefine auth_sendcodeLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return (BaseJSON *)[[JSON_GetVerifyCode alloc] initWithJSON:json];
    }
    return (BaseJSON *)[[JSON_GetVerifyCode alloc] init];
}

@end
