//
//  Post.h
//  Bloomer
//
//  Created by Le Chau Tu on 8/10/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostContent : NSObject

@property (strong, nonatomic) NSString* post_id;
@property (strong, nonatomic) NSString* photo_id;
@property (assign, nonatomic) long long mygiveflower;
@property (strong, nonatomic) NSString* caption;
@property (strong, nonatomic) NSString* photo_url;
@property (assign, nonatomic) long long timestamp;
@property (assign, nonatomic) long long flower;
@property (strong, nonatomic) NSMutableArray* tags;

-(id)initWithPostId:(NSString*)post_id
           photo_id:(NSString*)photo_id
       mygiveflower:(long long)mygiveflower
            caption:(NSString*)caption
          photo_url:(NSString*)photo_url
          timestamp:(long long)timestamp
             flower:(long long)flower
               tags:(NSMutableArray*)tags;

-(id)initWithPostId:(NSString*)post_id
       mygiveflower:(long long)mygiveflower
          photo_url:(NSString*)photo_url;

@end
