//
//  API_CheckFBExist.m
//  Bloomer
//
//  Created by Le Chau Tu on 11/27/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_CheckFBExist.h"

@implementation API_CheckFBExist

-(id)initWithParams:(CheckFBExistParams *)params {
    self = [super initWith:[APIDefine FBCheckExistLink] Params:[params encodeToJSON]];
    return self;
}

-(BaseJSON *)handleJSON:(NSDictionary *)json {
    JSON_CheckFBExist *model;
    if(json) {
        model = [[JSON_CheckFBExist alloc] initWithJSON:json];
    }
    return (BaseJSON *)model;
}

@end
