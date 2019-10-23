//
//  message.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/1/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//
// Data structure
//{
//    body = Hagh;
//    read = 1;
//    resource = 0;
//    "room_id" = "rid:90:92";
//    sender = 90;
//    sent = 1;
//    timestamp = 1459155070958;
//}

#import "BaseJSON.h"

@interface message : NSObject<BaseJSON>

@property (strong, nonatomic) NSString* room_id;
@property (strong, nonatomic) NSString* message_id;
@property (strong, nonatomic) NSString* body;
@property (assign, nonatomic) NSInteger resource; // resourcetype
@property (assign, nonatomic) double timestamp;
@property (weak, nonatomic) NSString* timestamp_relative;
@property (assign, nonatomic) NSInteger read;
@property (assign, nonatomic) NSInteger sent;
@property (assign, nonatomic) NSInteger sender_id;
@property (weak, nonatomic) NSString* responseID;
@property (assign, nonatomic) NSInteger alert;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* userName;
@property (strong, nonatomic) NSString* avatar;

@end


@interface ChatStatus : NSObject<BaseJSON>
@property (assign, nonatomic) NSInteger block;
@property (strong,nonatomic) NSString * msg;
@end
