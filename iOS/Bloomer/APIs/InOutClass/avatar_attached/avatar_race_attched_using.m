//
//  avatar_race_attched_using.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/12/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "avatar_race_attched_using.h"

@implementation avatar_race_attched_using

-(id)init
{
    self = [super initWithURL:[APIDefine avatar_attachedLink] isChatServer:FALSE];
    
    if(self)
    {
        [conn connectOutputClass:[[out_avatar_attached alloc] init]];
        conn.myDelegate = self;
    }
    
    return self;
}

-(id)initWithAccessToken:(NSString*)access_token device_token:(NSString*)device_token image:(UIImage*)image key:(NSString *)key
{
    self = [super initWithURL:[APIDefine avatar_attachedLink] isChatServer:FALSE];
    
    if(self)
    {
        POSTImageProtocol *post = [[POSTImageProtocol alloc] initWithURL:self->tringURL image:image accessToken:access_token device_token:device_token type:nil];
        [conn connectWithFactory:post outputClass:[[out_avatar_attached alloc] init]];
        conn.myDelegate = self;
    }
    
    return self;
}

-(void)paramsToken:(NSString*)access_token device_token:(NSString*)device_token image:(UIImage*)image key:(NSString *)key
{
    POSTImageProtocol *post = [[POSTImageProtocol alloc] initWithURL:self->tringURL image:image accessToken:access_token device_token:device_token type:nil];
    [conn connectWithFactory:post];
}

-(void)processComplete:(jsonAbstractClass *)data
{
    out_avatar_attached *getData = (out_avatar_attached *)data;
    [self.myDelegate getDataAvatarRace_attached:getData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    [ASIHttpRequestErrorMessageManager displayErrorMessage:error];
    
    [self.myDelegate AvatarRace_Attached_RequestFailed:request];
}


@end
