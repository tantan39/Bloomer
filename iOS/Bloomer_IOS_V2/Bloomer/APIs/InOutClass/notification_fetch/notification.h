//
//  notification.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/18/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "BaseJSON.h"
#import "APIDefine.h"
#import "Support.h"

//NOTIFICATION
#define NOTIFICATION_FLOWER_PHOTO @"noti_receive_flower_photo"
#define NOTIFICATION_FLOWER_RACE @"noti_receive_flower_ava_race"
#define NOTIFICATION_FLOWER_AVATAR @"noti_receive_flower_ava"
#define NOTIFICATION_FLOWER_DAILY @"noti_receive_daily_flower"
#define NOTIFICATION_COMMENT @"noti_receive_comment"
#define NOTIFICATION_TOP_RANK @"noti_top_rank"
#define NOTIFICATION_SPECIAL_RACE_OPENED @"noti_special_race_opened"
#define NOTIFICATION_EVENT_RACE_OPENED @"noti_event_race_opened"
#define NOTIFICATION_SPONSOR_RACE_OPENED @"noti_sponsor_race_opened"
#define NOTIFICATION_MONTHLY_CLOSED_1DAY @"noti_monthly_finish_1_day"
#define NOTIFICATION_UNLOCK_CHAT @"noti_unlock_chat_model"
#define NOTIFICATION_LEADERBOARD_RESULT @"noti_leader_board_result"
#define NOTIFICATION_TOP_COUNTRY @"noti_top_country"
#define NOTIFICATION_WELCOME_GSB @"noti_welcome_gsb"
#define NOTIFICATION_INVITEE_RECEIVE_FLOWER @"noti_invitee_receive_flower"
#define NOTIFICATION_INVITER_RECEIVE_FLOWER @"noti_inviter_receive_flower"
#define NOTIFICATION_NOTI_SHARE @"noti_share"
#define NOTIFICATION_NOTI_PAYMENT @"noti_payment"

@interface flower_photo_notication : NSObject
@property (assign, nonatomic) long long number_flower;
@property (assign, nonatomic) NSInteger number_people;
@property (strong, nonatomic) NSString* giver_avatar;
@property (strong, nonatomic) NSString* giver_name;
@property (assign, nonatomic) BOOL isGroup;
@property (strong, nonatomic) NSString* post_id;
@property (strong, nonatomic) NSString* photo_url;
@property (strong, nonatomic) NSString* message;
@property (assign, nonatomic) NSInteger uidAvatar;
@end


@interface flower_race_notication : NSObject
@property (assign, nonatomic) long long number_flower;
@property (assign, nonatomic) NSInteger number_people;
@property (strong, nonatomic) NSString* giver_avatar;
@property (strong, nonatomic) NSString* giver_name;
@property (strong, nonatomic) NSString* noti_key;
@property (assign, nonatomic) BOOL isGroup;
@property (strong, nonatomic) NSString* race_key;
@property (strong, nonatomic) NSString* race_name;
@property (strong, nonatomic) NSString* message;
@end


@interface flower_avatar_notication : NSObject
@property (assign, nonatomic) long long number_flower;
@property (assign, nonatomic) NSInteger number_people;
@property (strong, nonatomic) NSString* giver_avatar;
@property (strong, nonatomic) NSString* giver_name;
@property (assign, nonatomic) BOOL isGroup;
@property (strong, nonatomic) NSString* message;
@property (assign, nonatomic) NSInteger giver_id;
@end


@interface flower_daily_notication : NSObject
@property (assign, nonatomic) long long number_flower;
@property (strong, nonatomic) NSString* message;
@end


@interface comment_notication : NSObject
@property (assign, nonatomic) NSInteger number_people;
@property (strong, nonatomic) NSString* commenter_avatar;
@property (strong, nonatomic) NSString* commenter_name;
@property (assign, nonatomic) BOOL isGroup;
@property (strong, nonatomic) NSString* photo_url;
@property (strong, nonatomic) NSString* post_id;
@property (assign, nonatomic) BOOL isMe;
@property (strong, nonatomic) NSString* poster_name;
@property (strong, nonatomic) NSString* message;
@end

@interface top_rank_notication : NSObject
@property (strong, nonatomic) NSString* race_key;
@property (strong, nonatomic) NSString* race_name;
@property (assign, nonatomic) NSInteger topID;
@property (strong, nonatomic) NSString* message;
@end

@interface special_opened_notication : NSObject
@property (strong, nonatomic) NSString* race_key;
@property (strong, nonatomic) NSString* race_name;
@property (strong, nonatomic) NSString* message;
@end
@interface event_opened_notication : NSObject
@property (strong, nonatomic) NSString* race_key;
@property (strong, nonatomic) NSString* race_name;
@property (strong, nonatomic) NSString* message;
@end
@interface sponsor_opened_notication : NSObject
@property (strong, nonatomic) NSString* race_key;
@property (strong, nonatomic) NSString* race_name;
@property (strong, nonatomic) NSString* message;
@end

