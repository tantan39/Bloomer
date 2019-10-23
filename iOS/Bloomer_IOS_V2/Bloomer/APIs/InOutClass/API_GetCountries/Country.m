//
//  Country.m
//  Bloomer
//
//  Created by Le Chau Tu on 12/6/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "Country.h"

@implementation Country

-(id)initWithCode:(NSString *)countryCode countryName:(NSString *)countryName countryShortName:(NSString *)countryShortName countryFlag:(NSString *)countryFlag countryID:(NSInteger)countryID {
    self = [super init];
    if (self) {
        _countryCode = countryCode;
        _countryName = countryName;
        _countryShortName = countryShortName;
        _countryFlag = countryFlag;
        _countryID = countryID;
    }
    return self;
}

@end
