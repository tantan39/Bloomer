//
//  API_Transaction_Check.h
//  Bloomer
//
//  Created by Tran Thai Tan on 10/10/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "transaction_check.h"
#import "out_transaction_check.h"
@interface API_Transaction_Check : BloomerRestful

- (instancetype)initWithParam:(transaction_check *) param;

@end
