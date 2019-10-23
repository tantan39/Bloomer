//
//  notification.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/18/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "notification.h"

@implementation flower_photo_notication

+(id)alloc{
    return [super alloc];
}
-(id)init{
    return [super init];
}
@end

@implementation flower_race_notication

+(id)alloc{
    return [super alloc];
}
-(id)init{
    return [super init];
}
@end

@implementation flower_avatar_notication

+(id)alloc{
    return [super alloc];
}
-(id)init{
    return [super init];
}
@end

@implementation flower_daily_notication

+(id)alloc{
    return [super alloc];
}
-(id)init{
    return [super init];
}
@end

@implementation comment_notication
+(id)alloc{ return [super alloc];}
-(id)init{ return [super init];}
@end
@implementation top_rank_notication
+(id)alloc{ return [super alloc];}
-(id)init{ return [super init];}
@end
@implementation special_opened_notication
+(id)alloc{ return [super alloc];}
-(id)init{ return [super init];}
@end
@implementation event_opened_notication
+(id)alloc{ return [super alloc];}
-(id)init{ return [super init];}
@end
@implementation sponsor_opened_notication
+(id)alloc{ return [super alloc];}
-(id)init{ return [super init];}
@end
@implementation monthly_closed_1day_notication
+(id)alloc{ return [super alloc];}
-(id)init{ return [super init];}
@end
@implementation unlock_chat_notication
+(id)alloc{ return [super alloc];}
-(id)init{ return [super init];}
@end
@implementation leaderboard_result_notication
+(id)alloc{ return [super alloc];}
-(id)init{ return [super init];}
@end
@implementation noti_top_country
+(id)alloc{ return [super alloc];}
-(id)init{ return [super init];}
@end

@implementation noti_welcome_gsb
+(id)alloc{ return [super alloc];}
-(id)init{ return [super init];}
@end

@implementation noti_invitee_receive_flower
+(id)alloc{ return [super alloc];}
-(id)init{ return [super init];}
@end

@implementation noti_inviter_receive_flower
+(id)alloc{ return [super alloc];}
-(id)init{ return [super init];}
@end

@implementation noti_share
+(id)alloc{ return [super alloc];}
-(id)init{ return [super init];}
@end

@implementation noti_payment
+(id)alloc{ return [super alloc];}
-(id)init{ return [super init];}
@end

@implementation default_Noti
+(id)alloc{ return [super alloc];}
-(id)init{ return [super init];}
@end

@implementation normal_maketing_noti
+(id)alloc{ return [super alloc];}
-(id)init{ return [super init];}
@end

