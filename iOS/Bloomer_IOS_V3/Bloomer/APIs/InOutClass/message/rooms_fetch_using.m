//
//  rooms_fetch_using.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/6/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "rooms_fetch_using.h"

@implementation rooms_fetch_using

-(id)init
{
    self = [self initWithURL:[APIDefine rooms_fetchLink] isChatServer:FALSE];
    
    if(self)
    {
        [conn connectOutputClass:[[out_rooms_fetch alloc] init]];
        conn.myDelegate = self;
    }
    return self;
}

-(id)initWithAccessToken:(NSString *)access_token device_token:(NSString*)device_token
{
    self = [self initWithURL:[APIDefine rooms_fetchLink] isChatServer:FALSE];
    
    if(self)
    {
        GETQueryParamProtocol *get = [[GETQueryParamProtocol alloc] initWithURL:self->tringURL andParams:[[NSMutableArray alloc] initWithObjects:access_token, device_token, nil]];
        [conn connectWithFactory:get outputClass: [[out_rooms_fetch alloc] init]];
        conn.myDelegate = self;
    }
    return self;
}

-(void)paramsToken:(NSString *)access_token device_token:(NSString*)device_token
{
    GETQueryParamProtocol *get = [[GETQueryParamProtocol alloc] initWithURL:self->tringURL andParams:[[NSMutableArray alloc] initWithObjects:access_token, device_token, nil]];
    [conn connectWithFactory:get];
}

-(void)processComplete:(jsonAbstractClass *)data
{
    out_rooms_fetch *getData = (out_rooms_fetch *)data;
    [self.myDelegate getDataRooms_fetch:getData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    [ASIHttpRequestErrorMessageManager displayErrorMessage:error];
}

@end
