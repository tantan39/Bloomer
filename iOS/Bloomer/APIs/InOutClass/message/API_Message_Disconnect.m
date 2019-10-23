//
//  API_Message_Disconnect.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/10/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Message_Disconnect.h"

@implementation API_Message_Disconnect

- (instancetype)initWithAuth_Session:(NSString *)auth_session device_token:(NSString *)device_token{
    NSString *header = [NSString stringWithFormat:@"%@:%@", auth_session, device_token];
    self = [super initWith:[APIDefine message_disconnectLink] Params:nil];
    [self postParamToHeader:header forKey:h_AUTHENTICATION];
    
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json {
    return (BaseJSON *)[[out_message_connect alloc] init];
}
@end
