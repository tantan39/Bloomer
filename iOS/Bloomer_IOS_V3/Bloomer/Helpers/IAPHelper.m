//
//  IAPHelper.m
//  Bloomer
//
//  Created by Le Chau Tu on 7/28/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "IAPHelper.h"
#import "UserDefaultManager.h"
#import "AppDelegate.h"
#import "out_payment_buy.h"
@interface IAPHelper () {
    UserDefaultManager *userDefaultManager;
}

@end

@implementation IAPHelper

+ (IAPHelper *)sharedInstance
{
    static dispatch_once_t onceToken;
    static IAPHelper * storeObserverSharedInstance;
    
    dispatch_once(&onceToken, ^{
        storeObserverSharedInstance = [[IAPHelper alloc] init];
    });
    return storeObserverSharedInstance;
}

-(id)init {
    self = [super init];
    if(self) {
        userDefaultManager = [[UserDefaultManager alloc] init];
    }
    return self;
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {

    NSString *state = @"";
    NSString *transStoreId = @"";
    NSString *errorReason = @"";
    NSString *receiptData = @"";
    
    for (SKPaymentTransaction *transaction in transactions) {
        switch(transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing:{
                NSLog(@"->SKPaymentTransactionStatePurchasing");
                state = @"purchasing_start";
                break;
            }
                
                
            case SKPaymentTransactionStatePurchased:{
                NSLog(@"->SKPaymentTransactionStatePurchased");
                state = @"purchased_success";
                transStoreId = transaction.transactionIdentifier;
                NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
                NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
                receiptData = [receipt base64EncodedStringWithOptions:0];
                [self handleTransactionPurchased:transaction ReceiptData:receiptData TransactionID:[userDefaultManager getTransactionID]];
                
                break;
            }
                
            case SKPaymentTransactionStateFailed:{
                NSLog(@"->SKPaymentTransactionStateFailed %@",transaction.error.description);
                state = @"purchased_failed";
                errorReason = @"";
                transStoreId = transaction.transactionIdentifier;
                
                switch (transaction.error.code) {
                    case SKErrorPaymentCancelled:
                        errorReason = @"Cancelled";
                        break;
                    case SKErrorPaymentInvalid:
                        errorReason = @"Invalid";
                        break;
                    case SKErrorPaymentNotAllowed:
                        errorReason = @"Not allowed";
                        break;
                    default:
                        errorReason = [[NSString alloc] initWithFormat:@"Error %ld", transaction.error.code];
                        break;
                }
                [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
                [AppHelper showMessageBox:[AppHelper getLocalizedString:@"FlowerShop.purchaseFailed"] message:[transaction.error localizedDescription]];
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                break;
            }
                
            default:
                break;

        }
        NSString * currentTime = [NSDate currentTimeString];
        
        NSString * transactionID = [userDefaultManager getTransactionID];
        
        [userDefaultManager saveProductID:transaction.payment.productIdentifier];
        [userDefaultManager saveTransactionDate:currentTime];
        [userDefaultManager saveState:state];
        [userDefaultManager saveReceipt:receiptData];
        [userDefaultManager saveTransactionStoreID:transStoreId];
        
        if(transaction.transactionState == SKPaymentTransactionStatePurchasing) {
            continue;
        }
        
        payment_buy *param = [[payment_buy alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                          device_token:[userDefaultManager getDeviceToken]
                                                 transactionIdentifier:transactionID
                                            transactionIdentifierStore:transStoreId
                                                                 state:state
                                                     productIdentifier:transaction.payment.productIdentifier
                                                       transactionDate:currentTime
                                                          receipt_data:receiptData
                                                     transactionFailBy:errorReason];
        if (![transactionID isEqualToString:@""]) {
            [self verifyTransaction:transaction Param:param];
        }else{
            [self generateTransactionID:transaction Data:param Error:errorReason];
        }
    }
}


-(void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    NSLog(@"->removedTransactions");
}

- (void) verifyTransaction:(SKPaymentTransaction *) transaction Param:(payment_buy *) param {
    if (param) {
        API_PaymentBuy *paymentAPI = [[API_PaymentBuy alloc] initWithParam:param];
        [paymentAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            out_payment_buy * data = (out_payment_buy *)jsonObject;
            if (response.status)
            {
                if ([data.state isEqualToString:@"purchasing_start"]) {
                    [userDefaultManager saveTransactionID:data.transactionIdentifier];
                } else {
                    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
                    [userDefaultManager saveReceipt:@""];
                    [userDefaultManager saveState:@""];
                    [userDefaultManager saveTransactionID:@""];
                    
                    if ([data.state isEqualToString:@"purchased_success"]) {
                        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                        [self removeTransactionOnLocal:transaction];
                        out_profile_fetch *profileData = [userDefaultManager getUserProfileData];
                        profileData.your_num_flower = data.num_flower;
                        [userDefaultManager saveUserProfileData:profileData];
                        if (self.paymentSuccess_callback) {
                            self.paymentSuccess_callback();
                        }
                        
                    }
                }
            }else{
                [AppHelper showMessageBox:nil message:response.message];
                [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
            }
        } ErrorHandlure:^(NSError *error) {
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        }];
    }
}

- (void) generateTransactionID:(SKPaymentTransaction *) transaction Data:(payment_buy *) package Error:(NSString *) error{
    
    payment_buy *param = [[payment_buy alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                     device_token:[userDefaultManager getDeviceToken]
                                            transactionIdentifier:@""
                                       transactionIdentifierStore:@""
                                                            state:@"purchasing_start"
                                                productIdentifier:transaction.payment.productIdentifier
                                                  transactionDate:[NSDate currentTimeString]
                                                     receipt_data:@""
                                                transactionFailBy:@""];
    if (param) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
        API_PaymentBuy *paymentAPI = [[API_PaymentBuy alloc] initWithParam:param];
        [paymentAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            out_payment_buy * obj = (out_payment_buy *)jsonObject;
            if (response.status)
            {
                if ([obj.state isEqualToString:@"purchasing_start"]) {
                    [userDefaultManager saveTransactionID:obj.transactionIdentifier];
                    
                    payment_buy *data = [[payment_buy alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                                     device_token:[userDefaultManager getDeviceToken]
                                                            transactionIdentifier:obj.transactionIdentifier
                                                       transactionIdentifierStore:transaction.transactionIdentifier
                                                                            state:package.state
                                                                productIdentifier:transaction.payment.productIdentifier
                                                                  transactionDate:[NSDate currentTimeString]
                                                                     receipt_data:package.receipt
                                                                transactionFailBy:error];
                    
                    [self verifyTransaction:transaction Param:data];
                }
            }
            else
            {
                [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
                [AppHelper showMessageBox:nil message:response.message];
            }
        } ErrorHandlure:^(NSError *error) {
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        }];
    }
}

// Store transaction on local
- (void) handleTransactionPurchased:(SKPaymentTransaction *) transaction ReceiptData:(NSString *) receipt TransactionID:(NSString *) transID{
    if (transaction) {
        IAPTransaction * trans = [[IAPTransaction alloc] initWithTransaction:transaction ReceiptData:receipt TransactionID:transID];
        NSMutableArray * listTrans = [[BloomerManager shareInstance] listIAPTransaction] ? [[BloomerManager shareInstance] listIAPTransaction] : [[NSMutableArray alloc] init];
        if (listTrans) {
            [listTrans addObject:trans];
            [[BloomerManager shareInstance] setListIAPTransaction:listTrans];
        }
        
    }
}

// Remove transaction on local
- (void) removeTransactionOnLocal:(SKPaymentTransaction *) transaction{
    NSMutableArray * listTrans = [[BloomerManager shareInstance] listIAPTransaction];
    if (listTrans && listTrans.count > 0) {

        [listTrans enumerateObjectsUsingBlock:^(IAPTransaction *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.skPaymentTransaction.transactionIdentifier isEqualToString:transaction.transactionIdentifier]) {

                [listTrans removeObject:obj];
                [[BloomerManager shareInstance] setListIAPTransaction:listTrans];
                *stop = YES;
            }
        }];

    }
}

@end
