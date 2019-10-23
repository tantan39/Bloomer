//
//  auth_register.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/9/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "auth_register.h"

@implementation auth_register

- (instancetype)initWithPhotoID:(NSString *)photoID Access_Token:(NSString *)access_token Device_Token:(NSString *)device_token BirthDay:(NSString *)birthDay LocationID:(NSInteger)locationID{
    self= [super init];
    if(self)
    {
        self.photo_id = photoID;
        _access_token = access_token;
        _device_token = device_token;
        self.birthday = birthDay;
        self.location_id = locationID;
    }
    return self;
}

- (NSDictionary *)encodeToJSON{
//    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
//    NSMutableDictionary *oauth = [NSMutableDictionary dictionaryWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token, k_DEVICE_TOKEN, nil];
//    NSMutableDictionary *profile = [[NSMutableDictionary alloc] init];
//
//    [profile setObject:_screen_name forKey:k_SCREEN_NAME];
//
//    [profile setObject:[NSNumber numberWithInteger:_gender] forKey:k_GENDER];
//
//    [dictionary setObject:oauth forKey:k_OAUTH];
//    [dictionary setObject:profile forKey:k_PROFILE];
//
//    NSDictionary * dict = [NSDictionary dictionaryWithDictionary:dictionary];
    
    NSDictionary * dict = @{
                            k_DEVICE_TOKEN : self.device_token,
                            k_ACCESS_TOKEN : self.access_token,
                            k_PHOTO_ID : self.photo_id,
                            k_BIRTHDAY : self.birthday,
                            k_LOCATION_ID : [NSNumber numberWithInteger:self.location_id]
                            };
    
    return dict;

}

@end
