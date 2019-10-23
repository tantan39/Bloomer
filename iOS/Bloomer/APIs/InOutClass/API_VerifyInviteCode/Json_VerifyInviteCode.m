//
//  Json_VerifyInviteCode.m
//  Bloomer
//
//  Created by Phan Van Thanh Dat on 10/15/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "Json_VerifyInviteCode.h"

@implementation Json_VerifyInviteCode
- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        self.flower = [[json objectForKey:k_NUM_FLOWER] integerValue];
        self.message = [json objectForKey:k_INVITE_NOTICE];
    }
    return self;
}
@end
