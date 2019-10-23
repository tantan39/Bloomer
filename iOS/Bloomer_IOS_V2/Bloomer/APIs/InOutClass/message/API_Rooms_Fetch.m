//
//  API_Rooms_Fetch.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/21/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Rooms_Fetch.h"

@implementation API_Rooms_Fetch

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token room_id:(NSString *)room_id limit:(NSInteger)limit{

    NSDictionary * params = @{k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token,
                              k_ROOM_ID : room_id,
                              k_LIMIT : [NSNumber numberWithInteger:limit]};
    
    self = [super initWith:[APIDefine rooms_fetchLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return  (BaseJSON *)[[out_rooms_fetch alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[out_rooms_fetch alloc] init];
}

@end
