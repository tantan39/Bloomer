//
//  JSON_CheckFBExist.m
//  Bloomer
//
//  Created by Le Chau Tu on 11/27/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "JSON_CheckFBExist.h"

@implementation JSON_CheckFBExist

-(id)initWithJSON:(NSDictionary *)json {
    self = [super initWithJSON:json];
    if(self) {
        _is_exist = [[json objectForKey:@"is_exist"] boolValue];
        _unverify = [[json objectForKey:@"unverify"] boolValue];
        if (_is_exist) {
            self.user = [[out_auth_authorize alloc] initWithJSON:json];
        }else{
            self.user = [[out_auth_authorize alloc] init];
            self.user.access_token = [[json objectForKey:k_AUTH] objectForKey:k_ACCESS_TOKEN];
            self.user.refresh_token = [[json objectForKey:k_AUTH] objectForKey:k_REFRESH_TOKEN];
        }
    }
    return self;
}

@end
