//
//  API_Notification_Pull.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/10/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Notification_Pull.h"

@implementation API_Notification_Pull

- (instancetype)initWithAuth_Session:(NSString *)auth_session device_token:(NSString *)device_token{
    NSString *header = [NSString stringWithFormat:@"%@:%@", auth_session, device_token];
    self = [super initWith:[APIDefine notification_pullLink] Params:nil];
    [self postParamToHeader:header forKey:h_AUTHENTICATION];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        out_notification_pull * model = [[out_notification_pull alloc] initWithJSON:json];
        return (BaseJSON *) model;
    }
    return (BaseJSON *) [[out_notification_pull alloc] init];
}

@end
