//
//  API_Flower_Give.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/18/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Flower_Give.h"

@implementation API_Flower_Give

- (instancetype)initWithParams:(flower_give *)params{
    self = [super initWith:[APIDefine flower_giveLink] Params:[params encodeToJSON]];
    return self;
    
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return  (BaseJSON *)[[out_flower_give alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[out_flower_give alloc] init];
}

@end
