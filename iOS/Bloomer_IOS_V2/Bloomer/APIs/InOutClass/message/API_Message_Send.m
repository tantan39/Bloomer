//
//  API_Message_Send.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/18/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Message_Send.h"

@implementation API_Message_Send

- (instancetype)initWithParams:(message_send *)params ResponseID:(NSString *)responseID Header:(NSString *) header{
    
    self = [super initWith:[APIDefine message_sendLink] Params:[params encodeToJSON]];
    self.responseID = responseID;
    [self postParamToHeader:header forKey:h_AUTHENTICATION];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return  (BaseJSON *)[[out_message_send alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[out_message_send alloc] init];
}

@end
