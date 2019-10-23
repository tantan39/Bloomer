//
//  Feed.h
//  Bloomer
//
//  Created by Le Chau Tu on 8/10/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"
#import "FeedProfile.h"

@interface Feed : NSObject

//race feed
@property (strong, nonatomic) NSString *racekey;
@property (strong, nonatomic) NSString *racename;

//feed
@property (strong, nonatomic) NSMutableArray *posts;
@property (assign, nonatomic) BOOL is_album;
@property (assign, nonatomic) long long total_flower;
@property (assign, nonatomic) NSInteger total_post;
@property (strong, nonatomic) NSString *feed_id;
@property (assign, nonatomic) long long timestamp;

//content
@property (strong, nonatomic) NSString *content_type;
@property (strong, nonatomic) NSString *content_id;

//profile
@property (strong, nonatomic) FeedProfile *profile;

-(id)initWithContentType:(NSString*)content_type
              content_id:(NSString*)content_id
                 profile:(FeedProfile*)profile
                is_album:(BOOL)is_album
            total_flower:(long long)total_flower
              total_post:(NSInteger)total_post
                 feed_id:(NSString*)feed_id
               timestamp:(long long)timestamp
                   posts:(NSMutableArray*)posts
                racename:(NSString*)racename
                 racekey:(NSString*)racekey;

@end
