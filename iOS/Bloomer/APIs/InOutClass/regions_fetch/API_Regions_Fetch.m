//
//  API_Regions_Fetch.m
//  Bloomer
//
//  Created by Tran Thai Tan on 10/11/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Regions_Fetch.h"

@implementation API_Regions_Fetch

- (instancetype)init{
    self = [super initWith:[APIDefine regions_fetchLink] Params:nil];
    return self;
    
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return (BaseJSON *) [[out_regions_fetch alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[out_regions_fetch alloc] init];
}
@end
