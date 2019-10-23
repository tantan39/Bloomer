//
//  out_auth_authorize.h
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/8/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"
#import "APIDefine.h"

@interface out_auth_authorize : NSObject<BaseJSON>

@property NSInteger uid;
@property (strong, nonatomic) NSString *screen_name;
@property long long num_flower;
@property NSInteger expire_time,number_chatting;
@property (strong, nonatomic) NSString *refresh_token;
@property (strong, nonatomic) NSString *cridential_ejab;
@property (strong, nonatomic) NSString *access_token;
@property (assign, nonatomic) BOOL is_model;
@property (assign, nonatomic) NSInteger iRace;
@property (strong, nonatomic) NSString *race_name;
@property (strong, nonatomic) NSString *avatar_url;
@property NSInteger gender;
@property (assign, nonatomic) BOOL verified;


@end
