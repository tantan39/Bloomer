//
//  message.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/1/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "message.h"

@implementation message

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        _message_id = [json objectForKey:k_MID];
        _body = [json objectForKey:k_MSG];
        _resource = [[json objectForKey:k_RESOURCE] integerValue];
        _timestamp = [[json objectForKey:k_TIMESTAMP] doubleValue];
        _timestamp_relative = [json objectForKey:k_TIMESTAMP_RELATIVE];
        _read = [[json objectForKey:k_READ] integerValue];
        _sent = [[json objectForKey:k_SENT] integerValue];
        _sender_id = [[json objectForKey:k_SENDER] integerValue];
        _room_id = [json objectForKey:k_ROOM_ID];
        _alert = [[json objectForKey:k_ALERT] integerValue];
        _name = [json objectForKey:k_NAME];
        _userName = [json objectForKey:k_USERNAME];
        _avatar = [json objectForKey:k_AVATAR];
    }
    return self;
}

@end


@implementation ChatStatus

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        _block = [[json objectForKey:k_BLOCK] integerValue];
        _msg = [json objectForKey:k_Block_Msg];
    }
    return self;
}

@end
