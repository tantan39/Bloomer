//
//  password.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/27/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIDefine.h"
#import "BaseJSON.h"

@interface password : NSObject<BaseJSON>

@property (strong, nonatomic) NSString *access_token;
@property (strong, nonatomic) NSString *device_token;
@property (strong, nonatomic) NSString *secret_client;
@property (strong, nonatomic) NSString *credential;

- (id)initWithAccessToken:(NSString *)access_token
             device_token:(NSString *)device_token
            secret_client:(NSString *)secret_client
               credential:(NSString *)credential;

@end
