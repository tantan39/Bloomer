//
//  IAPTransaction.m
//  Bloomer
//
//  Created by Tan Tan on 8/17/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "IAPTransaction.h"

@implementation IAPTransaction

- (instancetype)initWithTransaction:(SKPaymentTransaction *)trans ReceiptData:(NSString *)receipt TransactionID:(NSString *)transID{
    self = [super init];
    if (self) {
        self.skPaymentTransaction = trans;
        self.receiptData = receipt;
        self.transactionID = transID;
    }
    return self;
}

@end
