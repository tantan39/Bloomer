//
//  API_Auth_Authorize.m
//  Bloomer
//
//  Created by Tran Thai Tan on 7/24/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Auth_Authorize.h"


@implementation API_Auth_Authorize

-(instancetype)initWithParams:(auth_authorize *)authThorize {
    self = [self initWithParams:authThorize viaCode:NO];
    return self;
}

- (instancetype)initWithParams:(auth_authorize *)authThorize viaCode:(BOOL)use_code{
    RequestURL* requestUrl = use_code ? [APIDefine AuthorizeByCodeLink] : [APIDefine AuthorizeByPassLink];
    
    self = [super initWith:requestUrl Params:[authThorize encodeToJSON]];

    return self;
    
}

- (BaseJSON *) handleJSON:(NSDictionary *)json{
    out_auth_authorize * model;
    
    if (json) {
        model = [[out_auth_authorize alloc] initWithJSON:json];
    }
    
    return (BaseJSON *)model;
}

@end
