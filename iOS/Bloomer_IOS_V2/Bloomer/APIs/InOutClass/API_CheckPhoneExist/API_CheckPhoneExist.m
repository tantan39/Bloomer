//
//  API_CheckPhoneExist.m
//  Bloomer
//
//  Created by Le Chau Tu on 11/27/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_CheckPhoneExist.h"

@implementation API_CheckPhoneExist

-(instancetype)initWithPhoneNumber:(NSString *)phone_number country_id:(NSInteger)country_id device_id:(NSString *)device_id{
    NSDictionary *params = @{@"mobile"   :   phone_number,
                             @"country_id"  :   [NSNumber numberWithInteger:country_id],
                             k_DEVICE_TOKEN :   device_id,
//                             @"fb_id"       :   fb_id ? fb_id : @""
                             };
    self = [super initWith:[APIDefine CheckPhoneExistLink] Params:params];
    return self;
}

-(BaseJSON *)handleJSON:(NSDictionary *)json {
    JSON_CheckPhoneExist *model;
    if(json) {
        model = [[JSON_CheckPhoneExist alloc] initWithJSON:json];
    }
    return (BaseJSON*)model;
}

@end