@implementation notification

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        // static value
        _notification_id = [json objectForKey:k_NOTIFICATION_ID];
        _timestamp = [[json objectForKey:k_TIMESTAMP] longLongValue];
        _isRead = [[json objectForKey:k_READ] boolValue];
        
        //dynamic value by type
        NSDictionary *content = [json objectForKey:k_CONTENT];
        NSString* sType = [json objectForKey:k_TYPE];
        
        //    SWITCH (sType) {
        //        CASE (NOTIFICATION_FLOWER_PHOTO) {
        //            _type = NOTIFICATION_TYPE_FLOWER_PHOTO;
        //            _photoContent= [[flower_photo_notication alloc] init];
        //            _photoContent.giver_name = [content objectForKey:k_GIVER_NAME];
        //            _photoContent.giver_avatar = [content objectForKey:k_GIVER_AVATAR];
        //            _photoContent.isGroup = [[content objectForKey:k_ISGROUP] boolValue];
        //            _photoContent.number_flower = [[content objectForKey:k_NUMBER_FLOWER] longLongValue];
        //            _photoContent.number_people = [[content objectForKey:k_NUMBER_PEOPLE] integerValue];
        //            _photoContent.photo_url = [content objectForKey:k_PHOTO_URL];
        //            _photoContent.post_id = [content objectForKey:k_POST_ID];
        //            break;
        //        }
        //        CASE (NOTIFICATION_FLOWER_RACE) {
        //            _type = NOTIFICATION_TYPE_FLOWER_RACE;
        //            _raceContent = [[flower_race_notication alloc]init];
        //            _raceContent.giver_name = [content objectForKey:k_GIVER_NAME];
        //            _raceContent.giver_avatar = [content objectForKey:k_GIVER_AVATAR];
        //            _raceContent.isGroup = [[content objectForKey:k_ISGROUP] boolValue];
        //            _raceContent.number_flower = [[content objectForKey:k_NUMBER_FLOWER] longLongValue];
        //            _raceContent.number_people = [[content objectForKey:k_NUMBER_PEOPLE] integerValue];
        //            _raceContent.race_key = [content objectForKey:k_RACE_KEY];
        //            _raceContent.noti_key = [content objectForKey:K_NOTI_KEY];
        //            _raceContent.race_name = [content objectForKey:k_RACE_NAME];
        //            break;
        //        }
        //        CASE (NOTIFICATION_FLOWER_AVATAR) {
        //            _type = NOTIFICATION_TYPE_FLOWER_AVATAR;
        //            _avatarContent = [[flower_avatar_notication alloc]init];
        //            _avatarContent.giver_name = [content objectForKey:k_GIVER_NAME];
        //            _avatarContent.giver_avatar = [content objectForKey:k_GIVER_AVATAR];
        //            _avatarContent.isGroup = [[content objectForKey:k_ISGROUP] boolValue];
        //            _avatarContent.number_flower = [[content objectForKey:k_NUMBER_FLOWER] longLongValue];
        //            _avatarContent.number_people = [[content objectForKey:k_NUMBER_PEOPLE] integerValue];
        //            break;
        //        }
        //        CASE (NOTIFICATION_FLOWER_DAILY) {
        //            _type = NOTIFICATION_TYPE_FLOWER_DAILY;
        //            _dailyContent = [[flower_daily_notication alloc]init];
        //            _dailyContent.number_flower = [[content objectForKey:k_NUMBER_FLOWER] longLongValue];
        //            break;
        //        }
        //        CASE (NOTIFICATION_COMMENT) {
        //            _type = NOTIFICATION_TYPE_COMMENT;
        //            _commentContent = [[comment_notication alloc]init];
        //            _commentContent.commenter_name = [content objectForKey:k_COMMENTER_NAME];
        //            _commentContent.commenter_avatar = [content objectForKey:k_COMMENTER_AVATAR];
        //            _commentContent.isGroup = [[content objectForKey:k_ISGROUP] boolValue];
        //            _commentContent.number_people = [[content objectForKey:k_NUMBER_PEOPLE] integerValue];
        //            _commentContent.photo_url = [content objectForKey:k_PHOTO_URL];
        //            _commentContent.post_id = [content objectForKey:k_POST_ID];
        //            _commentContent.isMe = [[content objectForKey:k_ISME] boolValue];
        //            if(!_commentContent.isMe)
        //                _commentContent.poster_name = [content objectForKey:k_POSTER_NAME];
        //            else
        //                _commentContent.poster_name = @"" ;
        //
        //            break;
        //        }
        //        CASE (NOTIFICATION_TOP_RANK) {
        //            _type = NOTIFICATION_TYPE_TOP_RANK;
        //            _topRankContent = [[top_rank_notication alloc]init];
        //            _topRankContent.race_key = [content objectForKey:k_RACE_KEY];
        //            _topRankContent.race_name = [content objectForKey:k_RACE_NAME];
        //            _topRankContent.topID = [[content objectForKey:k_TOP] integerValue];
        //
        //            break;
        //        }
        //        CASE (NOTIFICATION_SPECIAL_RACE_OPENED) {
        //            _type = NOTIFICATION_TYPE_SPECIAL_RACE_OPENED;
        //            _specialContent = [[special_opened_notication alloc]init];
        //            _specialContent.race_key = [content objectForKey:k_RACE_KEY];
        //            _specialContent.race_name = [content objectForKey:k_RACE_NAME];
        //            break;
        //        }
        //        CASE (NOTIFICATION_EVENT_RACE_OPENED) {
        //            _type = NOTIFICATION_TYPE_EVENT_RACE_OPENED;
        //            _eventContent = [[event_opened_notication alloc]init];
        //            _eventContent.race_key = [content objectForKey:k_RACE_KEY];
        //            _eventContent.race_name = [content objectForKey:k_RACE_NAME];
        //
        //            break;
        //        }
        //        CASE (NOTIFICATION_SPONSOR_RACE_OPENED) {
        //            _type = NOTIFICATION_TYPE_SPONSOR_RACE_OPENED;
        //            _sponsorContent = [[sponsor_opened_notication alloc]init];
        //            _sponsorContent.race_key = [content objectForKey:k_RACE_KEY];
        //            _sponsorContent.race_name = [content objectForKey:k_RACE_NAME];
        //
        //            break;
        //        }
        //        CASE (NOTIFICATION_MONTHLY_CLOSED_1DAY) {
        //            _type = NOTIFICATION_TYPE_MONTHLY_CLOSED_1DAY;
        //            _monthlyContent = [[monthly_closed_1day_notication alloc]init];
        //            _monthlyContent.race_key = [content objectForKey:k_RACE_KEY];
        //            _monthlyContent.race_name = [content objectForKey:k_RACE_NAME];
        //
        //            break;
        //        }
        //        CASE (NOTIFICATION_UNLOCK_CHAT) {
        //            _type = NOTIFICATION_TYPE_UNLOCK_CHAT;
        //            _chatContent= [[unlock_chat_notication alloc]init];
        //            _chatContent.model_ID = [[content objectForKey:k_MODEL_ID] integerValue];
        //            _chatContent.model_name = [content objectForKey:k_MODEL_NAME];
        //            _chatContent.model_avatar = [content objectForKey:k_MODEL_AVATAR] ;
        //            break;
        //        }
        //        CASE (NOTIFICATION_LEADERBOARD_RESULT) {
        //            _type = NOTIFICATION_TYPE_LEADERBOARD_RESULT;
        //            _leadrerboardResultContent= [[leaderboard_result_notication alloc]init];
        //            _leadrerboardResultContent.monthly_time = [content objectForKey:k_MONTHLY_TIME];
        //            _leadrerboardResultContent.result_link = [content objectForKey:K_RESULT_LINK] ;
        //            break;
        //        }
        //        CASE (NOTIFICATION_TOP_COUNTRY) {
        //            _type = NOTIFICATION_TYPE_TOP_COUNTRY;
        //            _topCountry = [[noti_top_country alloc] init];
        //            _topCountry.message = [content objectForKey:k_MESSAGE];
        //            _topCountry.url = [content objectForKey:K_URL];
        //            break;
        //        }
        //    }
        
        if ([sType isEqualToString:NOTIFICATION_FLOWER_PHOTO]) {
            _type = NOTIFICATION_TYPE_FLOWER_PHOTO;
            _photoContent= [[flower_photo_notication alloc] init];
            _photoContent.giver_name = [content objectForKey:k_GIVER_NAME];
            _photoContent.giver_avatar = [content objectForKey:k_GIVER_AVATAR];
            _photoContent.isGroup = [[content objectForKey:k_ISGROUP] boolValue];
            _photoContent.number_flower = [[content objectForKey:k_NUMBER_FLOWER] longLongValue];
            _photoContent.number_people = [[content objectForKey:k_NUMBER_PEOPLE] integerValue];
            _photoContent.photo_url = [content objectForKey:k_PHOTO_URL];
            _photoContent.post_id = [content objectForKey:k_POST_ID];
            _photoContent.uidAvatar = [[content objectForKey:k_GIVER_ID] integerValue];
            _photoContent.message = [json objectForKey:k_MESSAGE];
        } else if ([sType isEqualToString:NOTIFICATION_FLOWER_RACE]){
            _type = NOTIFICATION_TYPE_FLOWER_RACE;
            _raceContent = [[flower_race_notication alloc]init];
            _raceContent.giver_name = [content objectForKey:k_GIVER_NAME];
            _raceContent.giver_avatar = [content objectForKey:k_GIVER_AVATAR];
            _raceContent.isGroup = [[content objectForKey:k_ISGROUP] boolValue];
            _raceContent.number_flower = [[content objectForKey:k_NUMBER_FLOWER] longLongValue];
            _raceContent.number_people = [[content objectForKey:k_NUMBER_PEOPLE] integerValue];
            _raceContent.race_key = [content objectForKey:k_RACE_KEY];
            _raceContent.noti_key = [content objectForKey:K_NOTI_KEY];
            _raceContent.race_name = [content objectForKey:k_RACE_NAME];
            _raceContent.message = [json objectForKey:k_MESSAGE];
        } else if ([sType isEqualToString:NOTIFICATION_FLOWER_AVATAR]){
            _type = NOTIFICATION_TYPE_FLOWER_AVATAR;
            _avatarContent = [[flower_avatar_notication alloc]init];
            _avatarContent.giver_name = [content objectForKey:k_GIVER_NAME];
            _avatarContent.giver_avatar = [content objectForKey:k_GIVER_AVATAR];
            _avatarContent.isGroup = [[content objectForKey:k_ISGROUP] boolValue];
            _avatarContent.number_flower = [[content objectForKey:k_NUMBER_FLOWER] longLongValue];
            _avatarContent.number_people = [[content objectForKey:k_NUMBER_PEOPLE] integerValue];
            _avatarContent.message = [json objectForKey:k_MESSAGE];
            _avatarContent.giver_id = [[content objectForKey:k_GIVER_ID] integerValue];
        } else if ([sType isEqualToString:NOTIFICATION_FLOWER_DAILY]){
            _type = NOTIFICATION_TYPE_FLOWER_DAILY;
            _dailyContent = [[flower_daily_notication alloc]init];
            _dailyContent.number_flower = [[content objectForKey:k_NUMBER_FLOWER] longLongValue];
            _dailyContent.message = [json objectForKey:k_MESSAGE];
        } else if ([sType isEqualToString:NOTIFICATION_COMMENT]){
            _type = NOTIFICATION_TYPE_COMMENT;
            _commentContent = [[comment_notication alloc]init];
            _commentContent.commenter_name = [content objectForKey:k_COMMENTER_NAME];
            _commentContent.commenter_avatar = [content objectForKey:k_COMMENTER_AVATAR];
            _commentContent.isGroup = [[content objectForKey:k_ISGROUP] boolValue];
            _commentContent.number_people = [[content objectForKey:k_NUMBER_PEOPLE] integerValue];
            _commentContent.photo_url = [content objectForKey:k_PHOTO_URL];
            _commentContent.post_id = [content objectForKey:k_POST_ID];
            _commentContent.isMe = [[content objectForKey:k_ISME] boolValue];
            if(!_commentContent.isMe)
                _commentContent.poster_name = [content objectForKey:k_POSTER_NAME];
            else
                _commentContent.poster_name = @"" ;
            _commentContent.message = [json objectForKey:k_MESSAGE];
        } else if ([sType isEqualToString:NOTIFICATION_TOP_RANK]){
            _type = NOTIFICATION_TYPE_TOP_RANK;
            _topRankContent = [[top_rank_notication alloc]init];
            _topRankContent.race_key = [content objectForKey:k_RACE_KEY];
            _topRankContent.race_name = [content objectForKey:k_RACE_NAME];
            _topRankContent.topID = [[content objectForKey:k_TOP] integerValue];
            _topRankContent.message = [json objectForKey:k_MESSAGE];
        } else if ([sType isEqualToString:NOTIFICATION_SPECIAL_RACE_OPENED]){
            _type = NOTIFICATION_TYPE_SPECIAL_RACE_OPENED;
            _specialContent = [[special_opened_notication alloc]init];
            _specialContent.race_key = [content objectForKey:k_RACE_KEY];
            _specialContent.race_name = [content objectForKey:k_RACE_NAME];
            _specialContent.message = [json objectForKey:k_MESSAGE];
        } else if ([sType isEqualToString:NOTIFICATION_EVENT_RACE_OPENED]){
            _type = NOTIFICATION_TYPE_EVENT_RACE_OPENED;
            _eventContent = [[event_opened_notication alloc]init];
            _eventContent.race_key = [content objectForKey:k_RACE_KEY];
            _eventContent.race_name = [content objectForKey:k_RACE_NAME];
            _eventContent.message = [json objectForKey:k_MESSAGE];
        } else if ([sType isEqualToString:NOTIFICATION_SPONSOR_RACE_OPENED]){
            _type = NOTIFICATION_TYPE_SPONSOR_RACE_OPENED;
            _sponsorContent = [[sponsor_opened_notication alloc]init];
            _sponsorContent.race_key = [content objectForKey:k_RACE_KEY];
            _sponsorContent.race_name = [content objectForKey:k_RACE_NAME];
            _sponsorContent.message = [json objectForKey:k_MESSAGE];
        } else if ([sType isEqualToString:NOTIFICATION_MONTHLY_CLOSED_1DAY]){
            _type = NOTIFICATION_TYPE_MONTHLY_CLOSED_1DAY;
            _monthlyContent = [[monthly_closed_1day_notication alloc]init];
            _monthlyContent.race_key = [content objectForKey:k_RACE_KEY];
            _monthlyContent.race_name = [content objectForKey:k_RACE_NAME];
            _monthlyContent.message = [json objectForKey:k_MESSAGE];
        } else if ([sType isEqualToString:NOTIFICATION_UNLOCK_CHAT]){
            _type = NOTIFICATION_TYPE_UNLOCK_CHAT;
            _chatContent= [[unlock_chat_notication alloc]init];
            _chatContent.model_ID = [[content objectForKey:k_MODEL_ID] integerValue];
            _chatContent.model_name = [content objectForKey:k_MODEL_NAME];
            _chatContent.model_avatar = [content objectForKey:k_MODEL_AVATAR] ;
            _chatContent.message = [json objectForKey:k_MESSAGE];
            _chatContent.model_ScreenName = [content objectForKey:@"modelScreenName"];
        } else if ([sType isEqualToString:NOTIFICATION_LEADERBOARD_RESULT]){
            _type = NOTIFICATION_TYPE_LEADERBOARD_RESULT;
            _leadrerboardResultContent= [[leaderboard_result_notication alloc]init];
            _leadrerboardResultContent.monthly_time = [content objectForKey:k_MONTHLY_TIME];
            _leadrerboardResultContent.result_link = [content objectForKey:K_RESULT_LINK] ;
            _leadrerboardResultContent.message = [json objectForKey:k_MESSAGE];
        } else if ([sType isEqualToString:NOTIFICATION_TOP_COUNTRY]){
            _type = NOTIFICATION_TYPE_TOP_COUNTRY;
            _topCountry = [[noti_top_country alloc] init];
            _topCountry.message = [json objectForKey:k_MESSAGE];
            _topCountry.url = [json objectForKey:K_URL];
            _topCountry.is_share = [[json objectForKey:@"is_share"] boolValue];
        }
        else if ([sType isEqualToString:NOTIFICATION_WELCOME_GSB]){
            _type = NOTIFICATION_TYPE_WELCOME_GSB;
            _welcomeGSB = [[noti_welcome_gsb alloc] init];
            _welcomeGSB.message = [json objectForKey:k_MESSAGE];
            _welcomeGSB.url = [json objectForKey:K_URL];
            _welcomeGSB.is_share = [[json objectForKey:@"is_share"] boolValue];
//            _topCountry.is_share = [[json objectForKey:@"is_share"] boolValue];
        } else if([sType isEqualToString:NOTIFICATION_INVITEE_RECEIVE_FLOWER])
        {
            _type = NOTIFICATION_TYPE_INVITEE_RECEIVE_FLOWER;
            _inviteeReceive = [[noti_invitee_receive_flower alloc] init];
            _inviteeReceive.message = [json objectForKey:k_MESSAGE];
            _inviteeReceive.avatar = [json objectForKey:K_INVITEE_AVATAR];
            _inviteeReceive.uid = [[json objectForKey:K_INVITEE_ID] integerValue];
        }else if([sType isEqualToString:NOTIFICATION_INVITER_RECEIVE_FLOWER])
        {
            _type = NOTIFICATION_TYPE_INVITER_RECEIVE_FLOWER;
            _inviterReceive = [[noti_inviter_receive_flower alloc] init];
            _inviterReceive.message = [json objectForKey:k_MESSAGE];
            _inviterReceive.avatar = [json objectForKey:K_INVITEE_AVATAR];
            _inviterReceive.uid = [[json objectForKey:K_INVITEE_ID] integerValue];
        }else if([sType isEqualToString:NOTIFICATION_NOTI_SHARE])
        {
            _type = NOTIFICATION_TYPE_SHARE;
            _shareNoti = [[noti_share alloc] init];
            _shareNoti.message = [json objectForKey:k_MESSAGE];
        }
        else if([sType isEqualToString:NOTIFICATION_NOTI_PAYMENT])
        {
            _type = NOTIFICATION_TYPE_PAYMENT;
            _paymentNoti = [[noti_payment alloc] init];
            _paymentNoti.message = [json objectForKey:k_MESSAGE];
        }
        else
        {
            _type = NOTIFICATION_DEFAULT_NULL;
            _defaultNoti = [[default_Noti alloc] init];
            _defaultNoti.message = [json objectForKey:k_MESSAGE];
        }
        //    _message = [data objectForKey:k_MESSAGE];
        //    if ([data objectForKey:k_USER_ID] != [NSNull null])
        //    {
        //        _uid = [[data objectForKey:@"receiver_id"] integerValue];
        //    }
        
        //    _num_flower = [[data objectForKey:k_NUM_FLOWER] longLongValue];
        _message = [json objectForKey:k_MESSAGE];
    }
    return self;
}


@end
