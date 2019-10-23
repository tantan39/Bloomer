//
//  API_Account_ForgetWho.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/3/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Account_ForgetWho.h"

@implementation API_Account_ForgetWho

- (instancetype)initWithParams:(account_forget_who *)data{
    self = [super initWith:[APIDefine account_forget_whoLink] Params:[data encodeToJSON]];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    out_account_forget_who * model;
    if (json) {
        model = [[out_account_forget_who alloc] initWithJSON:json];
    }
    return (BaseJSON *) model;
}

@end
