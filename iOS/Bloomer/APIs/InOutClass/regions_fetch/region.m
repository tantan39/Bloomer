//
//  region.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 7/24/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "region.h"

@implementation region

//-(void)extractData:(NSDictionary*) data
//{
//    _country_code = [data objectForKey:k_CODE];
//    _country_name = [data objectForKey:@"country_name"];
//    _short_name = [data objectForKey:@"short_name"];
//}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        _country_code = [json objectForKey:k_CODE];
        _country_name = [json objectForKey:@"country_name"];
        _short_name = [json objectForKey:@"short_name"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_country_code forKey:k_CODE];
    [encoder encodeObject:_country_name forKey:@"country_name"];
    [encoder encodeObject:_short_name forKey:@"short_name"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        _country_code = [decoder decodeObjectForKey:k_CODE];
        _country_name = [decoder decodeObjectForKey:@"country_name"];
        _short_name = [decoder decodeObjectForKey:@"short_name"];
    }
    return self;
}

@end
