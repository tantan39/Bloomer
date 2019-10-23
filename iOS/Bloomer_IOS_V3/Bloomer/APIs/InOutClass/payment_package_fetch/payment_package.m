//
//  payment_package.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 8/10/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "payment_package.h"

@implementation payment_package

//-(void)extractData:(NSDictionary*) data
//{
//    _productIdentifier = [data objectForKey:k_PRODUCT_IDENTIFIER];
//    _productDescription = [data objectForKey:k_PRODUCT_DESC];
////    _productDesc = [data objectForKey:k_PRODUCT_DESC];
//    _money = [[data objectForKey:k_MONEY] floatValue];
//    _payment_id = [[data objectForKey:k_PAYMENT_ID] integerValue];
//    _flower = [[data objectForKey:k_FLOWER] integerValue];
//
//}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        _productIdentifier = [json objectForKey:k_PRODUCT_IDENTIFIER];
        _productDescription = [json objectForKey:k_PRODUCT_DESC];
        //    _productDesc = [data objectForKey:k_PRODUCT_DESC];
        _money = [[json objectForKey:k_MONEY] floatValue];
        _payment_id = [[json objectForKey:k_PAYMENT_ID] integerValue];
        _flower = [[json objectForKey:k_FLOWER] integerValue];
        _currency = [json objectForKey:@"currency"];
        _isShot = [[json objectForKey:@"event_ishot"] boolValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_productIdentifier forKey:k_PRODUCT_IDENTIFIER];
    [encoder encodeObject:_productDescription forKey:k_PRODUCT_DESC];
//    [encoder encodeObject:_productDesc forKey:k_PRODUCT_DESC];
    [encoder encodeFloat:_money forKey:k_MONEY];
    [encoder encodeInteger:_payment_id forKey:k_PAYMENT_ID];
    [encoder encodeInteger:_flower forKey:k_FLOWER];
    [encoder encodeObject:_currency forKey:@"currency"];
    [encoder encodeBool:_isShot forKey:@"event_ishot"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        _productIdentifier = [decoder decodeObjectForKey:k_PRODUCT_IDENTIFIER];
        _productDescription = [decoder decodeObjectForKey:k_PRODUCT_DESC];
//        _productDesc = [decoder decodeObjectForKey:k_PRODUCT_DESC];
        _money = [decoder decodeFloatForKey:k_MONEY];
        _payment_id = [decoder decodeIntegerForKey:k_PAYMENT_ID];
        _flower = [decoder decodeIntegerForKey:k_FLOWER];
        _currency = [decoder decodeObjectForKey:@"currency"];
        _isShot = [decoder decodeBoolForKey:@"event_ishot"];
    }
    return self;
}

@end
