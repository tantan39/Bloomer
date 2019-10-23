//
//  API_Room_Delete.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/3/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "BaseJSON.h"
#import "APIDefine.h"
#import "out_account_forget_verifycode.h"

@interface API_Room_Delete : BloomerRestful

-(instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString*)device_token roomID:(NSString *)roomID ;

@end
