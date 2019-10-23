//
//  out_is_chat_fetch.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 10/26/15.
//  Copyright © 2015 Glassegg. All rights reserved.
//

#import "out_is_chat_fetch.h"

@implementation out_is_chat_fetch

//- (void)extractData:(NSDictionary*) data {
//    if ([data objectForKey:k_IS_CHAT] != [NSNull null])
//        _is_chat = [[data objectForKey:k_IS_CHAT] boolValue];
//
//    if ([data objectForKey:k_REMAIN_FLOWER] != [NSNull null])
//        _remain_flower = [[data objectForKey:k_REMAIN_FLOWER] integerValue];
//}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeBool:_is_chat forKey:k_IS_CHAT];
    [encoder encodeInteger:_remain_flower forKey:k_REMAIN_FLOWER];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super init])) {
        _is_chat = [decoder decodeBoolForKey:k_IS_CHAT];
        _remain_flower = [decoder decodeIntegerForKey:k_REMAIN_FLOWER];
    }
    
    return self;
}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        if ([json objectForKey:k_IS_CHAT] != [NSNull null])
            _is_chat = [[json objectForKey:k_IS_CHAT] boolValue];
        
        if ([json objectForKey:k_REMAIN_FLOWER] != [NSNull null])
            _remain_flower = [[json objectForKey:k_REMAIN_FLOWER] integerValue];
    }
    return self;
}
@end
