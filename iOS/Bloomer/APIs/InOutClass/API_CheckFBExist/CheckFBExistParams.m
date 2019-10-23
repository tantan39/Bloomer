//
//  CheckFBExistParams.m
//  Bloomer
//
//  Created by Le Chau Tu on 11/27/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "CheckFBExistParams.h"

@implementation CheckFBExistParams

-(id)initWithFBToken:(NSString *)fb_token device_id:(NSString *)device_id app_id:(NSInteger)app_id notification_token:(NSString *)notification_token {
    self = [super init];
    if(self) {
        _fb_token = fb_token;
        _device_id = device_id;
        _app_id = app_id;
        _notification_token = notification_token;
    }
    return self;
}

-(NSDictionary *)encodeToJSON {
    NSDictionary *json = @{@"fb_token"              : _fb_token,
                           @"device_id"             : _device_id,
                           @"app_id"                : [NSNumber numberWithInteger:_app_id],
                           @"notification_token"    : _notification_token
                           };
    return json;
}

@end
