//
//  covers_load_using.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 5/18/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "covers_load_using.h"

@implementation covers_load_using

-(id)init
{
    self = [self initWithURL:[APIDefine covers_loadLink] isChatServer:FALSE];
    
    if(self)
    {
        [conn connectOutputClass:[[out_covers_load alloc] init]];
        conn.myDelegate = self;
    }
    return self;
}

-(id)initWithAccessToken:(NSString *)access_token device_token:(NSString*)device_token user_id:(NSInteger)user_id
{
    self = [self initWithURL:[APIDefine covers_loadLink] isChatServer:FALSE];
    
    if(self)
    {
        GETQueryParamProtocol *get = [[GETQueryParamProtocol alloc] initWithURL:self->tringURL andParams:[[NSMutableArray alloc] initWithObjects:access_token, device_token, @(user_id).stringValue, nil]];
        [conn connectWithFactory:get outputClass: [[out_covers_load alloc] init]];
        conn.myDelegate = self;
    }
    return self;
}

-(void)paramsToken:(NSString *)access_token device_token:(NSString*)device_token user_id:(NSInteger)user_id
{
    GETQueryParamProtocol *get = [[GETQueryParamProtocol alloc] initWithURL:self->tringURL andParams:[[NSMutableArray alloc] initWithObjects:access_token, device_token, @(user_id).stringValue, nil]];
    [conn connectWithFactory:get];
}

-(void)processComplete:(jsonAbstractClass *)data
{
    out_covers_load *getData = (out_covers_load *)data;
    [self.myDelegate getDataCovers_Load:getData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    [ASIHttpRequestErrorMessageManager displayErrorMessage:error];
}


@end
