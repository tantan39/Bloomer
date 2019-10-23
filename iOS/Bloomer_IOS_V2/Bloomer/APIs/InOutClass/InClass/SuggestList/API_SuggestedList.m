//
//  API_SuggestedList.m
//  Bloomer
//
//  Created by Steven on 12/19/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "API_SuggestedList.h"

@implementation API_SuggestedList

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token {
    
    NSDictionary * params = @{k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token
                              };
    self = [super initWith:[APIDefine suggestedListLink] Params:params];

    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return (BaseJSON *)[[Json_SuggestedList alloc] initWithJSON:json];
    }
    return (BaseJSON *)[[Json_SuggestedList alloc] init];
}

@end
