//
//  flower_give_post.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 10/23/15.
//  Copyright © 2015 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"

@interface flower_give_post : NSObject<BaseJSON>

@property (weak, nonatomic) NSString *access_token;
@property (weak, nonatomic) NSString *device_token;
@property (assign, nonatomic) long long num_flower;
@property (assign, nonatomic) NSString *post_id;
@property (assign, nonatomic) NSInteger receiver;

- (id)initWithAccessToken:(NSString *)access_token
             device_token:(NSString *)device_token
               num_flower:(long long)num_flower
                   postID:(NSString *)post_id;

- (id)initWithAccessToken:(NSString *)access_token
             device_token:(NSString *)device_token
               num_flower:(long long)num_flower
                   postID:(NSString *)post_id
                 receiver:(NSInteger)receiver;
@end
