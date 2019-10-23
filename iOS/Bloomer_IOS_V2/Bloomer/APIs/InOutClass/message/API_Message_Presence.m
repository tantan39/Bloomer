//
//  API_Message_Presence.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/17/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Message_Presence.h"

@implementation API_Message_Presence

- (instancetype)initWithAuth_Session:(NSString *)auth_session device_token:(NSString *)device_token room_id:(NSString *)room_id mid:(NSString *)mid{
//room_id=...&mid=..
    NSDictionary * params = @{k_ROOM_ID : room_id,
                              k_Chat_Message_ID : mid};
    
    NSString *header = [NSString stringWithFormat:@"%@:%@", auth_session, device_token];
    
    self = [super initWith:[APIDefine message_presence_roomLink] Params:params];
    
    
    [self postParamToHeader:header forKey:h_AUTHENTICATION];
    
    return self;
}

- (instancetype)initWithAuth_Session:(NSString *)auth_session device_token:(NSString *)device_token roster_id:(NSInteger)roster_id mid:(NSString *)mid isLoadMore:(BOOL)isMore{

    NSDictionary * params = @{k_ROSTER_ID : @(roster_id).stringValue,
                              k_Chat_Message_ID : mid};
    
    NSString *header = [NSString stringWithFormat:@"%@:%@", auth_session, device_token];
    self = [super initWith:[APIDefine message_presence_rosterLink] Params:params];
    [self postParamToHeader:header forKey:h_AUTHENTICATION];
    self.isLoadMore = isMore;
    
    return self;
}

- (instancetype)initWithAuth_Session:(NSString *)auth_session device_token:(NSString *)device_token roster_id:(NSInteger)roster_id mid:(NSString *)mid{
    
    NSDictionary * params = @{k_ROSTER_ID : @(roster_id).stringValue,
                              k_Chat_Message_ID : mid};
    
    NSString *header = [NSString stringWithFormat:@"%@:%@", auth_session, device_token];
    
    self = [super initWith:[APIDefine message_presence_rosterLink] Params:params];
    [self postParamToHeader:header forKey:h_AUTHENTICATION];
    
    return self;
    
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return  (BaseJSON *)[[out_message_presence alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[out_message_presence alloc] init];
}

@end
