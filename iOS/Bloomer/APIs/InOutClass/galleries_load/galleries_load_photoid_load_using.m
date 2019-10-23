//
//  galleries_load_photoid_load_using.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 7/24/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "galleries_load_photoid_load_using.h"

@implementation galleries_load_photoid_load_using

-(id)init
{
    self = [self initWithURL:[APIDefine galleriesLoadLink] isChatServer:FALSE];
    
    if(self)
    {
        [conn connectOutputClass:[[out_photo_load_photoid alloc] init]];
        conn.myDelegate = self;
    }
    return self;
}

-(id)initWithAccessToken:(NSString *)access_token device_token:(NSString*)device_token userID:(NSString*)Uid
{
    self = [self initWithURL:[APIDefine galleriesLoadLink] isChatServer:FALSE];
    
    if(self)
    {
        GETQueryParamProtocol *get = [[GETQueryParamProtocol alloc] initWithURL:self->tringURL andParams:[[NSMutableArray alloc] initWithObjects:access_token, device_token, Uid, nil]];
        [conn connectWithFactory:get outputClass: [[out_photo_load_photoid alloc] init]];
        conn.myDelegate = self;
    }
    return self;
}

-(void)paramsToken:(NSString *)access_token device_token:(NSString*)device_token userID:(NSString*)Uid
{
    GETQueryParamProtocol *get = [[GETQueryParamProtocol alloc] initWithURL:self->tringURL andParams:[[NSMutableArray alloc] initWithObjects:access_token, device_token, Uid, nil]];
    [conn connectWithFactory:get];
}

-(void)processComplete:(jsonAbstractClass *)data
{
    out_photo_load_photoid *getData = (out_photo_load_photoid *)data;
    [self.myDelegate getDataGalleriesPhotoID_load:getData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:NSLocalizedString([error localizedDescription], nil)
                          message:NSLocalizedString([error localizedRecoverySuggestion], nil)
                          delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                          otherButtonTitles:nil];
    [alert show];
}


@end
