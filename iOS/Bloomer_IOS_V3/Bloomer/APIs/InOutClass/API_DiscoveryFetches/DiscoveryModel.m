//
//  discovery.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/4/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "DiscoveryModel.h"

@implementation DiscoveryModel

- (id)initWithUid:(NSInteger)uid received_flower:(long long)received_flower name:(NSString *)name username:(NSString *)username avatar:(NSString *)avatar isBlock:(Boolean)isBlock posts:(NSMutableArray *)posts isAlbum:(Boolean)isAlbum totalPost:(NSInteger)totalPost feedID:(NSString *)feed_id{
    self = [super init];
    if (self) {
        self.uid = uid;
        self.received_flower = received_flower;
        self.name = name;
        self.username = username;
        self.avatar = avatar;
        self.isBlock = isBlock;
        self.isAlbum = isAlbum;
        self.totalPost = totalPost;
        self.posts = posts;
        self.feed_id = feed_id;
    }
    return self;
}

@end
