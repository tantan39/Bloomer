//
//  anonymous_discovery_load.m
//  Bloomer
//
//  Created by Le Chau Tu on 5/4/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "anonymous_discovery_load.h"

@implementation anonymous_discovery_load

- (id)init {
    self = [self initWithURL:[APIDefine anonymous_discovery_fetchesLink] isChatServer:FALSE];
    
    if (self) {
//        [conn connectOutputClass:[[out_discovery_fetches alloc] init]];
        conn.myDelegate = self;
    }
    
    return self;
}

- (id)initWithGender:(NSInteger)gender city:(NSString *)city is_refresh:(BOOL)is_refresh uid:(NSInteger)uid {
    self = [self initWithURL:[APIDefine anonymous_discovery_fetchesLink] isChatServer:FALSE];
    
    if (self) {
        GETQueryParamProtocol *get = [[GETQueryParamProtocol alloc] initWithURL:self->tringURL andParams:[[NSMutableArray alloc] initWithObjects:@(gender).stringValue, city, is_refresh?@"true":@"false", @(uid).stringValue, nil]];
//        [conn connectWithFactory:get outputClass:[[out_discovery_fetches alloc] init]];
        conn.myDelegate = self;
        
    }
    
    return self;
}

- (void)processComplete:(jsonAbstractClass *)data {
//    out_discovery_fetches *getData = (out_discovery_fetches *)data;
//    self.completion(getData);
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    [ASIHttpRequestErrorMessageManager displayErrorMessage:error];
    self.failure(request);
}

@end
