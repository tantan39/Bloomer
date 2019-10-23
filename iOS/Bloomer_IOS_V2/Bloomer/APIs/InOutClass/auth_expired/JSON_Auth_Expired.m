//
//  JSON_Auth_Expired.m
//  Bloomer
//
//  Created by Le Chau Tu on 12/13/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "JSON_Auth_Expired.h"

@implementation JSON_Auth_Expired

-(instancetype)initWithJSON:(NSDictionary *)json {
    self = [super init];
    if (self) {
        _is_expired = [[json objectForKey:k_IS_EXPIRED] boolValue];
    }
    return self;
}

@end
