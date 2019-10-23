//
//  API_Delete_Conversation.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/3/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Delete_Conversation.h"

@implementation API_Delete_Conversation

- (instancetype)initWithParams:(deleteConversionData *)data{
    self = [super initWith:[APIDefine room_delete] Params:[data encodeToJSON]];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json
{
    NSLog(@"%@", json);
    out_account_forget_verifycode * model = [[out_account_forget_verifycode alloc] init];
    if (json) {
        model = [[out_account_forget_verifycode alloc] initWithJSON:json];
    }
    return (BaseJSON *) model;
}

@end
