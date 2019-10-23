//
//  API_Flower_Give.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/18/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Flower_GiveProfile.h"

@implementation API_Flower_GiveProfile

- (instancetype)initWithParams:(flower_give_profile *)params{
    self = [super initWith:[APIDefine flower_give_profileLink] Params:[params encodeToJSON]];
    self.receiverID = params.receiver;
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return  (BaseJSON *)[[out_flower_give alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[out_flower_give alloc] init];
}

@end
