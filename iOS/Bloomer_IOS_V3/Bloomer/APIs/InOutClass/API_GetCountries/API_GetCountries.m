//
//  API_GetCountries.m
//  Bloomer
//
//  Created by Le Chau Tu on 12/6/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_GetCountries.h"

@implementation API_GetCountries

-(instancetype)init {
    self = [super initWith:[APIDefine getCountriesLink] Params:nil];
    return self;
}

-(BaseJSON *)handleJSON:(NSDictionary *)json {
    JSON_CountriesList *model;
    if (json) {
        model = [[JSON_CountriesList alloc] initWithJSON:json];
    }
    return (BaseJSON *)model;
}

@end
