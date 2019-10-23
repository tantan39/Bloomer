//
//  API_PostCreate.m
//  Bloomer
//
//  Created by Tran Thai Tan on 10/2/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_PostCreate.h"

@implementation API_PostCreate

- (instancetype)initWithParam:(post_create *)param{
    
    self = [super initWith:[APIDefine post_createLink] Params:[param encodeToJSON]];
    return self;
    
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    
    if (json) {
        return  (BaseJSON *)[[out_post_create alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[out_post_create alloc] init];
}

@end
