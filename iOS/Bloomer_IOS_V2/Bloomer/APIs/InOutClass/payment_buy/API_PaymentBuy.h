//
//  API_PaymentBuy.h
//  Bloomer
//
//  Created by Tran Thai Tan on 10/9/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "payment_buy.h"
#import "out_payment_buy.h"

@interface API_PaymentBuy : BloomerRestful
- (instancetype)initWithParam:(payment_buy *)param;
@end
