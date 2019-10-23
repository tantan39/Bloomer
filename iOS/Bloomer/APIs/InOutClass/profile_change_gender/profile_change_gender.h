//
//  profile_change_gender.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 7/24/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "jsonAbstractClass.h"
#import "BaseJSON.h"
#import "APIDefine.h"
@interface profile_change_gender : NSObject<BaseJSON>

@property (weak, nonatomic) NSString* access_token;
@property (weak, nonatomic) NSString* device_token;
@property (assign, nonatomic) NSInteger gender;

-(id)initWithAccess_Token:(NSString *)access_token device_token:(NSString*)device_token gender:(NSInteger)gender;

@end
