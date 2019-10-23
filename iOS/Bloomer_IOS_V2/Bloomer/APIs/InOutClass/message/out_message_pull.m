//
//  out_message_pull.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/1/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "out_message_pull.h"

@implementation out_message_pull

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        _messages = [[NSMutableArray alloc] init];
        
        NSArray *payload = [json objectForKey:k_PAYLOAD];
        for(NSInteger i = 0; i < payload.count; i++)
        {
            NSDictionary *message_id = [payload objectAtIndex:i];
            message *newMessage = [[message alloc] initWithJSON:message_id];
            
            [_messages addObject:newMessage];
        }
        
        NSDictionary *alert = [json objectForKey:k_ALERT];
        _notification = [[alert objectForKey:k_NOTIFICATION] integerValue];
        _redirect_url = [json objectForKey:k_REDIRECT_URI];
        
        _messages_read = [[NSMutableArray alloc] init];
        NSArray *messages_read = [json objectForKey:k_MESSAGES_READ];
        for(NSInteger i = 0; i < messages_read.count; i++)
        {
            [_messages_read addObject:[messages_read objectAtIndex:i]];
        }
        
        self.isBlock = [[json objectForKey:k_IS_BLOCK] boolValue];
        self.blocker = [[json objectForKey:k_BLOCKER] integerValue];
        self.blockMessage = [json objectForKey:k_MESSAGE];
    }
    return self;
}

@end
