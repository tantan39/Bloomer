//
//  out_profile_setting.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/12/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "out_profile_setting.h"

@implementation out_profile_setting

//- (void)extractData:(NSDictionary *)data {
//    NSDictionary *profile = [data objectForKey:k_PROFILE];
//    
//    _private_share = [[profile objectForKey:@"private_share"] boolValue];
//    _number_chatting = [[profile objectForKey:k_NUMBER_CHATTING] longLongValue];
//    _mocode = [profile objectForKey:k_MOCODE];
//    _gender = [[profile objectForKey:k_GENDER] integerValue];
//    _mobile = [profile objectForKey:k_MOBILE];
//    _avatar = [profile objectForKey:k_AVATAR];
//    _about_me = [profile objectForKey:k_ABOUT_ME];
//    _thanks = [profile objectForKey:k_THANKS];
//    _uid = [[profile objectForKey:k_UID] integerValue];
//    _number_flower = [[profile objectForKey:k_NUMBER_FLOWER] longLongValue];
//    _screen_name = [profile objectForKey:k_SCREEN_NAME];
//    _spcode = [profile objectForKey:k_SPCODE];
//    if ([profile objectForKey:k_EMAIL]!= [NSNull null]) {
//        _email = [profile objectForKey:k_EMAIL];
//        _verified_email = [[profile objectForKey:k_VERIFIED_EMAIL] boolValue];
//    }
//    _username = [profile objectForKey:k_USERNAME];
//    
//    NSDictionary *country = [profile objectForKey:k_COUNTRY];
//    _country_code = [country objectForKey:k_COUNTRY_CODE];
//    _country_id = [[country objectForKey:k_COUNTRY_ID] integerValue];
//    _country_name = [country objectForKey:k_COUNTRY_NAME];
//    _country_short_name = [country objectForKey:k_COUNTRY_SHORT_NAME];
//    
//    NSDictionary *city = [profile objectForKey:k_CITY];
//    _city_name = [city objectForKey:k_CITY_NAME];
//    _city_id = [[city objectForKey:k_CITY_ID] integerValue];
//    _city_short_name = [city objectForKey:k_CITY_SHORT_NAME];
//    
//    NSDictionary *notification = [profile objectForKey:k_NOTIFICATION];
//    _all = [[notification objectForKey:@"all"] boolValue];
//    _app = [[notification objectForKey:@"app"] boolValue];
//    _race = [[notification objectForKey:k_RACE] boolValue];
//    _chat = [[notification objectForKey:@"chat"] boolValue];
//    _follow = [[notification objectForKey:@"follow"] boolValue];
//    _flower = [[notification objectForKey:k_FLOWER] boolValue];
//}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        NSDictionary *profile = [json objectForKey:k_PROFILE];
        
        _private_share = [[profile objectForKey:@"private_share"] boolValue];
        _number_chatting = [[profile objectForKey:k_NUMBER_CHATTING] longLongValue];
        _mocode = [profile objectForKey:k_MOCODE];
        _gender = [[profile objectForKey:k_GENDER] integerValue];
        _mobile = [profile objectForKey:k_MOBILE];
        _avatar = [profile objectForKey:k_AVATAR];
        _about_me = [profile objectForKey:k_ABOUT_ME];
        _thanks = [profile objectForKey:k_THANKS];
        _uid = [[profile objectForKey:k_UID] integerValue];
        _number_flower = [[profile objectForKey:k_NUMBER_FLOWER] longLongValue];
        _screen_name = [profile objectForKey:k_SCREEN_NAME];
        _spcode = [profile objectForKey:k_SPCODE];
        if ([profile objectForKey:k_EMAIL]!= [NSNull null]) {
            _email = [profile objectForKey:k_EMAIL];
            _verified_email = [[profile objectForKey:k_VERIFIED_EMAIL] boolValue];
        }
        _username = [profile objectForKey:k_USERNAME];
        self.birthday = [profile objectForKey:k_BIRTHDAY];
        
        if ([self.birthday isKindOfClass: [NSNull class]]) {
            self.birthday = nil;
        }
        
        NSDictionary *country = [profile objectForKey:k_COUNTRY];
        _country_code = [country objectForKey:k_COUNTRY_CODE];
        _country_id = [[country objectForKey:k_COUNTRY_ID] integerValue];
        _country_name = [country objectForKey:k_COUNTRY_NAME];
        _country_short_name = [country objectForKey:k_COUNTRY_SHORT_NAME];
        
        NSDictionary *city = [profile objectForKey:k_CITY];
        _city_name = [city objectForKey:k_CITY_NAME];
        _city_id = [[city objectForKey:k_CITY_ID] integerValue];
        _city_short_name = [city objectForKey:k_CITY_SHORT_NAME];
        
        NSDictionary *notification = [profile objectForKey:k_NOTIFICATION];
        _all = [[notification objectForKey:@"all"] boolValue];
        _app = [[notification objectForKey:@"app"] boolValue];
        _race = [[notification objectForKey:k_RACE] boolValue];
        _chat = [[notification objectForKey:@"chat"] boolValue];
        _follow = [[notification objectForKey:@"follow"] boolValue];
        _flower = [[notification objectForKey:k_FLOWER] boolValue];
    }
    return self;
}

@end
