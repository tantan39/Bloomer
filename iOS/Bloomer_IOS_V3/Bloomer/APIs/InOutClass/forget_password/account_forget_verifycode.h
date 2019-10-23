//
//  account_forget_verifycode.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/10/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "jsonAbstractClass.h"
#import "APIDefine.h"
#import "BaseJSON.h"

@interface account_forget_verifycode : NSObject<BaseJSON>

@property (assign, nonatomic) NSInteger f_id;
@property (strong, nonatomic) NSString* active_code;

-(id)initWithF_ID:(NSInteger)f_id active_code:(NSString*)active_code;

@end

