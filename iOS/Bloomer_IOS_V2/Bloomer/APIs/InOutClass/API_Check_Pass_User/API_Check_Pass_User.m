//
//  API_Check_Pass_User.m
//  Bloomer
//
//  Created by Thanh Tu Nguyen on 3/6/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "API_Check_Pass_User.h"

@implementation API_Check_Pass_User

- (instancetype)initWithParams:(checkPassObject *) params
{
    self = [super init];
    if(self)
    {
        self = [super initWith:[APIDefine profile_checkPassUser] Params:[params encodeToJSON]];
    }
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return  (BaseJSON *)[[resultCheckPass alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[resultCheckPass alloc] init];
}

@end
