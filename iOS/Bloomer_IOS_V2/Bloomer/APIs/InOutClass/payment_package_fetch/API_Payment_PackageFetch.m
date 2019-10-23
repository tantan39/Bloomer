//
//  API_Payment_PackageFetch.m
//  Bloomer
//
//  Created by Tran Thai Tan on 10/10/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Payment_PackageFetch.h"

@implementation API_Payment_PackageFetch

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token{

    NSDictionary * params = @{k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token
                              };
    self = [super initWith:[APIDefine payment_packageLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return (BaseJSON *)[[out_payment_package_fetch alloc] initWithJSON:json];
    }
    return (BaseJSON *)[[out_payment_package_fetch alloc] init];
}

@end
