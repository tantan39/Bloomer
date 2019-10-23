//
//  account_forget_changepass.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/10/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "jsonAbstractClass.h"
#import "APIDefine.h"
#import "BaseJSON.h"

@interface account_forget_changepass : NSObject <BaseJSON>

@property (weak, nonatomic) NSString *credential;
@property (weak, nonatomic) NSString *secret_client;
@property (weak, nonatomic) NSString *device_token;
@property (assign, nonatomic) NSInteger app_id;

-(id)initWithCredential:(NSString*)credential secretClient:(NSString*)secret_client deviceToken:(NSString*)device_token appID:(NSInteger)app_id;

@end

