//
//  API_Post_Delete.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/3/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "BaseJSON.h"
#import "APIDefine.h"
#import "out_account_forget_verifycode.h"

@interface API_Post_Delete : BloomerRestful

-(instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString*)device_token post_id:(NSString*)post_id;

@end
