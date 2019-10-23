//
//  API_Profile_Update.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/28/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Profile_Update.h"

@implementation API_Profile_Update

- (instancetype)init{
    self = [super initWith:[APIDefine profile_updateLink] Params:nil];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return  (BaseJSON *)[[out_profile_update alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[out_profile_update alloc] init];
}

@end
