//
//  API_GetInviteCode.h
//  Bloomer
//
//  Created by Steven on 12/20/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BloomerRestful.h"
#import "Json_InviteCode.h"

@interface API_GetInviteCode : BloomerRestful

- (id)initWithAccessToken:(NSString *)access_token
             device_token:(NSString *)device_token;

@end
