//
//  feed_list.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/11/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface feed_list : NSObject

@property (strong, nonatomic) NSString *racekey;
@property (strong, nonatomic) NSString *content_type;
@property (strong, nonatomic) NSString *content_id;
@property (strong, nonatomic) NSString *start;
@property (strong, nonatomic) NSString *end;
@property (strong, nonatomic) NSString *racenames;
@property (strong, nonatomic) NSString *feed_id;
@property (assign, nonatomic) BOOL is_album;
@property (strong, nonatomic) NSString *caption;
@property (assign, nonatomic) long long flower;
@property (strong, nonatomic) NSString *photo_id;
@property (strong, nonatomic) NSString *photo_url;
@property (strong, nonatomic) NSString *post_id;
@property (strong, nonatomic) NSMutableArray *tags;
@property (strong, nonatomic) NSMutableArray *post;
@property (assign, nonatomic) long long timestamp;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger uid;
@property (assign, nonatomic) BOOL is_share;
@property (strong, nonatomic) NSString *username;
@property (assign, nonatomic) NSInteger total_post;
@property (assign, nonatomic) long long mygiveflower;

- (id)initWithRacekey:(NSString *)racekey
         content_type:(NSString *)content_type
           content_id:(NSString *)content_id
                start:(NSString *)start
                  end:(NSString *)end
            racenames:(NSString *)racenamse
              feed_id:(NSString *)feed_id
              isAlbum:(BOOL)is_album
              caption:(NSString *)caption
               flower:(long long)flower
              photoID:(NSString *)photo_id
             photoURL:(NSString *)photo_url
               postID:(NSString *)post_id
                 tags:(NSMutableArray *)tags
                 post:(NSMutableArray *)post
            timeStamp:(long long)timestamp
               avatar:(NSString *)avatar
                 name:(NSString *)name
                  uid:(NSInteger)uid
              isShare:(BOOL)is_share
             username:(NSString *)username
            totalPost:(NSInteger)totalPost
         mygiveflower:(long long)mygiveflower;

@end
