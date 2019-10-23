//
//  API_Transaction_Check.m
//  Bloomer
//
//  Created by Tran Thai Tan on 10/10/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Transaction_Check.h"

@implementation API_Transaction_Check

- (instancetype)initWithParam:(transaction_check *)param{
    
    self = [super initWith:[APIDefine transaction_checkLink] Params:[param encodeToJSON]];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return (BaseJSON *)[[out_transaction_check alloc] initWithJSON:json];
    }
    return (BaseJSON *)[[out_transaction_check alloc] init];
}

@end
