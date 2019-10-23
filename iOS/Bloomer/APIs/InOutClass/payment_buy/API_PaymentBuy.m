//
//  API_PaymentBuy.m
//  Bloomer
//
//  Created by Tran Thai Tan on 10/9/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_PaymentBuy.h"

@implementation API_PaymentBuy
- (instancetype)initWithParam:(payment_buy *)param{
    
    self = [super initWith:[APIDefine payment_buyLink] Params:[param encodeToJSON]];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return (BaseJSON *)[[out_payment_buy alloc] initWithJSON:json];
    }
    return (BaseJSON *)[[out_payment_buy alloc] init];
}
@end
