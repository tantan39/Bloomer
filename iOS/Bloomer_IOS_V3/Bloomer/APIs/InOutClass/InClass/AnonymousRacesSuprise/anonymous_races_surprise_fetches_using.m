//
//  anonymous_races_surprise_fetches_using.m
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 5/3/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "anonymous_races_surprise_fetches_using.h"

@implementation anonymous_races_surprise_fetches_using

-(id)init
{
    self = [self initWithURL:[APIDefine races_surprise_fetechesLink] isChatServer:FALSE];
    
    if(self)
    {
        [conn connectOutputClass:[[out_races_fetches alloc] init]];
        conn.myDelegate = self;
    }
    return self;
}

-(id)initWithKey:(NSString *)key ckey:(NSString *)ckey gender:(NSInteger)gender
{
    self = [self initWithURL:[APIDefine races_surprise_fetechesLink] isChatServer:FALSE];
    
    if(self)
    {
        GETQueryParamProtocol *get = [[GETQueryParamProtocol alloc] initWithURL:self->tringURL andParams:[[NSMutableArray alloc] initWithObjects: key, ckey, @(gender).stringValue, nil]];
        [conn connectWithFactory:get outputClass: [[out_races_fetches alloc] init]];
        conn.myDelegate = self;
    }
    return self;
}

-(void)processComplete:(jsonAbstractClass *)data
{
    out_races_fetches *getData = (out_races_fetches *)data;
    [self.myDelegate getDataRacesSurprise_fetches:getData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    [ASIHttpRequestErrorMessageManager displayErrorMessage:error];
    
    [self.myDelegate RacesSurprise_Fetches_RequestFailed:request];
}


@end
