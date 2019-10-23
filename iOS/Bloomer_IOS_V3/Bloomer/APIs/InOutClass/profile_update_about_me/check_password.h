//
//  check_password.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/20/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"
#import "APIDefine.h"

@interface check_password : NSObject<BaseJSON>

@property (strong, nonatomic) NSString *access_token;
@property (strong, nonatomic) NSString *device_token;
@property (strong, nonatomic) NSString *secret_client;
@property (strong, nonatomic) NSString *credential;

- (id)initWithAccess_Token:(NSString *)access_token device_token:(NSString *)device_token secret_client:(NSString *)secret_client credential:(NSString *)credential;

@end
