//
//  JSON_CheckPhoneExist.m
//  Bloomer
//
//  Created by Le Chau Tu on 11/27/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "JSON_CheckPhoneExist.h"

@implementation JSON_CheckPhoneExist

-(instancetype)initWithJSON:(NSDictionary *)json {
    self = [super init];
    if(self) {
        _is_exist = [[json objectForKey:@"is_exist"] boolValue];
        _unverify = [[json objectForKey:@"unverify"] boolValue];
    }
    return self;
}

@end
