//
//  auth_refresh_token.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/23/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "jsonAbstractClass.h"
//#import "jsonAbstractClassProtected.h"
#import "BaseJSON.h"
#import "APIDefine.h"

@interface auth_refresh_token : NSObject<BaseJSON>

@property (weak, nonatomic) NSString *device_token;
@property (weak, nonatomic) NSString *access_token;
@property (weak, nonatomic) NSString *refresh_token;
@property (weak, nonatomic) NSString *secret_client;

-(id)initWithDevice_Token:(NSString*)device_token access_token:(NSString*)access_token refresh_token:(NSString*)refresh_token secret_client:(NSString*)secret_client;

@end
