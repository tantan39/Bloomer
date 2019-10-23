//
//  RegisterInfo.m
//  Bloomer
//
//  Created by Tan Tan on 10/17/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "RegisterInfo.h"

@implementation RegisterInfo

- (instancetype)initWithName:(NSString *)screenName SecretClient:(NSString *)secretClient Credential:(NSString *)credential DeviceID:(NSString *)deviceID Gender:(NSInteger)gender CountryID:(NSInteger)countryID AppID:(NSInteger)appID Email:(NSString *)email{
    
    self = [super init];
    if (self) {
        self.screenName = screenName;
        self.secretClient = secretClient;
        self.deviceToken = deviceID,
        self.credential = credential;
        self.gender = gender;
        self.countryID = countryID;
        self.appID = appID;
        self.email = email;
    }
    return self;
}

- (NSDictionary *)encodeToJSON{
    NSDictionary * params = @{ k_GENDER : [NSNumber numberWithInteger:self.gender],
                               k_COUNTRY_ID : [NSNumber numberWithInteger:self.countryID],
                               k_APP_ID : [NSNumber numberWithInteger:self.appID],
                               k_EMAIL : self.email,
                               k_SCREEN_NAME : self.screenName,
                               k_DEVICE_TOKEN : self.deviceToken,
                               k_SECRET_CLIENT : self.secretClient,
                               k_CREDENTIAL : self.credential
                               };
    return params;
}

@end
