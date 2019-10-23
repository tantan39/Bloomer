//
//  Json_InviteCode.m
//  Bloomer
//
//  Created by Steven on 12/21/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "Json_InviteCode.h"

@implementation Json_InviteCode

-(instancetype)initWithJSON:(NSDictionary *)json {
    self = [super init];
    if(self) {
        self.user_code = [json objectForKey:@"user_code"];
        self.invite_flower = [[json objectForKey:@"invite_flower"] longValue];
    }
    return self;
}

@end
