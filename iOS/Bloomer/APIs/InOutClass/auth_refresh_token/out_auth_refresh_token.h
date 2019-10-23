//
//  out_auth_refresh_token.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/23/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

//#import "jsonAbstractClass.h"
//#import "jsonAbstractClassProtected.h"
#import "BaseJSON.h"
#import "APIDefine.h"

@interface out_auth_refresh_token : NSObject<BaseJSON>

@property (weak, nonatomic) NSString *access_token;

@end
