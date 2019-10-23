//
//  post_user_fetches_using.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/4/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "post_user_fetches_using.h"

#define DEFAULT_LIMIT 4
@implementation post_user_fetches_using

-(id)init
{
    self = [self initWithURL:[APIDefine post_user_fetchesLink] isChatServer:FALSE];
    
    if(self)
    {
        [conn connectOutputClass:[[out_post_user_fetches alloc] init]];
        conn.myDelegate = self;
    }
    return self;
}

-(id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token postID:(NSString *)post_id uid:(NSInteger)uid {
    self = [self initWithURL:[APIDefine post_user_fetchesLink] isChatServer:FALSE];
    
    if(self)
    {
        GETQueryParamProtocol *get = [[GETQueryParamProtocol alloc] initWithURL:self->tringURL andParams:[[NSMutableArray alloc] initWithObjects:access_token, device_token, post_id, @(uid).stringValue,@(DEFAULT_LIMIT).stringValue, nil]];
        [conn connectWithFactory:get outputClass: [[out_post_user_fetches alloc] init]];
        conn.myDelegate = self;
        self.userID = uid;
    }
    return self;
}

-(id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token postID:(NSString *)post_id uid:(NSInteger)uid limit:(NSInteger)limit{
    self = [self initWithURL:[APIDefine post_user_fetchesLink] isChatServer:FALSE];
    
    if(self)
    {
        GETQueryParamProtocol *get = [[GETQueryParamProtocol alloc] initWithURL:self->tringURL andParams:[[NSMutableArray alloc] initWithObjects:access_token, device_token, post_id, @(uid).stringValue,@(limit).stringValue, nil]];
        [conn connectWithFactory:get outputClass: [[out_post_user_fetches alloc] init]];
        conn.myDelegate = self;
        self.userID = uid;
    }
    return self;
}

-(void)processComplete:(jsonAbstractClass *)data
{
    out_post_user_fetches *getData = (out_post_user_fetches *)data;
    [self.myDelegate getDataPostUser_fetches:getData userID:self.userID];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    [ASIHttpRequestErrorMessageManager displayErrorMessage:error];
    
    [self.myDelegate PostUser_Fetches_RequestFailed:request];
}


@end
