//
//  API_Message_Connect.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/10/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "APIDefine.h"
#import "BaseJSON.h"
#import "out_message_connect.h"

@interface API_Message_Connect : BloomerRestful

-(instancetype) initWithSecret_Ejab:(NSString*)secret_ejab credential_ejab:(NSString*)credential_ejab device_token:(NSString*)device_token;

@end
