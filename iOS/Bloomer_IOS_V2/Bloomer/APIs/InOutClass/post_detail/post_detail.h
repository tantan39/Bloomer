//
//  post_detail.h
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/15/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "givers.h"
#import "out_post_comment_fetch.h"
#import "BaseJSON.h"

@interface post_detail : NSObject<BaseJSON>

@property (assign, nonatomic) NSInteger timestamp;
@property (strong, nonatomic) NSString* content_post;
@property (assign, nonatomic) NSInteger num_giver;
@property (strong, nonatomic) givers *give;
@property (assign, nonatomic) NSInteger uid_account;
@property (strong, nonatomic) NSString* screen_name_account;
@property (strong, nonatomic) NSString* avatar_account;
@property (strong, nonatomic) NSString* photo_id_account;
@property (strong, nonatomic) NSString* post_id;
@property (strong, nonatomic) NSString* photo_id;
@property (strong, nonatomic) out_post_comment_fetch *commentData;
@property (assign, nonatomic) long long num_flower;
@property (strong, nonatomic) NSString* photo;

@end
