//
//  out_profile_setting_fetch.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 10/19/15.
//  Copyright © 2015 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"

@interface out_profile_setting_fetch : NSObject<BaseJSON>

@property (assign, nonatomic) NSInteger uid;
@property (strong, nonatomic) NSString *country_code;
@property (assign, nonatomic) NSInteger gender;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *mobile_full;
@property (assign, nonatomic) NSInteger location_id;
@property (strong, nonatomic) NSString *location_name;
@property (assign, nonatomic) NSInteger chatting;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *about_me;
@property (strong, nonatomic) NSString *avatar;

@end
