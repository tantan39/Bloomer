//
//  API_Message_Pull.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/17/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Message_Pull.h"

@implementation API_Message_Pull

-(instancetype)initWithAuth_Session:(NSString*)auth_session device_token:(NSString*)device_token room_id:(NSString*)room_id
{
    //room_id=.
    NSDictionary * params = @{k_ROOM_ID : room_id};
    
    NSString *header = [NSString stringWithFormat:@"%@:%@", auth_session, device_token];
    
    self = [super initWith:[APIDefine message_pull_roomLink] Params:params];
    [self postParamToHeader:header forKey:h_AUTHENTICATION];
    
    return self;
}

-(instancetype)initWithAuth_Session:(NSString*)auth_session device_token:(NSString*)device_token roster_id:(NSInteger)roster_id
{
    
    NSDictionary * params = @{k_ROSTER_ID : @(roster_id).stringValue};
    
    NSString *header = [NSString stringWithFormat:@"%@:%@", auth_session, device_token];
    
    self = [self initWith:[APIDefine message_pull_rosterLink] Params:params];
    [self postParamToHeader:header forKey:h_AUTHENTICATION];

    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return  (BaseJSON *)[[out_message_pull alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[out_message_pull alloc] init];
}

@end
