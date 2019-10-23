//
//  API_Notification_ListUser.m
//  Bloomer
//
//  Created by Tran Thai Tan on 10/12/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Notification_ListUser.h"

@implementation API_Notification_ListUser

- (instancetype)initWithParam:(notification_listuser *)param{
    
    self = [super initWith:[APIDefine notification_getListUser] Params:[param encodeToJSON]];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return (BaseJSON *)[[out_notification_listUser alloc] initWithJSON:json];
    }
    return (BaseJSON *)[[out_notification_listUser alloc] init];
}

@end
