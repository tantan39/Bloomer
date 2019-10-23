//
//  Auth_FBAuthentication.m
//  Bloomer
//
//  Created by Tran Thai Tan on 11/30/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "Auth_FBAuthentication.h"

@implementation Auth_FBAuthentication

- (instancetype)initWithFBToken:(NSString *)fbToken SecretClient:(NSString *)secretClient DeviceToken:(NSString *)deviceToken NotificationToken:(NSString *)notifToken Credential:(NSString *)credential CountryID:(NSInteger)countryID AppID:(NSInteger)appID{
    self = [super init];
    if (self) {
        self.fbToken = fbToken;
        self.secretClient = secretClient;
        self.deviceToken = deviceToken,
        self.notificationToken = notifToken;
        self.credential = credential;
        self.countryID = countryID;
        self.appID = appID;
    }
    return self;
}

-(NSDictionary *)encodeToJSON{
    NSDictionary * params = @{k_FBTOKEN : self.fbToken == nil ? @"" : self.fbToken,
                              k_SECRET_CLIENT : self.secretClient,
                              k_COUNTRY_ID : [NSNumber numberWithInteger:self.countryID],
                              k_DEVICE_TOKEN : self.deviceToken,
                              k_APP_ID : [NSNumber numberWithInteger:self.appID],
                              k_NOTIFICATION_TOKEN : self.notificationToken,
                              k_CREDENTIAL : self.credential
                              };
    return params;
}

@end
