//
//  avatar_race_attched_using.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/12/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UsingAPIs.h"
#import "out_avatar_attached.h"
#import "POSTImageProtocol.h"

@protocol avatarRace_attachedDelegate <NSObject>

- (void)getDataAvatarRace_attached:(out_avatar_attached *) data;
- (void)AvatarRace_Attached_RequestFailed:(ASIHTTPRequest *)request;

@end

@interface avatar_race_attched_using : UsingAPIs<connectToServer>

@property (weak, nonatomic) id<avatarRace_attachedDelegate> myDelegate;


-(id)initWithAccessToken:(NSString*)access_token device_token:(NSString*)device_token image:(UIImage*)image key:(NSString *)key;

-(void)paramsToken:(NSString*)access_token device_token:(NSString*)device_token image:(UIImage*)image key:(NSString *)key;


@end
