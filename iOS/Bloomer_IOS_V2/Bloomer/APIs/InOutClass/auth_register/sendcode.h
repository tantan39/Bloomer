//
//  sendcode.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/8/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"

@interface sendcode : NSObject<BaseJSON>

@property (strong, nonatomic) NSString *credential;
@property (strong, nonatomic) NSString *secret_client;
@property (assign, nonatomic) NSInteger app_id;
@property (assign, nonatomic) NSInteger country_id;
@property (strong, nonatomic) NSString * device_id;

@property (assign, nonatomic) BOOL voice;
//@property (assign, nonatomic) NSInteger gender;

-(id)initWithCredential:(NSString *)credential Secret_Client:(NSString *)secret_client App_ID:(NSInteger)app_id Country_ID:(NSInteger)country_id DeviceID:(NSString *) deviceId voice:(BOOL)voice;
@end

