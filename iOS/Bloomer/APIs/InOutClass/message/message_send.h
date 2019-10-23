//
//  message_send.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/2/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//
//
// Resource Type:
//   0 : Text
//   1 : Image
//   2 : Video
//   3 : Giving Flower


#import <Foundation/Foundation.h>
#import "BaseJSON.h"

typedef NS_ENUM(NSUInteger, ResourceType)
{
    //RES_TYPE_NONE,
    RES_TYPE_TEXT,
    RES_TYPE_IMAGE,
    RES_TYPE_VIDEO,
    RES_TYPE_GIVE_FLOWER,
    RES_TYPE_STICKER
};
//typedef NSInteger ResourceType;

@interface message_send : NSObject<BaseJSON>

@property (strong, nonatomic) NSString* message;
@property (assign, nonatomic) NSInteger resource;
@property (assign, nonatomic) NSInteger rev;
@property (assign, nonatomic) NSInteger timestamp;
@property (strong, nonatomic) NSString* timestamp_relative;

-(id)initWithMessage:(NSString*)message rev:(NSInteger)rev resType:(NSInteger)resType timestamp:(NSInteger)timestamp timestamp_relative:(NSString*)timestamp_relative;
-(id)initWithMessage:(NSString*)message rev:(NSInteger)rev resType:(NSInteger)resType;

@end
