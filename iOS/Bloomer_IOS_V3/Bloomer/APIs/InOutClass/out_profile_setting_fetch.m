//
//  out_profile_setting_fetch.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 10/19/15.
//  Copyright © 2015 Glassegg. All rights reserved.
//

#import "out_profile_setting_fetch.h"

@implementation out_profile_setting_fetch

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        NSDictionary *text = [json objectForKey:k_USER];
        _uid = [[text objectForKey:k_UID] integerValue];
        _country_code = [text objectForKey:k_COUNTRY_CODE];
        _avatar = [text objectForKey:k_AVATAR];
        _about_me = [text objectForKey:k_ABOUT_ME];
        _gender = [[text objectForKey:k_GENDER] integerValue];
        
        if ([text objectForKey:k_EMAIL] != [NSNull null])
            _email = [text objectForKey:k_EMAIL];
        else
            _email = @"";
        
        _chatting = [[text objectForKey:k_CHATTING] integerValue];
        
        _name = [text objectForKey:k_NAME];
        
        if ([text objectForKey:k_MOBILE] != [NSNull null])
            _mobile = [text objectForKey:k_MOBILE];
        else
            _mobile = @"";
        
        if ([text objectForKey:k_MOBILE_FULL] != [NSNull null])
            _mobile_full = [text objectForKey:k_MOBILE_FULL];
        else
            _mobile_full = @"";
        
        NSDictionary *location = [text objectForKey:k_LOCATION];
        _location_id = [[location objectForKey:k_LOCATION_ID] integerValue];
        _location_name = [location objectForKey:k_LOCATION_NAME];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInteger:_uid forKey:k_UID];
    [encoder encodeObject:_country_code forKey:k_COUNTRY_CODE];
    [encoder encodeObject:_avatar forKey:k_AVATAR];
    [encoder encodeObject:_about_me forKey:k_ABOUT_ME];
    [encoder encodeObject:_email forKey:k_EMAIL];
    [encoder encodeObject:_name forKey:k_NAME];
    [encoder encodeInteger:_gender forKey:k_GENDER];
    [encoder encodeObject:_mobile forKey:k_MOBILE];
    [encoder encodeObject:_mobile_full forKey:k_MOBILE_FULL];
    [encoder encodeInteger:_chatting forKey:k_CHATTING];
    [encoder encodeInteger:_location_id forKey:k_LOCATION_ID];
    [encoder encodeObject:_location_name forKey:k_LOCATION_NAME];
    [encoder encodeInteger:_chatting forKey:k_CHATTING];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        _uid = [decoder decodeIntegerForKey:k_UID];
        _about_me = [decoder decodeObjectForKey:k_ABOUT_ME];
        _email = [decoder decodeObjectForKey:k_EMAIL];
        _name = [decoder decodeObjectForKey:k_NAME];
        _gender = [decoder decodeIntegerForKey:k_GENDER];
        _mobile = [decoder decodeObjectForKey:k_MOBILE];
        _chatting = [decoder decodeIntegerForKey:k_CHATTING];
        _location_id = [decoder decodeIntegerForKey:k_LOCATION_ID];
        _location_name = [decoder decodeObjectForKey:k_LOCATION_NAME];
        _country_code = [decoder decodeObjectForKey:k_COUNTRY_CODE];
        _avatar = [decoder decodeObjectForKey:k_AVATAR];
        _mobile_full = [decoder decodeObjectForKey:k_MOBILE_FULL];
    }
    return self;
}

@end
