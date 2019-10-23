//
//  discovery.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/4/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "feed_pic.h"

@interface DiscoveryModel : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *username;
@property (assign, nonatomic) NSInteger uid;
@property (assign, nonatomic) long long received_flower;
@property (strong, nonatomic) NSString *avatar;
@property (assign, nonatomic) Boolean isBlock;
@property (assign, nonatomic) Boolean isAlbum;
@property (assign, nonatomic) NSInteger totalPost;
@property (strong, nonatomic) NSMutableArray *posts;
@property (strong, nonatomic) NSString *feed_id;

- (id)initWithUid:(NSInteger)uid received_flower:(long long)received_flower name:(NSString *)name username:(NSString *)username avatar:(NSString *)avatar isBlock:(Boolean)isBlock posts:(NSMutableArray *)posts isAlbum:(Boolean)isAlbum totalPost:(NSInteger)totalPost feedID:(NSString *) feed_id;

@end
