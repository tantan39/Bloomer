//
//  covers_load_using.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 5/18/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "UsingAPIs.h"
#import "out_covers_load.h"

@protocol covers_loadDelegate <NSObject>

-(void)getDataCovers_Load:(out_covers_load *) data;

@end

@interface covers_load_using : UsingAPIs<connectToServer>

@property (weak, nonatomic) id<covers_loadDelegate> myDelegate;

-(id)initWithAccessToken:(NSString *)access_token device_token:(NSString*)device_token user_id:(NSInteger)user_id;
-(void)paramsToken:(NSString *)access_token device_token:(NSString*)device_token user_id:(NSInteger)user_id;

@end
