//
//  rooms_fetch_using.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/6/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UsingAPIs.h"
#import "out_rooms_fetch.h"

@protocol rooms_fetchDelegate <NSObject>

-(void)getDataRooms_fetch:(out_rooms_fetch *) data;

@end

@interface rooms_fetch_using : UsingAPIs<connectToServer>

@property (strong, nonatomic) id<rooms_fetchDelegate> myDelegate;

-(id)initWithAccessToken:(NSString *)access_token device_token:(NSString*)device_token;

-(void)paramsToken:(NSString *)access_token device_token:(NSString*)device_token;

@end

