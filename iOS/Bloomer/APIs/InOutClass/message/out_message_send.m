//
//  out_message_send.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/2/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "out_message_send.h"

@implementation out_message_send

//-(void)extractData:(NSDictionary*) data
//{
//    _message_id = [data objectForKey:k_MESSAGE_ID];
//    _isConnected = [[data objectForKey:k_IS_CONNECTED] boolValue];
//    _sent = [[data objectForKey:k_SENT] integerValue];
//    _redirec_uri = [data objectForKey:k_REDIRECT_URI];
//}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        _message_id = [json objectForKey:k_MESSAGE_ID];
        _isConnected = [[json objectForKey:k_IS_CONNECTED] boolValue];
        _sent = [[json objectForKey:k_SENT] integerValue];
        _redirec_uri = [json objectForKey:k_REDIRECT_URI];
    }
    return self;
}

@end
