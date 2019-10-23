//
//  race_fetches_by_me_using_scroll_down.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 6/29/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UsingAPIs.h"
#import "out_race_fetches.h"

@protocol race_fetches_ByMe_Scroll_Down_Delegate <NSObject>

- (void)getDataRace_fetches_ByMe_Scroll_Down:(out_race_fetches *) data;
- (void)Race_Fetches_ByMe_Scroll_Down_RequestFailed:(ASIHTTPRequest *)request;

@end


@interface race_fetches_byme_using_scroll_down : UsingAPIs <connectToServer>

@property (weak, nonatomic) id <race_fetches_ByMe_Scroll_Down_Delegate> myDelegate;

- (id)initWithAccessToken:(NSString *)access_token
             device_token:(NSString *)device_token
                race_name:(NSInteger)race_name
                    limit:(NSInteger)limit
                     flag:(NSInteger)flag
                  user_id:(NSInteger)user_id;

- (void)paramsToken:(NSString *)access_token
       device_token:(NSString *)device_token
          race_name:(NSInteger)race_name
              limit:(NSInteger)limit
               flag:(NSInteger)flag
            user_id:(NSInteger)user_id;

@end
