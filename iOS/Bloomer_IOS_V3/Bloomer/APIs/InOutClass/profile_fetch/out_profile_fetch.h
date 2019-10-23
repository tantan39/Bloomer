//
//  out_profile_fetch.h
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/12/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "jsonAbstractClass.h"
#import "city.h"
#import "BaseJSON.h"

@interface out_profile_fetch : NSObject<BaseJSON>

@property (strong, nonatomic) NSString *about_me;
@property (strong, nonatomic) NSString *avatar;
@property (assign, nonatomic) NSInteger follower;
@property (assign, nonatomic) NSInteger following;
@property (strong, nonatomic) NSString *location_name;
@property (strong, nonatomic) NSString *mocolor;
@property (strong, nonatomic) NSString *name;

@property (assign, nonatomic) long long number_chatting;
@property (assign, nonatomic) long long num_received_flower;
@property (assign, nonatomic) long long flower_thankful;
@property (assign, nonatomic) long long gaveFlower;
@property (strong, nonatomic) NSString *spcolor;
@property (assign, nonatomic) NSInteger uid;
@property (strong, nonatomic) NSString *username;

@property (assign, nonatomic) NSInteger gender;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *color_code;
@property (assign, nonatomic) long long your_num_flower;
@property (assign, nonatomic) long invite_flower;

@property (strong, nonatomic) NSString *email;
@property (assign, nonatomic) NSInteger chatting;

@property (strong, nonatomic) NSString *birthday;
@property (assign, nonatomic) NSInteger rank;
@property (strong, nonatomic) NSString* living_in;
@property (assign, nonatomic) NSInteger sponsors;
@property (assign, nonatomic) BOOL is_chat;
@property (assign, nonatomic) BOOL is_follow;
@property (assign, nonatomic) BOOL isFav;
@property (assign, nonatomic) NSInteger remain_flower;
@property (strong, nonatomic) NSString* race_name;

@property (assign, nonatomic) BOOL is_block;
@property (assign, nonatomic) BOOL is_blocked;
@property (assign, nonatomic) BOOL is_block_chat;
@property (assign, nonatomic) BOOL is_blocked_chat;

@property (assign, nonatomic) NSInteger blocker;

@property (assign, nonatomic) NSInteger location_id;
@property (assign, nonatomic) NSInteger verified;

@property (strong, nonatomic) city* city;
@property (strong, nonatomic) NSString* invite_code;
@property (strong, nonatomic) NSString* video_link;
@property (assign, nonatomic) BOOL isupload_avatar;

@property (strong, nonatomic) NSString* gsb_medal;

@property (assign, nonatomic) BOOL pass;

@end
