//
//  out_profile_fetch.m
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/12/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import "out_profile_fetch.h"

@implementation out_profile_fetch


-(void)extractData:(NSDictionary*) data
{
//    if([data objectForKey:k_PROFILE])
//    {
//        NSDictionary *profile = [data objectForKey:k_PROFILE];
//        _about_me = [profile objectForKey:k_ABOUT];
//        _avatar = [profile objectForKey:k_AVATAR];
//        _follower = [[profile objectForKey:k_FOLLOWER] integerValue];
//        _following = [[profile objectForKey:k_FOLLOWING] integerValue];
//        _location_name = [profile objectForKey:k_LOCATION];
//        _mocolor = [profile objectForKey:k_MO_COLOR];
//        
//        _name = [profile objectForKey:k_NAME];
//        self.invite_code = [profile objectForKey:k_INVITE_CODE];
//    
//        _number_chatting = [[profile objectForKey:k_NUMBER_CHATTING] longLongValue];
//        _num_received_flower = [[profile objectForKey:k_RECEIVED_FLOWER] integerValue];
//        _gaveFlower = [[profile objectForKey:@"gave_flower"] longLongValue];
//        _spcolor = [profile objectForKey:k_SP_COLOR];
//        _uid = [[profile objectForKey:k_UID] integerValue];
//        _username = [profile objectForKey:k_USERNAME];
//        _your_num_flower = [[profile objectForKey:k_FLOWERS] longLongValue];
//        _gender = [[profile objectForKey:k_GENDER] integerValue];
//        if([profile objectForKey:k_CHATTING])
//            _chatting = [[profile objectForKey:k_CHATTING] integerValue];
//        else
//            _chatting = 0;
//        
//        
//        if ([profile objectForKey:k_MOBILE] != [NSNull null])
//            _mobile = [profile objectForKey:k_MOBILE];
//        else
//            _mobile = @"";
//        
//        _is_follow = [[profile objectForKey:k_IS_FOLLOW] boolValue];
//        _is_chat = [[profile objectForKey:k_IS_CHAT] boolValue];
//        _is_block = [[profile objectForKey:@"is_block"] boolValue];
//        _is_blocked = [[profile objectForKey:@"is_blocked"] boolValue];
//        _is_block_chat = [[profile objectForKey:@"is_block_chat"] boolValue];
//        _is_blocked_chat = [[profile objectForKey:@"is_blocked_chat"] boolValue];
//        
//        _video_link = [profile objectForKey:@"video"];
//        _isupload_avatar = [[profile objectForKey:@"isupload_avatar"] boolValue];
//        _flower_thankful = [[profile objectForKey:@"flower_thankful"] longLongValue];
//        
//        //city
//        NSDictionary *cityDic = [profile objectForKey:k_CITY];
//        if (cityDic != nil)
//        {
//            self.city = [[city alloc]init];
//            self.city.city_id = [[cityDic objectForKey:k_CITY_ID] integerValue];
//            self.city.city_name =[cityDic objectForKey:k_CITY_NAME] ;
//            self.city.city_short_name = [cityDic objectForKey:k_CITY_SHORT_NAME];
//        }
//        
//        if ([profile objectForKey:k_REMAIN_FLOWER] != [NSNull null])
//            _remain_flower = [[profile objectForKey:k_REMAIN_FLOWER] integerValue];
//    }
//    if([data objectForKey:k_VERIFIED])
//    {
//        _verified = [[data objectForKey:k_VERIFIED] integerValue];
//    }
//    else
//    {
//        _verified = 0;
//    }
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_about_me forKey:k_ABOUT];
    [encoder encodeObject:_avatar forKey:k_AVATAR];
    [encoder encodeInteger:_follower forKey:k_FOLLOWER];
    [encoder encodeInteger:_following forKey:k_FOLLOWING];
    [encoder encodeObject:_location_name forKey:k_LOCATION];
    [encoder encodeObject:_mocolor forKey:k_MO_COLOR];
    [encoder encodeObject:_name forKey:k_NAME];
    [encoder encodeInt64:_number_chatting forKey:k_NUMBER_CHATTING];
    [encoder encodeInt64:_num_received_flower forKey:k_RECEIVED_FLOWER];
    [encoder encodeObject:_spcolor forKey:k_SP_COLOR];
    [encoder encodeInteger:_uid forKey:k_UID];
    [encoder encodeObject:_username forKey:k_USERNAME];
    [encoder encodeInt64:_your_num_flower forKey:k_FLOWERS];
    [encoder encodeInteger:_gender forKey:k_GENDER];
    [encoder encodeInteger:_chatting forKey:k_CHATTING];
    [encoder encodeObject:_mobile forKey:k_MOBILE];
    [encoder encodeObject:_city forKey:k_CITY];
    [encoder encodeObject:self.invite_code forKey:k_INVITE_CODE];
    [encoder encodeObject:self.video_link forKey:@"video"];
    [encoder encodeBool:self.is_block_chat forKey:@"is_block_chat"];
    [encoder encodeBool:self.is_blocked_chat forKey:@"is_blocked_chat"];
    [encoder encodeInt64:self.gaveFlower forKey:@"gave_flower"];
    [encoder encodeBool:self.isupload_avatar forKey:@"isupload_avatar"];
    [encoder encodeInt64:self.flower_thankful forKey:@"flower_thankful"];
    [encoder encodeBool:_pass forKey:@"pass"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        _about_me = [decoder decodeObjectForKey:k_ABOUT];
        _avatar = [decoder decodeObjectForKey:k_AVATAR];
        _follower = [decoder decodeIntegerForKey:k_FOLLOWER];
        _following = [decoder decodeIntegerForKey:k_FOLLOWING];
        _location_name = [decoder decodeObjectForKey:k_LOCATION];
        _mocolor = [decoder decodeObjectForKey:k_MO_COLOR];
        _name = [decoder decodeObjectForKey:k_NAME];
        _number_chatting = [decoder decodeInt64ForKey:k_NUMBER_CHATTING];
        _num_received_flower = [decoder decodeInt64ForKey:k_RECEIVED_FLOWER];
        _spcolor = [decoder decodeObjectForKey:k_SP_COLOR];
        _uid = [decoder decodeIntegerForKey:k_UID];
        _username = [decoder decodeObjectForKey:k_USERNAME];
        _your_num_flower = [decoder decodeInt64ForKey:k_FLOWERS];
        _gender = [decoder decodeIntegerForKey:k_GENDER];
        _chatting = [decoder decodeIntegerForKey:k_CHATTING];
        _mobile = [decoder decodeObjectForKey:k_MOBILE];
        _city = [decoder decodeObjectForKey:k_CITY];
        self.invite_code = [decoder decodeObjectForKey:k_INVITE_CODE];
        _video_link = [decoder decodeObjectForKey:@"video"];
        _is_block_chat = [decoder decodeBoolForKey:@"is_block_chat"];
        _is_blocked_chat = [decoder decodeBoolForKey:@"is_blocked_chat"];
        _gaveFlower = [decoder decodeInt64ForKey:@"gave_flower"];
        self.isupload_avatar = [decoder decodeBoolForKey:@"isupload_avatar"];
        self.flower_thankful = [decoder decodeInt64ForKey:@"flower_thankful"];
        _pass = [decoder decodeBoolForKey:@"pass"];
    }
    return self;
}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        if([json objectForKey:k_PROFILE])
        {
            NSDictionary *profile = [json objectForKey:k_PROFILE];
            _about_me = [profile objectForKey:k_ABOUT];
            _avatar = [profile objectForKey:k_AVATAR];
            _follower = [[profile objectForKey:k_FOLLOWER] integerValue];
            _following = [[profile objectForKey:k_FOLLOWING] integerValue];
            _location_name = [profile objectForKey:k_LOCATION];
            _mocolor = [profile objectForKey:k_MO_COLOR];
            
            _name = [profile objectForKey:k_NAME];
            self.invite_code = [profile objectForKey:k_INVITE_CODE];
            
            _number_chatting = [[profile objectForKey:k_NUMBER_CHATTING] longLongValue];
            _num_received_flower = [[profile objectForKey:k_RECEIVED_FLOWER] integerValue];
            _gaveFlower = [[profile objectForKey:@"gave_flower"] longLongValue];
            _spcolor = [profile objectForKey:k_SP_COLOR];
            _uid = [[profile objectForKey:k_UID] integerValue];
            _username = [profile objectForKey:k_USERNAME];
            _your_num_flower = [[profile objectForKey:k_FLOWERS] longLongValue];
            _invite_flower = [[profile objectForKey:k_INVITE_FLOWER] longValue];
            _gender = [[profile objectForKey:k_GENDER] integerValue];
            if([profile objectForKey:k_CHATTING])
                _chatting = [[profile objectForKey:k_CHATTING] integerValue];
            else
                _chatting = 0;
            
            _pass = [[profile objectForKey:@"pass"] boolValue];
            
            if ([profile objectForKey:k_MOBILE] != [NSNull null])
                _mobile = [profile objectForKey:k_MOBILE];
            else
                _mobile = @"";
            
            _is_follow = [[profile objectForKey:k_IS_FOLLOW] boolValue];
            _is_chat = [[profile objectForKey:k_IS_CHAT] boolValue];
            _is_block = [[profile objectForKey:@"is_block"] boolValue];
            _is_blocked = [[profile objectForKey:@"is_blocked"] boolValue];
            _is_block_chat = [[profile objectForKey:@"is_block_chat"] boolValue];
            _is_blocked_chat = [[profile objectForKey:@"is_blocked_chat"] boolValue];
            
            _video_link = [profile objectForKey:@"video"];
            _isupload_avatar = [[profile objectForKey:@"isupload_avatar"] boolValue];
            _flower_thankful = [[profile objectForKey:@"flower_thankful"] longLongValue];
            _gsb_medal = [profile objectForKey:@"gsb_medal"] ;
            //city
            NSDictionary *cityDic = [profile objectForKey:k_CITY];
            if (cityDic != nil)
            {
                self.city = [[city alloc]init];
                self.city.city_id = [[cityDic objectForKey:k_CITY_ID] integerValue];
                self.city.city_name =[cityDic objectForKey:k_CITY_NAME] ;
                self.city.city_short_name = [cityDic objectForKey:k_CITY_SHORT_NAME];
            }
            
            if ([profile objectForKey:k_REMAIN_FLOWER] != [NSNull null])
                _remain_flower = [[profile objectForKey:k_REMAIN_FLOWER] integerValue];
        }
        if([json objectForKey:k_VERIFIED])
        {
            _verified = [[json objectForKey:k_VERIFIED] integerValue];
        }
        else
        {
            _verified = 0;
        }
    }
    
    return self;
}

@end
