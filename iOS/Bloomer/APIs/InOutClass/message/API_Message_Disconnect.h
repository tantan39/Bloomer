//
//  API_Message_Disconnect.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/10/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "APIDefine.h"
#import "BaseJSON.h"
#import "out_message_connect.h"

@interface API_Message_Disconnect : BloomerRestful

- (instancetype)initWithAuth_Session:(NSString *)auth_session device_token:(NSString*)device_token;


@end
