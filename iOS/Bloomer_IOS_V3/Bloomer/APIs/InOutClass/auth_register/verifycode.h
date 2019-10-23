//
//  verifycode.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/8/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIDefine.h"
#import "BaseJSON.h"
@interface verifycode : NSObject<BaseJSON>

@property (strong, nonatomic) NSString* credential;
@property (strong, nonatomic) NSString* device_token;
@property (strong, nonatomic) NSString* notification_token;
@property (strong, nonatomic) NSString* secret_client;
@property (assign, nonatomic) NSInteger app_id;

-(id)initWithCredential:(NSString*)credential Device_Token:(NSString*)device_token notification_token:(NSString*)notification_token Secret_Client:(NSString*)secret_client App_ID:(NSInteger)app_id;

@end


