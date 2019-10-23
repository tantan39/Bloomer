//
//  API_Message_Pull.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/17/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "out_message_pull.h"

@interface API_Message_Pull : BloomerRestful

-(instancetype)initWithAuth_Session:(NSString*)auth_session device_token:(NSString*)device_token room_id:(NSString*)room_id;
-(instancetype)initWithAuth_Session:(NSString*)auth_session device_token:(NSString*)device_token roster_id:(NSInteger)roster_id;

@end
