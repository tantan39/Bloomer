//
//  API_FlowerGivingPopup.m
//  Bloomer
//
//  Created by Tan Tan on 4/19/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "API_FlowerGivingPopup.h"

@implementation API_FlowerGivingPopup

- (instancetype)initWithAccessToken:(NSString *)accessToken DeviceToken:(NSString *)deviceToken{
    NSDictionary * params = @{k_ACCESS_TOKEN : accessToken,
                              k_DEVICE_TOKEN : deviceToken
                              };
    
    self = [super initWith:[APIDefine flower_givingPopupLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return (BaseJSON *)[[JSON_FlowerGivingPopup alloc] initWithJSON:json];
    }
    return (BaseJSON *)[[JSON_FlowerGivingPopup alloc] init];
}

@end
