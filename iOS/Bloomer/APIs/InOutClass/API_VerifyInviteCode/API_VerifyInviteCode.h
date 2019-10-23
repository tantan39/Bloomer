//
//  API_VerifyInviteCode.h
//  Bloomer
//
//  Created by Steven on 12/22/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BloomerRestful.h"
#import "Json_VerifyInviteCode.h"

@interface API_VerifyInviteCode : BloomerRestful

- (instancetype)initWithAccessToken:(NSString *)access_token
             device_token:(NSString *)device_token
              invite_code:(NSString*)invite_code;


@end
