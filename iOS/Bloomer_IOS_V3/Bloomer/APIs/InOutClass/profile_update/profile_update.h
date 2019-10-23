//
//  profile_update.h
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/11/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"

@interface profile_update : NSObject<BaseJSON>

@property (weak, nonatomic) NSString* access_token;
@property (weak, nonatomic) NSString* device_token;
@property (strong, nonatomic) NSString* screen_name;
@property (strong, nonatomic) NSString* mobile;
@property (assign, nonatomic) NSInteger gender;
@property (weak, nonatomic) NSString* living_in;
@property (weak, nonatomic) NSString* about_me;
@property (weak, nonatomic) NSString* birthday;

-(id)initWithAccess_Token:(NSString *)access_token device_token:(NSString*)device_token screen_name:(NSString *)screen_name mobile:(NSString *)mobile gender:(NSInteger)gender living_in:(NSString *)living_in about_me:(NSString *)about_me birthday:(NSString *)birthday;

@end
