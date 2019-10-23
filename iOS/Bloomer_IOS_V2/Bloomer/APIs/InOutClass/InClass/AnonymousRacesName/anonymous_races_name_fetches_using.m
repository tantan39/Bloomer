//
//  anonymous_races_name_fetches_using.m
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 5/2/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "anonymous_races_name_fetches_using.h"

@implementation anonymous_races_name_fetches_using

-(id)init
{
    self = [self initWithURL:[APIDefine anonymous_race_name_fetchesLink] isChatServer:FALSE];
    
    if(self)
    {
        [conn connectOutputClass:[[out_races_name_fetches alloc] init]];
        conn.myDelegate = self;
    }
    return self;
}

-(id)initWithkey:(NSString *)key gender:(NSInteger)gender
{
    self = [self initWithURL:[APIDefine anonymous_race_name_fetchesLink] isChatServer:FALSE];
    
    if(self)
    {
        GETQueryParamProtocol *get = [[GETQueryParamProtocol alloc] initWithURL:self->tringURL andParams:[[NSMutableArray alloc] initWithObjects: key, @(gender).stringValue, nil]];
        [conn connectWithFactory:get outputClass: [[out_races_name_fetches alloc] init]];
        conn.myDelegate = self;
    }
    return self;
}

-(void)processComplete:(jsonAbstractClass *)data
{
    out_races_name_fetches *getData = (out_races_name_fetches *)data;
    [self.myDelegate getDataRacesName_fetches:getData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    [ASIHttpRequestErrorMessageManager displayErrorMessage:error];
    
    [self.myDelegate Races_Name_Fetches_RequestFailed:request];
}

@end
