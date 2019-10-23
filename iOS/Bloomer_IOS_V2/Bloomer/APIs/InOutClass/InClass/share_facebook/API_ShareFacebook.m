//
//  API_ShareFacebook.m
//  Bloomer
//
//  Created by Steven on 12/10/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "API_ShareFacebook.h"

@implementation API_ShareFacebook

-(instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token isPopup:(BOOL)isPopup {

    NSDictionary * params = @{k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token,
                              @"isPopup"     : isPopup ? @"true" : @"false"};
    self = [super initWith:[APIDefine shareFacebookLink] Params:params];

    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return (BaseJSON *)[[Json_ShareFacebook alloc] initWithJSON:json];
    }
    return  (BaseJSON *)[[Json_ShareFacebook alloc] init];
}

@end
