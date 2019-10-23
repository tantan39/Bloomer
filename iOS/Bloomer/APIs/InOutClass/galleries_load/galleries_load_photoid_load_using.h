//
//  galleries_load_photoid_load_using.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 7/24/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "UsingAPIs.h"
#import "out_photo_load_photoid.h"

@protocol galleries_load_photoidDelegate <NSObject>

-(void)getDataGalleriesPhotoID_load:(out_photo_load_photoid *) data;

@end

@interface galleries_load_photoid_load_using : UsingAPIs<connectToServer>

@property (weak, nonatomic) id<galleries_load_photoidDelegate> myDelegate;

-(id)initWithAccessToken:(NSString *)access_token device_token:(NSString*)device_token userID:(NSString*)Uid;

-(void)paramsToken:(NSString *)access_token device_token:(NSString*)device_token userID:(NSString*)Uid;

@end