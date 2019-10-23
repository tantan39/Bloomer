//
//  API_Message_Connect.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/10/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Message_Connect.h"

@implementation API_Message_Connect

- (instancetype)initWithSecret_Ejab:(NSString *)secret_ejab credential_ejab:(NSString *)credential_ejab device_token:(NSString *)device_token{
    
    NSString *header = [NSString stringWithFormat:@"%@:%@:%@", secret_ejab, credential_ejab, device_token];
    NSLog(@"header : %@", header);

    self = [super initWith:[APIDefine message_connectLink] Params:nil];
    [self postParamToHeader:header forKey:h_AUTHENTICATION];
    
    return self;
    
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        out_message_connect * model =  [[out_message_connect alloc] initWithJSON:json];
        return (BaseJSON *) model;
    }
    return (BaseJSON *) [[out_message_connect alloc] init];
}

@end
