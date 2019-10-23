//
//  anonymous_discovery_search.m
//  Bloomer
//
//  Created by Le Chau Tu on 5/4/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "anonymous_discovery_search.h"

@implementation anonymous_discovery_search

-(id)initWithTerm:(NSString *)term size:(NSInteger)size page:(NSInteger)page {
    self = [self initWithURL:[APIDefine anonymous_discovery_searchLink] isChatServer:FALSE];
    
    if (self) {
        GETQueryParamProtocol *get = [[GETQueryParamProtocol alloc] initWithURL:self->tringURL andParams:[[NSMutableArray alloc] initWithObjects:term, @(page).stringValue, @"0", nil]];
        [conn connectWithFactory:get outputClass: [[out_discovery_search alloc] init]];
        conn.myDelegate = self;
    }
    return self;
}

- (void)processComplete:(jsonAbstractClass *)data
{
    out_discovery_search *getData = (out_discovery_search *)data;
    self.completion(getData);
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    self.failure(request);
}

@end
