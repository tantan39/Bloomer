//
//  Auth_FBRegisterParams.h
//  Bloomer
//
//  Created by Le Chau Tu on 11/28/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"
#import "APIDefine.h"
#import "Support.h"
@interface Auth_FBRegisterParams : NSObject<BaseJSON>

@property (nonatomic, strong) NSString* photo_id;
@property (nonatomic, assign) NSInteger countryID;
@property (nonatomic, strong) NSString* fb_id;
@property (nonatomic, assign) NSInteger fb_gender;
@property (nonatomic, strong) NSString* fb_name;
@property (nonatomic, strong) NSString* fb_urlPicture;
@property (nonatomic, assign) BOOL fb_is_silhouette;
@property (nonatomic, strong) NSString* secret_client;
@property (nonatomic, strong) NSString* credential;

@property (nonatomic, strong) NSString* access_token;
@property (nonatomic, strong) NSString* device_id;
@property (strong,nonatomic) NSString * phoneNumber;
@property (strong,nonatomic) NSString * fb_link;

-(instancetype)initWithAccessToken:(NSString*)access_token
                         device_id:(NSString*)device_id
                          photo_id:(NSString*)photo_id
                       countryID:(NSInteger)countryID
                             fb_id:(NSString*)fb_id
                         fb_gender:(NSInteger)fb_gender
                           fb_name:(NSString*)fb_name
                     secret_client:(NSString*)secret_client
                        credential:(NSString*)credential;

@end