@interface monthly_closed_1day_notication : NSObject
@property (strong, nonatomic) NSString* race_key;
@property (strong, nonatomic) NSString* race_name;
@property (strong, nonatomic) NSString* message;
@end

@interface unlock_chat_notication : NSObject
@property (assign, nonatomic) NSInteger model_ID;
@property (strong, nonatomic) NSString* model_name;
@property (strong, nonatomic) NSString* model_ScreenName;
@property (strong, nonatomic) NSString* model_avatar;
@property (strong, nonatomic) NSString* message;
@end

@interface leaderboard_result_notication : NSObject
@property (strong, nonatomic) NSString* monthly_time;
@property (strong, nonatomic) NSString* result_link;
@property (strong, nonatomic) NSString* message;
@end

@interface noti_top_country : NSObject
@property (strong, nonatomic) NSString* message;
@property (strong, nonatomic) NSString* url;
@property (assign, nonatomic) BOOL is_share;
@end

@interface noti_welcome_gsb : noti_top_country
@end

@interface noti_invitee_receive_flower : NSObject
@property (strong, nonatomic) NSString* message;
@property (strong, nonatomic) NSString* avatar;
@property (assign, nonatomic) NSInteger uid;
@end

@interface noti_inviter_receive_flower : NSObject
@property (strong, nonatomic) NSString* message;
@property (strong, nonatomic) NSString* avatar;
@property (assign, nonatomic) NSInteger uid;
@end

@interface noti_share : NSObject
@property (strong, nonatomic) NSString* message;
@end

@interface noti_payment : NSObject
@property (strong, nonatomic) NSString* message;
@end

@interface default_Noti : NSObject
@property (strong, nonatomic) NSString* message;
@end

@interface normal_maketing_noti : NSObject
@property (strong, nonatomic) NSString* message;
@property (strong, nonatomic) NSString* deepLink;
@property (strong, nonatomic) NSString* startTime;
@end

@interface notification : NSObject<BaseJSON>


@property (strong, nonatomic) NSString *notification_id;
@property (assign, nonatomic) long long timestamp;
@property (assign, nonatomic) NotificationType type;
@property (assign, nonatomic) BOOL isRead;
@property (strong, nonatomic) NSString *message;

//@property (assign, nonatomic) NSInteger uid;
//@property (strong, nonatomic) NSString* screen_name;
//@property (strong, nonatomic) NSString* post_id;
//@property (strong, nonatomic) NSString* avatar;
//@property (assign, nonatomic) NSInteger irace;

//NOTIFICATION_FLOWER_PHOTO
@property (strong, nonatomic) flower_photo_notication* photoContent;
//NOTIFICATION_FLOWER_RACE
@property (strong, nonatomic) flower_race_notication* raceContent;
//NOTIFICATION_FLOWER_AVATAR
@property (strong, nonatomic) flower_avatar_notication* avatarContent;
//NOTIFICATION_FLOWER_DAILY
@property (strong, nonatomic) flower_daily_notication* dailyContent;
//NOTIFICATION_COMMENT
@property (strong, nonatomic) comment_notication* commentContent;
//NOTIFICATION_TOP_RANK
@property (strong, nonatomic) top_rank_notication* topRankContent;
//NOTIFICATION_SPECIAL_RACE_OPENED
@property (strong, nonatomic) special_opened_notication* specialContent;
//NOTIFICATION_EVENT_RACE_OPENED
@property (strong, nonatomic) event_opened_notication* eventContent;
//NOTIFICATION_SPONSOR_RACE_OPENED
@property (strong, nonatomic) sponsor_opened_notication* sponsorContent;

@property (strong, nonatomic) monthly_closed_1day_notication* monthlyContent;

@property (strong, nonatomic) unlock_chat_notication* chatContent;

@property (strong, nonatomic) leaderboard_result_notication* leadrerboardResultContent;

@property (strong, nonatomic) noti_top_country* topCountry;

@property (strong, nonatomic) noti_welcome_gsb* welcomeGSB;

@property (strong, nonatomic) noti_invitee_receive_flower* inviteeReceive;

@property (strong, nonatomic) noti_inviter_receive_flower* inviterReceive;

@property (strong, nonatomic) noti_share* shareNoti;

@property (strong, nonatomic) noti_payment* paymentNoti;

@property (strong, nonatomic) default_Noti* defaultNoti;

@property (strong, nonatomic) normal_maketing_noti* normalMaketNoti;

@end

