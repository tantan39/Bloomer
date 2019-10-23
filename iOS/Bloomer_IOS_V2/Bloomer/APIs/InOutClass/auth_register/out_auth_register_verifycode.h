//
//  out_auth_register_verifycode.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/8/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "jsonAbstractClass.h"
#import "APIDefine.h"
#import "BaseJSON.h"
@interface out_auth_register_verifycode : NSObject<BaseJSON>

@property (strong, nonatomic) NSString *access_token;
@property (strong, nonatomic) NSString *refresh_token;
@property (strong, nonatomic) NSString *expire_time;

@end
