//
//  city.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 3/22/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "city.h"

@implementation city

//- (void)extractData:(NSDictionary *)data
//{
//    _city_id = [[data objectForKey:k_CITY_ID] integerValue];
//    _city_short_name = [data objectForKey:k_CITY_SHORT_NAME];
//    _city_name = NSLocalizedString(_city_short_name, nil);
//}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        _city_id = [[json objectForKey:k_CITY_ID] integerValue];
        _city_short_name = [json objectForKey:k_CITY_SHORT_NAME];
        _city_name = [json objectForKey:k_CITY_NAME];
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeInteger:self.city_id forKey:k_CITY_ID];
    [encoder encodeObject:self.city_name forKey:k_CITY_NAME];
    [encoder encodeObject:self.city_short_name forKey:k_CITY_SHORT_NAME];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.city_id = [decoder decodeIntegerForKey:k_CITY_ID];
        self.city_name = [decoder decodeObjectForKey:k_CITY_NAME];
        self.city_short_name = [decoder decodeObjectForKey:k_CITY_SHORT_NAME];
    }
    return self;
}


@end
