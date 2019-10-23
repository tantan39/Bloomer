//
//  out_profile_setting.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/12/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"

@interface out_profile_setting : NSObject<BaseJSON>

@property (assign, nonatomic) BOOL private_share;

@property (strong, nonatomic) NSString *country_code;
@property (strong, nonatomic) NSString *country_short_name;
@property (strong, nonatomic) NSString *country_name;
@property (assign, nonatomic) NSInteger country_id;

@property (assign, nonatomic) long long number_chatting;
@property (strong, nonatomic) NSString *mocode;
@property (assign, nonatomic) NSInteger gender;

@property (strong, nonatomic) NSString *city_name;
@property (strong, nonatomic) NSString *city_short_name;
@property (assign, nonatomic) NSInteger city_id;

@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *about_me;
@property (strong, nonatomic) NSString *thanks;
@property (assign, nonatomic) NSInteger uid;

@property (assign, nonatomic) BOOL all;
@property (assign, nonatomic) BOOL app;
@property (assign, nonatomic) BOOL race;
@property (assign, nonatomic) BOOL chat;
@property (assign, nonatomic) BOOL follow;
@property (assign, nonatomic) BOOL flower;
@property (assign, nonatomic) BOOL verified_email;

@property (assign, nonatomic) long long number_flower;
@property (strong, nonatomic) NSString *screen_name;
@property (strong, nonatomic) NSString *spcode;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *birthday;

@end
