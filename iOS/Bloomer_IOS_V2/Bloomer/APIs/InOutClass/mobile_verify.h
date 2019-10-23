//
//  mobile_verify.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/23/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "jsonAbstractClass.h"
#import "BaseJSON.h"
#import "APIDefine.h"

@interface mobile_verify : NSObject<BaseJSON>

@property (strong, nonatomic) NSString *access_token;
@property (strong, nonatomic) NSString *device_token;
@property (strong, nonatomic) NSString *codes;
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *secret_client;
@property (strong, nonatomic) NSString *credential;

- (id)initWithAccess_Token:(NSString *)access_token
              device_token:(NSString *)device_token
                      code:(NSString *)codes
                       uid:(NSString *)uid
             secret_client:(NSString *)secret_client
                credential:(NSString *)credential;

@end
