//
//  API_Anonymous_ProfileFetch.m
//  Bloomer
//
//  Created by Tran Thai Tan on 7/31/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Anonymous_ProfileFetch.h"

@implementation API_Anonymous_ProfileFetch

- (instancetype)initWithUserID:(NSString *)userID{
    NSDictionary * params = @{k_USER_ID : userID};
    
    self = [super initWith:[APIDefine anonymous_profile_New_fetchLink] Params:params];
    
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    
    out_profile_fetch * model;
    if (json) {
        model = [[out_profile_fetch alloc] initWithJSON:json];
    }
    return (BaseJSON *)model;
}

@end
