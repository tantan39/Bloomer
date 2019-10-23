//
//  Auth_FBAuthentication.h
//  Bloomer
//
//  Created by Tran Thai Tan on 11/30/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"

@interface Auth_FBAuthentication : NSObject<BaseJSON>

@property (strong,nonatomic) NSString * fbToken;
@property (strong,nonatomic) NSString * secretClient;
@property (strong,nonatomic) NSString * deviceToken;
@property (strong,nonatomic) NSString * notificationToken;
@property (strong,nonatomic) NSString * credential;
@property (assign,nonatomic) NSInteger countryID;
@property (assign,nonatomic) NSInteger appID;

- (instancetype)initWithFBToken:(NSString *) fbToken SecretClient:(NSString *) secretClient DeviceToken:(NSString *) deviceToken NotificationToken:(NSString *) notifToken Credential:(NSString *) credential CountryID:(NSInteger) countryID AppID:(NSInteger) appID;


@end
