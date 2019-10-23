//
//  out_block_chat.m
//  Bloomer
//
//  Created by Le Chau Tu on 4/7/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "out_block_chat.h"

@implementation out_block_chat
//-(void)extractData:(NSDictionary*)data {
//    _screenname = [data objectForKey:k_SCREEN_NAME];
//    _username = [data objectForKey:k_USERNAME];
//    _avatar = [data objectForKey:k_AVATAR];
//    _uid = [[data objectForKey:k_UID] integerValue];
//}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        _screenname = [json objectForKey:k_SCREEN_NAME];
        _username = [json objectForKey:k_USERNAME];
        _avatar = [json objectForKey:k_AVATAR];
        _uid = [[json objectForKey:k_UID] integerValue];
    }
    return self;
}
@end
