//
//  sponsors.h
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/15/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"

@interface sponsors : NSObject<BaseJSON>

@property (assign, nonatomic) NSInteger uid;
@property (strong, nonatomic) NSString* screen_name;
@property (strong, nonatomic) NSString* avatar;
@property (strong, nonatomic) NSString* photo_id;
@property (assign, nonatomic) long long num_flower;
@property (assign, nonatomic) BOOL isActiveProfile;
@property (assign, nonatomic) BOOL is_chat;
@property (assign, nonatomic) BOOL is_block;
@property (assign, nonatomic) NSInteger blocker;

@end
