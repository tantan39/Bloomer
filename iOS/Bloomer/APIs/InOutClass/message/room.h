//
//  room.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/6/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//
// Data structure:
//{
//    message =     {
//        body = Hagh;
//        "message_id" = "mid:rid:90:92:1459155070958";
//    };
//    read = 1;
//    "room_id" = "rid:90:92";
//    rosters =     (
//                   {
//                       avatar = "http://dev.photos.bloomerapp.vn:8181/bloomer_photos/hphotos-bl/avatar/v1.0/92/s";
//                       "is_block" = 0;
//                       "is_online" = 0;
//                       mocode = "";
//                       name = hjdty;
//                       spcode = "";
//                       uid = 92;
//                       username = "Ms.Bloomer_82183";
//                   }
//                   );
//    timestamp = 1459155070958;
//}


#import <Foundation/Foundation.h>
#import "BaseJSON.h"

@interface room : NSObject<BaseJSON>

@property (strong, nonatomic) NSString* room_id; //
@property (assign, nonatomic) NSInteger read; // 0-unread, 1-read
@property (assign, nonatomic) NSInteger uid; // userID
@property (assign, nonatomic) BOOL is_block, is_chat;
@property (assign, nonatomic) NSInteger moColor ; // model Color Code
@property (strong, nonatomic) NSString* screen_name; // Display Name
@property (assign, nonatomic) BOOL is_online;
@property (strong, nonatomic) NSString* avatar; // link to avata's image
@property (assign, nonatomic) NSInteger spColor ; // sponsor Color Code
@property (strong, nonatomic) NSString* user_name; // User Name
@property (assign, nonatomic) long long timestamp; //
@property (strong, nonatomic) NSString* body; // content of message
@property (strong, nonatomic) NSString* message_id; //

@property (assign, nonatomic) NSInteger sender_id;
@property (assign, nonatomic) NSInteger resource; // resourcetype
@property (assign, nonatomic) BOOL justUnblockChat;
@property (assign, nonatomic) NSInteger blocker;
@property (strong, nonatomic) NSString* blockMessage;

//add more params


@end
