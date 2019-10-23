//
//  FeedProfile.h
//  Bloomer
//
//  Created by Le Chau Tu on 8/11/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedProfile : NSObject

@property (assign, nonatomic) NSInteger uid;
@property (assign, nonatomic) BOOL is_share;
@property (assign, nonatomic) BOOL is_follow;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *username;

-(id)initWithUid:(NSInteger)uid
        is_share:(BOOL)is_share
       is_follow:(BOOL)is_follow
            name:(NSString*)name
          avatar:(NSString*)avatar
        username:(NSString*)username;

@end
