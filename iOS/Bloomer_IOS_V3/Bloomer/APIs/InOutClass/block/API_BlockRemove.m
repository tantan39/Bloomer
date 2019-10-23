//
//  API_BlockRemove.m
//  Bloomer
//
//  Created by Tran Thai Tan on 7/26/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_BlockRemove.h"

@implementation API_BlockRemove

- (instancetype)initWithParams:(block_remove *)params{
    self = [super initWith:[APIDefine profile_unBlock_newLink] Params:[params encodeToJSON]];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    NSLog(@"%@", json);
    out_auth_register_verifycode * model;
    if (json) {
        model = [[out_auth_register_verifycode alloc] initWithJSON:json];
    }
    return (BaseJSON *)model;
}
@end
