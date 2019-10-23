//
//  API_GetVersion.m
//  Bloomer
//
//  Created by Tran Thai Tan on 7/25/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_GetVersion.h"

@implementation API_GetVersion

- (instancetype)init{
    self = [super initWith:[APIDefine getVersionLink] Params:nil];
    
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    out_getversion * model;
    
    if (json) {
        model = [[out_getversion alloc] initWithJSON:json];
    }
    
    return (BaseJSON *)model;
}

@end
