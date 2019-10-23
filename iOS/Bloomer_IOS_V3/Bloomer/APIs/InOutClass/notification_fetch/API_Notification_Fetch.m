//
//  API_Notification_Fetch.m
//  Bloomer
//
//  Created by Tran Thai Tan on 10/12/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Notification_Fetch.h"

@implementation API_Notification_Fetch

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token notification_id:(NSString *)notification_id{
    
    NSDictionary * params = @{k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token,
                              k_NOTIFICATION_ID : notification_id
                              };
    self = [super initWith:[APIDefine notification_fetchLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return (BaseJSON *)[[out_notification_fetch alloc] initWithJSON:json];
    }
    return (BaseJSON *)[[out_notification_fetch alloc] init];
}

@end
