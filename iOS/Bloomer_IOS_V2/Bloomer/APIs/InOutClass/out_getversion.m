//
//  out_getversion.m
//  Bloomer
//
//  Created by Le Chau Tu on 3/13/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "out_getversion.h"

@implementation out_getversion

-(void)extractData:(NSDictionary*)data {
    _version = [data objectForKey:@"version"];
}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        
        _version = [json objectForKey:k_VERSION];
        
    }
    return self;

}

@end
