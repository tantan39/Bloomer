//
//  out_countries_list.h
//  Bloomer
//
//  Created by Le Chau Tu on 12/6/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"
#import "Country.h"

@interface JSON_CountriesList : NSObject <BaseJSON>

@property (nonatomic, strong) NSMutableArray *countriesList;

@end
