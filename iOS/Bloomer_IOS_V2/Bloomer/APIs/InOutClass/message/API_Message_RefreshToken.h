//
//  API_Message_RefreshToken.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/21/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "BaseJSON.h"
#import "out_message_refresh_token.h"

@interface API_Message_RefreshToken : BloomerRestful

-(instancetype)initWithAddressLink:(NSString*)address_link access_token:(NSString*)access_token device_token:(NSString*)device_token;

@end
