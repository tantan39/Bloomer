//
//  API_Account_ForgetWho_VoiceCall.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/3/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Account_ForgetWho_VoiceCall.h"

@implementation API_Account_ForgetWho_VoiceCall

- (instancetype)initWithParams:(account_forget_who *)params{
    self = [super initWith:[APIDefine account_forget_voicecall] Params:[params encodeToJSON]];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    out_account_forget_who * model;
    if (json) {
        model = [[out_account_forget_who alloc] initWithJSON:json];
    }
    return (BaseJSON *)model;
}

@end
