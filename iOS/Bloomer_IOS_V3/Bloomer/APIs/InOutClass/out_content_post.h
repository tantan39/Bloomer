//
//  content_post.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/15/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "jsonAbstractClass.h"
//#import "jsonAbstractClassProtected.h"
#import "comment.h"

@interface out_content_post : NSObject<BaseJSON>

@property (assign, nonatomic) NSInteger size;
@property (assign, nonatomic) NSInteger uid;
@property (assign, nonatomic) BOOL is_share;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *post_id;
@property (assign, nonatomic) BOOL is_avatar;
@property (assign, nonatomic) BOOL is_follow;
@property (strong, nonatomic) NSString *caption;
@property (strong, nonatomic) NSString *photo_url;
@property (strong, nonatomic) NSString *photo_url_full;
@property (assign, nonatomic) long long timestamp;
@property (assign, nonatomic) long long flower;
@property (assign, nonatomic) long long mygiveflower;
@property (strong, nonatomic) NSMutableArray *tags;
@property (strong, nonatomic) NSMutableArray *list;

- (instancetype) initWithFeedJSON:(NSDictionary *) feedJSON;
@end
