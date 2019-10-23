//
//  API_Notification_Setting.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/14/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Notification_Setting.h"

@implementation API_Notification_Setting

- (instancetype)initWithParams:(notification_setting *)params{
    self = [super initWith:[APIDefine profile_notiSettingLink] Params:[params encodeToJSON]];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return (BaseJSON *) [[out_name_update alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[out_name_update alloc] init];
}

@end
