//
//  JSON_Auth_RegisterInfo.m
//  Bloomer
//
//  Created by Tan Tan on 10/17/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "JSON_Auth_RegisterInfo.h"

@implementation JSON_Auth_RegisterInfo

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        self.m_id = [[json objectForKey:k_MID] integerValue];
        self.errors = [json objectForKey:@"error"];
    }
    return self;
}

@end
