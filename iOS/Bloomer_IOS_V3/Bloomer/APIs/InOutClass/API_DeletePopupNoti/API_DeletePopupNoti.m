//
//  API_DeletePopupNoti.m
//  Bloomer
//
//  Created by Thanh Tu Nguyen on 11/21/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_DeletePopupNoti.h"
#import "BaseJSON.h"


@implementation API_DeletePopupNoti

-(instancetype)initWithAccessToken:(NSString*)access_token device_id:(NSString*)device_id noti_id:(NSInteger)noti_id addType:(NSInteger)type
{
    self= [super init];
    if(self)
    {
        NSDictionary *params = @{k_ACCESS_TOKEN: access_token,
                                 k_DEVICE_TOKEN: device_id,
                                 @"noti_id": [@(noti_id) stringValue],
                                 @"type":[@(type) stringValue]};
        self = [super initWith:[APIDefine deletePopupNoti] Params:params];
    }
    return self;
}

- (BaseJSON *) handleJSON:(NSDictionary *) json
{
    deletePopupNoti* dataJson;
    if(json)
    {
        dataJson = [[deletePopupNoti alloc] initWithJSON:json];
    }
    return (BaseJSON*)dataJson;
}

@end
