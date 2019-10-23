//
//  room.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/6/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "room.h"

@implementation room

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        NSDictionary *message= [json objectForKey:k_MESSAGE];
        NSArray *rosters = [json objectForKey:k_ROSTERS];
        
        _read = [[json objectForKey:k_READ] integerValue];
        _room_id = [json objectForKey:k_ROOM_ID] ;
        _timestamp = [[json objectForKey:k_TIMESTAMP] longLongValue];
        
        if ([json objectForKey:k_MESSAGE] != [NSNull null])
        {
            _body = [message objectForKey:k_BODY];
            _message_id = [message objectForKey:k_MESSAGE_ID];
            _resource = [[message objectForKey:k_RESOURCE] integerValue];
            _sender_id = [[message objectForKey:k_SENDER_ID] integerValue];
            self.justUnblockChat = [[message objectForKey:k_JUST_UNBLOCK_CHAT] boolValue];
        }
        
        if (rosters.count != 0)
        {
            NSDictionary *roster = [rosters objectAtIndex:0];
            _uid = [[roster objectForKey:k_UID] integerValue];
            _screen_name = [roster objectForKey:k_NAME];
            _is_online = [[roster objectForKey:k_IS_ONLINE] boolValue];
            _is_block = [[roster objectForKey:k_IS_BLOCK] boolValue];
            _is_chat = [[roster objectForKey:k_IS_CHAT] boolValue];
            _avatar = [roster objectForKey:k_AVATAR];
            //add more params
            _moColor = [[roster objectForKey:k_MO_COLOR] integerValue];
            _spColor = [[roster objectForKey:k_SP_COLOR] integerValue];
            _user_name = [roster objectForKey:k_USERNAME];
            
            if ([roster objectForKey:k_BLOCKER] != [NSNull null])
            {
                _blocker = [[roster objectForKey:k_BLOCKER] integerValue];
            }
            
            if ([roster objectForKey:k_MESSAGE] != [NSNull null])
            {
                self.blockMessage = [roster objectForKey:k_MESSAGE];
            }
        }
    }
    return self;
}

@end
