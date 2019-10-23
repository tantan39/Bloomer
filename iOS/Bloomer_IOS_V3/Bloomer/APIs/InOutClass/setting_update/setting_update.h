//
//  setting_update.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/17/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "jsonAbstractClass.h"
#import "BaseJSON.h"
#import "APIDefine.h"
@interface setting_update : NSObject<BaseJSON>

@property (weak, nonatomic) NSString* access_token;
@property (weak, nonatomic) NSString* device_token;
@property (assign, nonatomic) BOOL notification;
@property (assign, nonatomic) NSInteger chatting;

-(id)initWithAccessToken:(NSString*)access_token device_token:(NSString*)device_token chatting:(NSInteger)chatting;

@end
