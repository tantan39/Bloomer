//
//  out_profile_update.m
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/11/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import "out_profile_update.h"

@implementation out_profile_update


- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInteger:_uid forKey:k_UID];
    [encoder encodeObject:_birthday forKey:k_BIRTHDAY];
    [encoder encodeInteger:_rank forKey:k_RANK];
    [encoder encodeObject:_username forKey:k_USERNAME];
    [encoder encodeObject:_about_me forKey:k_ABOUT_ME];
    [encoder encodeObject:_email forKey:k_EMAIL];
    [encoder encodeObject:_name forKey:k_NAME];
    [encoder encodeInteger:_gender forKey:k_GENDER];
    [encoder encodeObject:_living_in forKey:k_LIVING_IN];
    [encoder encodeObject:_mobile forKey:k_MOBILE];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        _uid = [decoder decodeIntegerForKey:k_UID];
        _birthday = [decoder decodeObjectForKey:k_BIRTHDAY];
        _rank = [decoder decodeIntegerForKey:k_RANK];
        _username = [decoder decodeObjectForKey:k_USERNAME];
        _about_me = [decoder decodeObjectForKey:k_ABOUT_ME];
        _email = [decoder decodeObjectForKey:k_EMAIL];
        _name = [decoder decodeObjectForKey:k_NAME];
        _gender = [decoder decodeIntegerForKey:k_GENDER];
        _living_in = [decoder decodeObjectForKey:k_LIVING_IN];
        _mobile = [decoder decodeObjectForKey:k_MOBILE];
    }
    
    return self;
}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        NSDictionary *text = [json objectForKey:k_ACCOUNT];
        _uid = [[text objectForKey:k_UID] integerValue];
        _birthday = [text objectForKey:k_BIRTHDAY];
        _rank = [[text objectForKey:k_RANK] integerValue];
        _username = [text objectForKey:k_USERNAME];
        _about_me = [text objectForKey:k_ABOUT_ME];
        _email = [text objectForKey:k_EMAIL];
        _name = [text objectForKey:k_NAME];
        _gender = [[text objectForKey:k_GENDER] integerValue];
        _living_in = [text objectForKey:k_LIVING_IN];
        _mobile = [text objectForKey:k_MOBILE ];
    }
    return self;
}
@end
