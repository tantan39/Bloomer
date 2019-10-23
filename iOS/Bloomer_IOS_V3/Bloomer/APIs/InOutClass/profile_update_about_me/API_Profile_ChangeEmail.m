//
//  API_Profile_ChangeEmail.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/14/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Profile_ChangeEmail.h"

@implementation API_Profile_ChangeEmail

- (instancetype)initWithParams:(email *)params{
    self = [super initWith:[APIDefine profile_emailLink] Params:[params encodeToJSON]];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return  (BaseJSON *)[[out_name_update alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[out_name_update alloc] init];
}

@end
