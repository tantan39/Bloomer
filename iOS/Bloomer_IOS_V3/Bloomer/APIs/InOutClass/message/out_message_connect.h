//
//  out_message_connect.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 3/31/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "jsonAbstractClass.h"
//#import "jsonAbstractClassProtected.h"
#import "BaseJSON.h"
#import "APIDefine.h"


@interface out_message_connect : NSObject<BaseJSON>

@property (weak, nonatomic) NSString* auth_session;
@property (assign, nonatomic) NSInteger expire_time;

@end


