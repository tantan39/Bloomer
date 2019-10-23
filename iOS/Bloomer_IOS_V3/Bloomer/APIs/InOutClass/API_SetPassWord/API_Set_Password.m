//
//  API_Set_Password.m
//  Bloomer
//
//  Created by Thanh Tu Nguyen on 3/6/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "API_Set_Password.h"


@implementation API_Set_Password

- (instancetype)initWithParams:(password *)params{
    self = [super initWith:[APIDefine profile_set_PasswordLink] Params:[params encodeToJSON]];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return  (BaseJSON *)[[out_name_update alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[out_name_update alloc] init];
}

@end
