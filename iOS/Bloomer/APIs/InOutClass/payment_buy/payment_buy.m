//
//  payment_buy.m
//  Xinh
//
//  Created by Nguyen Thanh Tu on 12/17/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import "payment_buy.h"

@implementation payment_buy

-(id)initWithAccessToken:(NSString *)access_token device_token:(NSString*)device_token transactionIdentifier:(NSString*)transactionIdentifier transactionIdentifierStore:(NSString*)transactionIdentifierStore state:(NSString*)state productIdentifier:(NSString*)productIdentifier transactionDate:(NSString*)transactionDate receipt_data:(NSString*)receipt_data transactionFailBy:(NSString*)transactionFailBy
{
    self = [super init];
    if(self)
    {
        _access_token = access_token;
        _device_token = device_token;
        _state = state;
        _transactionIdentifierStore = transactionIdentifierStore;
        _transactionIdentifier = transactionIdentifier;
        _productIdentifier = productIdentifier;
        _transactionDate = transactionDate;
        _receipt = receipt_data;
        _transactionFailBy = transactionFailBy;
    }
    
    return self;
}

//-(NSString *)createStringJSON
//{
//    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//
//    NSDictionary *auth = [NSDictionary dictionaryWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token,k_DEVICE_TOKEN, nil];
//
//    NSMutableDictionary *transaction = [[NSMutableDictionary alloc] init];
//    [transaction setObject:_state forKey:k_STATE];
//    [transaction setObject:_productIdentifier forKey:k_PRODUCT_IDENTIFIER];
//    [transaction setObject:_transactionDate forKey:k_TRANSACTION_DATE];
//    [transaction setObject:_transactionIdentifier forKey:k_TRANSACTION_IDENTIFIER];
//    [transaction setObject:_receipt forKeyedSubscript:k_RECEIPT_DATA];
//    [transaction setObject:_transactionFailBy forKeyedSubscript:k_TRANSACTION_FAIL];
//    [transaction setObject:_transactionIdentifierStore forKey:k_TRANSACTION_IDENTIFIER_STORE];
//
//    [params setObject:auth forKey:k_AUTH];
//    [params setObject:transaction forKey:k_TRANSACTION];
//
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@", params);
//
//    return result;
//}

- (NSDictionary *)encodeToJSON{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    NSDictionary *auth = [NSDictionary dictionaryWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token,k_DEVICE_TOKEN, nil];
    
    NSMutableDictionary *transaction = [[NSMutableDictionary alloc] init];
    [transaction setObject:_state forKey:k_STATE];
    [transaction setObject:_productIdentifier forKey:k_PRODUCT_IDENTIFIER];
    [transaction setObject:_transactionDate forKey:k_TRANSACTION_DATE];
    [transaction setObject:_transactionIdentifier forKey:k_TRANSACTION_IDENTIFIER];
    [transaction setObject:_receipt forKeyedSubscript:k_RECEIPT_DATA];
    [transaction setObject:_transactionFailBy forKeyedSubscript:k_TRANSACTION_FAIL];
    [transaction setObject:_transactionIdentifierStore forKey:k_TRANSACTION_IDENTIFIER_STORE];
    
    [params setObject:auth forKey:k_AUTH];
    [params setObject:transaction forKey:k_TRANSACTION];
    
    return params;
}

@end
