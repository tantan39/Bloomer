//
//  APi_Profile_ChangeGender.m
//  Bloomer
//
//  Created by Tran Thai Tan on 7/26/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "APi_Profile_ChangeGender.h"

@implementation APi_Profile_ChangeGender

- (instancetype)initWithParams:(profile_change_gender *)params{
    self = [super initWith:[APIDefine profile_change_genderLink] Params:[params encodeToJSON]];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    out_auth_register_verifycode * model;
    if (json) {
        model = [[out_auth_register_verifycode alloc] initWithJSON:json];
    }
    return (BaseJSON *)model;
}

@end
