//
//  API_Flower_GivePost.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/18/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Flower_GivePost.h"

@implementation API_Flower_GivePost

- (instancetype)initWithParams:(flower_give_post *)params{
    self = [super initWith:[APIDefine flower_give_postLink] Params:[params encodeToJSON]];
    self.numberFlower = params.num_flower;
    self.receiverID = params.receiver;
    self.postID = params.post_id;
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return  (BaseJSON *)[[out_flower_give alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[out_flower_give alloc] init];
}

@end
