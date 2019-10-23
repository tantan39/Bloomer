//
//  post_user_fetches_using.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/4/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UsingAPIs.h"
#import "out_post_user_fetches.h"

@protocol postUser_fetchesDelegate <NSObject>

-(void)getDataPostUser_fetches:(out_post_user_fetches *) data userID:(NSInteger)userID;
-(void)PostUser_Fetches_RequestFailed:(ASIHTTPRequest *)request;

@end

@interface post_user_fetches_using : UsingAPIs<connectToServer>
@property (assign, nonatomic) NSInteger userID;
@property (weak, nonatomic) id <postUser_fetchesDelegate> myDelegate;

-(id)initWithAccessToken:(NSString *)access_token
            device_token:(NSString *)device_token
                  postID:(NSString *)post_id
                     uid:(NSInteger)uid
                   limit:(NSInteger)limit;
-(id)initWithAccessToken:(NSString *)access_token
            device_token:(NSString *)device_token
                  postID:(NSString *)post_id
                     uid:(NSInteger)uid;
@end
