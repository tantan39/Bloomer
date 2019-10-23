//
//  out_profile_update.h
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/11/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"

@interface out_profile_update : NSObject<BaseJSON>

@property (assign, nonatomic) NSInteger uid;
@property (strong, nonatomic) NSString *birthday;
@property (assign, nonatomic) NSInteger rank;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *about_me;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger gender;
//@property (assign, nonatomic) NSInteger num_received_flower;
//@property (assign, nonatomic) NSInteger your_num_flower;
@property (strong, nonatomic) NSString* living_in;
@property (strong, nonatomic) NSString* mobile;

@end
