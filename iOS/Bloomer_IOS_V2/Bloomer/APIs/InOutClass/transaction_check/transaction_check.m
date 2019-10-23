//
//  transaction_check.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 8/11/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "transaction_check.h"

@implementation transaction_check

- (id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token transactionIdentifier:(NSString *)transactionIdentifier {
    self = [super init];
    
    if(self)
    {
        _access_token = access_token;
        _device_token = device_token;
        _transactionIdentifier = transactionIdentifier;
    }
    
    return self;
}

- (NSDictionary *)encodeToJSON{
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token, k_DEVICE_TOKEN, _transactionIdentifier, k_TRANSACTION_IDENTIFIER, nil];

    return info;
}

//-(NSString *) createStringJSON
//{
//    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token, k_DEVICE_TOKEN, _transactionIdentifier, k_TRANSACTION_IDENTIFIER, nil];
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    return result;
//}

@end
