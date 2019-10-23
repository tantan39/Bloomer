//
//  out_countries_list.m
//  Bloomer
//
//  Created by Le Chau Tu on 12/6/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "JSON_CountriesList.h"

@implementation JSON_CountriesList

-(instancetype)initWithJSON:(NSDictionary *)json {
    self = [super init];
    if (self) {
        self.countriesList = [[NSMutableArray alloc] init];
        NSArray *list = [json objectForKey:@"countries"];
        for (int i = 0; i < list.count; i++) {
            NSDictionary *dict = [list objectAtIndex:i];
            Country *country = [[Country alloc] initWithCode:[dict objectForKey:@"country_code"]
                                                 countryName:[dict objectForKey:@"country_name"]
                                            countryShortName:[dict objectForKey:@"country_short_name"]
                                                 countryFlag:[dict objectForKey:@"country_flag"]
                                                   countryID:[[dict objectForKey:@"id"] integerValue]];
            [self.countriesList addObject:country];
        }
    }
    return self;
}

@end
