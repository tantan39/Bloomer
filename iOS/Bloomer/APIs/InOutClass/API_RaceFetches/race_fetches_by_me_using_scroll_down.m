//
//  race_fetches_by_me_using_scroll_down.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 6/29/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "race_fetches_by_me_using_scroll_down.h"

@implementation race_fetches_byme_using_scroll_down

- (id)init {
    self = [self initWithURL:[APIDefine race_fetches_bymeScroll] isChatServer:FALSE];
    
    if (self) {
        [conn connectOutputClass:[[out_race_fetches alloc] init]];
        conn.myDelegate = self;
    }
    return self;
}


#pragma .......
- (id)initWithAccessToken:(NSString *)access_token
             device_token:(NSString *)device_token
                race_name:(NSInteger)race_name
                    limit:(NSInteger)limit
                     flag:(NSInteger)flag
                  user_id:(NSInteger)user_id {
    self = [self initWithURL:[APIDefine race_fetches_bymeScroll] isChatServer:FALSE];
    
    if (self) {
        GETQueryParamProtocol *get = [[GETQueryParamProtocol alloc]initWithURL:self->tringURL andParams:[[NSMutableArray alloc] initWithObjects:access_token, device_token, @(race_name).stringValue, @(limit).stringValue, @(flag).stringValue, @(user_id).stringValue, nil]];
        [conn connectWithFactory:get outputClass:[[out_race_fetches alloc] init]];
        conn.myDelegate = self;
    }
    
    return self;
}

- (void)paramsToken:(NSString *)access_token
       device_token:(NSString *)device_token
          race_name:(NSInteger)race_name
              limit:(NSInteger)limit
               flag:(NSInteger)flag
            user_id:(NSInteger)user_id {
    GETQueryParamProtocol *get = [[GETQueryParamProtocol alloc] initWithURL:self->tringURL andParams:[[NSMutableArray alloc] initWithObjects:access_token, device_token, @(race_name).stringValue, @(limit).stringValue, @(flag).stringValue, @(user_id).stringValue, nil]];
    [conn connectWithFactory:get];
}


#pragma Delegate
- (void)processComplete:(jsonAbstractClass *)data {
    out_race_fetches *getData = (out_race_fetches *)data;
    [self.myDelegate getDataRace_fetches_ByMe_Scroll_Down:getData];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    [ASIHttpRequestErrorMessageManager displayErrorMessage:error];
    
    [self.myDelegate Race_Fetches_ByMe_Scroll_Down_RequestFailed:request];
}

@end
