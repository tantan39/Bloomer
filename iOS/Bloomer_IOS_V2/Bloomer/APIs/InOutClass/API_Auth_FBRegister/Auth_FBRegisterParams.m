//
//  Auth_FBRegisterParams.m
//  Bloomer
//
//  Created by Le Chau Tu on 11/28/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "Auth_FBRegisterParams.h"

@implementation Auth_FBRegisterParams

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        self.fb_id = [json objectForKey:@"id"];
        self.fb_name = [json objectForKey:@"name"];
        self.fb_is_silhouette = [[[[json objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"is_silhouette"] boolValue];
        if(!self.fb_is_silhouette) {
            self.fb_urlPicture = [[[json objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
        }
        NSString * strGender = [json objectForKey:@"gender"];
        if ([strGender isEqualToString:@"male"]) {
            self.fb_gender = MALE;
        }else{
            self.fb_gender = FEMALE;
        }
        self.fb_link = [json objectForKey:@"link"];
    }
    return self;
}

-(instancetype)initWithAccessToken:(NSString *)access_token device_id:(NSString *)device_id photo_id:(NSString *)photo_id countryID:(NSInteger)countryID fb_id:(NSString *)fb_id fb_gender:(NSInteger)fb_gender fb_name:(NSString *)fb_name secret_client:(NSString *)secret_client credential:(NSString *)credential {
    self = [super init];
    if(self) {
        _access_token = access_token;
        _device_id = device_id;
        _photo_id = photo_id;
        _countryID = countryID;
        _fb_id = fb_id;
        _fb_gender = fb_gender;
        _fb_name = fb_name;
        _secret_client = secret_client;
        _credential = credential;
    }
    return self;
}

-(NSDictionary *)encodeToJSON {
    NSDictionary* oauth = @{k_ACCESS_TOKEN  :   _access_token,
                            k_DEVICE_TOKEN  :   _device_id
                            };
    
    NSDictionary* profile = @{k_PHOTO_ID        :   _photo_id,
                              k_COUNTRY_ID     :   [NSNumber numberWithInteger:_countryID],
                              @"fb_id"          :   _fb_id,
                              @"fb_gender"      :   [NSNumber numberWithInteger:_fb_gender],
                              @"fb_name"        :   _fb_name,
                              k_SECRET_CLIENT   :   _secret_client,
                              k_CREDENTIAL      :   _credential
                              };
    NSDictionary* params = @{k_PROFILE  :   profile,
                             k_OAUTH    :   oauth
                             };
    
    return params;
}

@end
