//
//  API_MobileVerify.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/14/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_MobileVerify.h"

@implementation API_MobileVerify

- (instancetype)initWithParams:(mobile_verify *)params{
    self = [super initWith:[APIDefine profile_mobileVerifyLink] Params:[params encodeToJSON]];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return  (BaseJSON *)[[out_name_update alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[out_name_update alloc] init];
}
@end
