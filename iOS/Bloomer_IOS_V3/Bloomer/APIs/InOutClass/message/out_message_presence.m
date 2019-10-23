//
//  out_message_presence.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/1/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "out_message_presence.h"

@implementation out_message_presence

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        _is_block = [[json objectForKey:k_IS_BLOCK] integerValue] == 1 ? true : false;
        _messages = [[NSMutableArray alloc] init];
        
        NSArray *output = [json objectForKey:k_MESSAGES];
        for(NSInteger i = 0; i < output.count; i++)
        {
            NSDictionary *message_id = [output objectAtIndex:i];
            message *newMessage = [[message alloc] initWithJSON:message_id];
            [_messages addObject:newMessage];
        }
        
        _redirect_url = [json objectForKey:k_REDIRECT_URI];
        self.blockMessage = [json objectForKey:k_MESSAGE];
        self.blocker = [[json objectForKey:k_BLOCKER] integerValue];
    }
    return self;
}


@end
