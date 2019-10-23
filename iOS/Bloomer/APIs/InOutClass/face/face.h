//
//  face.h
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/15/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIDefine.h"

@interface face : NSObject

@property (assign, nonatomic) NSInteger timestamp;
@property (strong, nonatomic) NSString* uri_photo;
@property (strong, nonatomic) NSString* name;
@property (assign, nonatomic) NSInteger uid;
@property (strong, nonatomic) NSString* avatar;
@property (strong, nonatomic) NSString* post_id;
@property (strong, nonatomic) NSString* photo_id;
@property (assign, nonatomic) long long num_flower;
@property (strong, nonatomic) NSString* content_post;

-(id)initWithTimeStamp: (NSInteger) time uri_photo:(NSString*) uri name:(NSString*)userName uid:(NSInteger) user_id num_flower:(long long) num avatar:(NSString*) ava post_id:(NSString*)postid photo_id:(NSString*)photoid content_post:(NSString*)content_post;

@end
