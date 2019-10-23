//
//  APIDefine.h
//  Xinh
//
//  Created by Nguyen Thanh Tu on 12/23/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "RequestURL.h"

typedef NS_ENUM(NSUInteger, Environment) {
    DEVELOPMENT,
    STAGING,
    LIVE,
};

#define LOAD_GALLERY_MIN_LIMIT 2 //index
#define LOAD_GALLERY_MAX_LIMIT 20 //index

#define FLOWERBUY 0.99

#pragma mark - COMMON
#define k_ACCESS_TOKEN @"access_token"
#define k_DEVICE_TOKEN @"device_id"
#define k_USER @"user"
#define k_UID @"uid"
#define k_AVATAR @"avatar"
#define k_AVATARS @"avatars"
#define k_STATUS @"status"
#define k_NAME @"name"
#define k_NUM_FLOWER @"num_flower"
#define k_INVITE_NOTICE @"notice"
#define k_NUMBER_FLOWER @"number_flower"
#define k_INVITE_FLOWER @"invite_flower"
#define k_RANK @"rank"
#define k_RANK_ON_RACE @"rank_onrace"
#define k_ @""
#define k_NUMBER_CHATTING @"number_chatting"
#define k_VERSION @"version"
#define k_ACTIVE @"active"

// MARK: - RACE LIST
#define k_ACTIVED_RACES @"actived_races"
#define k_JOINED_RACES @"race_joined"

#define k_IS_JOINED @"isJoin"
#define k_KEY @"key"
#define k_CKEY @"ckey"
#define k_START @"start"
#define k_END @"end"
#define k_DATE_START @"dateStart"
#define k_DATE_END @"dateEnd"
#define k_CONTENT @"content"
#define k_RACE_INFO @"race_info"
#define k_JOIN_INFO @"join_info"
#define k_LEAVE_INFO @"leave_info"
#define k_CLOSED_URL @"url_closedrace"
#define k_CATEGORY_NAME @"category_name"
#define k_CHILDS @"childs"
#define k_CHILD @"child"
#define k_IS_ACTIVE @"isActive"
#define k_IS_CLOSED @"isClosed"
#define k_IS_FOLLOW @"is_follow"
#define k_IS_UNFOLLOW @"isUnfollow"
#define k_IS_ALBUM @"is_album"
#define k_IS_SHARE @"is_share"
#define k_IS_MULTI @"isMulti"
#define k_RULES @"rules"
#define k_CATEGORY @"category"
#define k_COUNTRY_AVATAR @"country_avatar"
#define k_IS_NEW @"isNew"

#pragma mark - JOIN/LEAVE RACE CONFIRM
#define k_iRACE_JOINED @"irace_joined"
#define k_IS_JOIN @"is_join"
#define k_IS_LEAVE @"is_leave"
#define k_iRACE_NEW @"irace_new"
#define k_iRACE @"irace"
#define k_LATITUDE @"lat"
#define k_LONGITUDE @"long"

#pragma mark - LOCATION
#define k_CITY @"city"
#define k_CITY_NAME @"city_name"
#define k_CITIES @"cities"
#define k_CITY_ID @"city_id"
#define k_CITY_SHORT_NAME @"city_short_name"

// MARK: - RACE INFO
#define k_RACE_NAME @"race_name"
#define k_RACE_NAMES @"race_names"
#define k_RACENAMES @"racenames"
#define k_RACE_CLOSED_NAME @"closed_race_name"
#define k_CODE @"code"
#define k_IS_RANK @"isRank"
#define k_COLOR_RANK @"color_race"
#define k_IS_COMMING @"isComming"
#define k_DESCRIPTION @"description"
#define k_ISJOIN @"isJoin"
#define k_IS_SHOW_JOIN @"isShowJoin"
#define k_TYPE_ID @"type_id"
#define k_TYPE_NAME @"type_name"
#define k_ICON_RACE @"icon_race"
#define k_BANNER @"banners"
#define k_BANNERS @"banners"
#define k_GALLERY @"gallery"
#define k_LOGO @"logo"
#define k_MY_RANK @"myrank"

// MARK: - RACE SEARCH
#define k_USERS @"users"
#define k_RACES @"races"
#define k_RACE @"race"
#define k_STATUS_RANK @"status_of_rank"
#define k_COLOR_CODE @"color_code"

#pragma mark - AUTHORIZE
#define k_CREDENTIAL @"credential"
#define k_SECRET_CLIENT @"secret_client"
#define k_APP_ID @"app_id"
#define k_COUNTRY_ID @"country_id"
#define k_SCREEN_NAME @"screen_name"
#define k_FLOWER @"flower"
#define k_TOTAL_FLOWER @"total_flower"
#define k_MODEL_ID @"model_id"
#define k_FLOWERS @"flowers"
#define k_GENDER @"gender"
#define k_AUTH @"auth"
#define k_OAUTH @"oauth"
#define k_EXPIRED_TIME @"expire_time"
#define k_IS_EXPIRED @"is_expired"
#define k_REFRESH_TOKEN @"refresh_token"
#define k_IS_REFRESH @"is_refresh"
#define k_SCROLL @"scroll"
#define k_CRIDENTIAL_EJAB @"cridential_ejab"
#define k_VERIFIED @"verified"
#define k_MSG @"msg"
#define kNameError @"name_error"
#define kPhoneError @"phone_error"
#define kEmailError @"email_error"
#define k_Block_Msg @"block_msg"
#define k_MSGS @"msgs"
#define k_LOCATION_ID @"location_id"
#define k_LOCATION_NAME @"location_name"
#define k_BIRTHDAY @"birthday"
#define k_M_ID @"m_id"
#define k_MID @"mid"
#define k_NOTIFICATION_TOKEN @"notification_token"
#define k_FBTOKEN @"fb_token"
#define k_FBMOBILE @"fb_mobile"

#pragma mark - PHOTO
#define k_PHOTO @"photo"
#define k_PHOTOS @"photos"
#define k_PHOTO_ID @"photo_id"
#define k_PHOTO_URL @"photo_url"
#define k_PHOTO_URL_FULL @"photo_url_full"
#define k_IS_CROP @"isCrop"
#define k_P_LARGE @"plarge"
#define k_P_COVER @"pcover"
#define k_X @"x"
#define k_Y @"y"
#define k_WSCREEN @"wscreen"
#define k_ROOM_ID_NOTI @"roomId"

// MARK: - VIDEO
#define k_VIDEO @"video"
#define k_VIDEOLINK @"video_link"

#pragma mark - BLOCK
#define k_BLOCKERS @"blockers"

#pragma mark - COMMENT
#define k_COMMENT_ID @"comment_id"
#define k_COMMENT_CONTENT @"__content"
#define k_COMMENT_TIME @"__time_comment"
#define k_COMMENT_WHO @"__who_comment"
#define k_COMMENTS @"comments"
#define k_COMMENT @"comment"
#define k_FINAL_COMMEMT @"isFinal"


#pragma mark - POST
#define k_NUM_GIVER @"num_giver"
#define k_ACCOUNT @"account"
#define k_POST @"post"
#define k_POSTS @"posts"
#define k_CAPTION @"caption"
#define k_TAGS @"tags"
#define  k_PAYLOAD @"payload"
#define k_DISCOVERIES @"discoveries"
#define k_DISCOVERY_RESULT @"search_result"
#define k_IS_AVATAR @"is_avatar"
#define k_SIZE @"size"
#define K_PAGE @"page"
#define  k_LIST @"list"
#define k_CMIN @"cmin"
#define k_CMAX @"cmax"
#define k_MIN @"min"
#define k_MAX @"max"
#define k_OrderBy @"order_by"

#pragma mark - FACE
#define k_TIMESTAMP @"timestamp"
#define k_URI_PHOTO @"uri_photo"
#define k_POST_ID @"post_id"
#define k_FEED_ID @"feed_id"
#define k_FEEDS @"feeds"
#define k_FEED @"feed"
#define k_RACEKEY @"racekey"
#define k_RACE_KEY @"race_key"
#define K_NOTI_KEY @"noti_key"
#define k_WINNERS @"winners"
#define k_TOTAL_POST @"total_post"
#define k_URL_RACE_CLOSE @"url_race_close"

#pragma mark - GIVING FLOWER
#define k_RECEIVER @"receiver"
#define k_IS_FAV @"isFav"
#define k_MY_NUMBER_FLOWER @"my_nflower"
#define k_IS_CHAT @"is_chat"
#define k_MODEL_NUMBER_FLOWER @"model_nflower"
#define k_GIVERS @"givers"
#define k_MODEL @"model"
#define k_GIVEN @"given"
#define k_MFLOWER @"mflower"
#define k_FLOWER_MODEL @"flower_model"
#define k_FLOWER_ONPOST @"flower_onpost"

#pragma mark - FORGET PASSWORD
#define k_FIELD @"field"
#define k_COUNTRY_ID @"country_id"
#define k_VOICE @"voice"
#define k_F_ID @"f_id"
#define k_ACTIVE_CODE @"active_code"

#pragma mar - MESSAGE
#define k_AUTH_SESSION @"auth_session"
#define k_PAYLOAD @"payload"
#define k_ALERT @"alert"
#define k_REDIRECT_URI @"redirect_uri"
#define k_MESSAGES_READ @"messages_read"
#define k_NOTIFICATION @"notification"
#define k_MESSAGE_ID @"message_id"
#define k_RESOURCE @"resource"
#define k_SENDER @"sender"
#define k_BODY @"body"
#define k_TIMESTAMP_RELATIVE @"timestamp_relative"
#define k_READ @"read"
#define k_ROOM_ID @"room_id"
#define k_SENT @"sent"
#define k_SENDER_ID @"sender_id"
#define k_MESSAGE @"message"
#define k_MESSAGES @"messages"
#define k_REV @"rev"
#define k_IS_CONNECTED @"isConnected"
#define k_ROOMS @"rooms"
#define k_IS_ONLINE @"is_online"
#define k_IS_BLOCK @"is_block"
#define k_BLOCK @"block"
#define k_BLOCKER @"blocker"
#define k_ROSTERS @"rosters"
#define k_ROSTER_ID @"roster_id"
#define k_JUST_UNBLOCK_CHAT @"justunlock_chat"

#pragma mark - NOTIFITCATION
#define k_NOTIFICATION_ID @"notification_id"
#define k_TYPE @"type"
#define k_ID @"id"
#define k_USER_ID @"user_id"
#define k_TOTAL @"total"
#define k_IS_FRESH_RACE @"isFreshRace"
#define k_POP_UP @"popup"
#define k_FACES @"faces"
#define k_CONTENT_POST @"content_post"
#define k_CONTENT_TYPE @"content_type"
#define k_CONTENT_ID @"content_id"
#define k_STATE @"state"
#define k_SUCKER @"sucker"
#define k_NOTIFICATION_KEY @"noti_key"

#define k_COMMENTER_AVATAR @"commenter_avatar"
#define k_COMMENTER_NAME @"commenter_name"
#define k_NUMBER_PEOPLE @"number_people"
#define k_ISGROUP @"isGroup"
#define k_GIVER_AVATAR @"giver_avatar"
#define k_GIVER_NAME @"giver_name"
#define k_GIVER_ID @"giver_id"
#define k_TOP_ID @"top_id"
#define k_TOP @"top"
#define k_MODEL_NAME @"model_name"
#define k_MODEL_AVATAR @"model_avatar"
#define k_MONTHLY_TIME @"monthly_time"
#define K_RESULT_LINK @"result_link"
#define k_ISME @"isMe"
#define k_POSTER_NAME @"poster_name"
#define K_INVITEE_AVATAR @"inviteeAvatar"
#define K_INVITEE_ID @"inviteeId"

#pragma mark - PAYMENT
#define k_TRANSACTION @"transaction"
#define k_TRANSACTION_IDENTIFIER @"transactionIdentifier"
#define k_PRODUCT_IDENTIFIER @"productIdentifier"
#define k_PRODUCT_DESC @"description"
#define k_TRANSACTION_DATE @"transactionDate"
#define k_RECEIPT_DATA @"receipt_data"
#define k_TRANSACTION_FAIL @"transactionFailBy"
#define k_TRANSACTION_IDENTIFIER_STORE @"transactionIdentifierStore"
#define k_PAYMENTS @"payments"
#define k_MONEY @"money"
#define k_PAYMENT_ID @"payment_id"
#define K_PAYMENT_IS_EVENT @"event_active"
#define K_PAYMENT_TITLE_EVENT @"event.title"
#define K_PAYMENT_NOTI_EVENT @"event.pinned.noti"
#define K_PAYMENT_PERCENT_BONUS @"event_bonus"

#pragma mark - CHAT
#define k_REMAIN_FLOWER @"remain_flower"
#define k_BLOCKID @"block_id"
#define k_CMD @"cmd"
#define k_Data @"data"
#define k_Success @"success"


#pragma mark - PROFILE
#define k_PROFILE @"profile"
#define k_ABOUT @"about"
#define k_FOLLOWER @"follower"
#define k_FOLLOWERS @"followers"
#define k_FOLLOWINGS @"followings"
#define k_FOLLOWING @"following"
#define k_LOCATION @"location"
#define k_MO_COLOR @"mocolor"
#define k_MOCODE @"mocode"
#define k_MOCODE_UPPER_C @"moCode"
#define k_SPCODE @"spcode"
#define k_SPCODE_UPPER_C @"spCode"
#define k_RECEIVED_FLOWER @"received_flower"
#define k_TOTAL_RECEIVED_FLOWER @"total_received_flower"
#define k_SP_COLOR @"spcolor"
#define k_M_COLOR @"mcolor"
#define k_USERNAME @"username"
#define k_COUNTRY @"country"
#define k_COUNTRY_CODE @"country_code"
#define k_COUNTRY_NAME @"country_name"
#define k_COUNTRY_SHORT_NAME @"country_short_name"
#define k_ABOUT_ME @"about_me"
#define k_ABOUT_ME2 @"aboutme"
#define k_THANKS @"thanks"
#define k_EMAIL @"email"
#define k_VERIFIED_EMAIL @"verified_email"
#define k_CHATTING @"chatting"
#define k_MOBILE @"mobile"
#define k_MOBILE_FULL @"mobile_full"
#define k_LIVING_IN @"living_in"
#define k_ACTIVE_RANKS @"active_ranks"
#define k_HISTORY_RANKS @"history_rank"
#define k_ACHIVEMENTS @"achivements"
#define k_CHILDS @"childs"
#define k_ISCHILD @"isChild"
#define k_HRANK @"hRank"
#define k_DATE_CLOSED @"date_closed"
#define k_REGIONS @"regions"
#define k_IS_ACTIVE_PROFILE @"isActiveProfile"
#define k_SPONSORS @"sponsors"
#define k_IS_DEL @"isDel"
#define k_GALLERIES @"galleries"
#define k_ALLOW_SHARE @"allow_share"
#define k_IS_FINAL @"isFinal"
#define k_INVITE_CODE @"invite_code"
#define k_MYGIVEFLOWER @"mygiveflower"
#define k_VIDEO @"video"
#define k_VIDEOLINK @"video_link"
#define k_GIFTLINK @"gift"
#define k_TIME @"time"
#define k_X1 @"x1"
#define k_Y1 @"y1"
#define k_X2 @"x2"
#define k_Y2 @"y2"
#define k_SORT @"st"
#define k_INDEX @"index"
#define kMatchingFlower @"matching_flower"
#define k_UNKNOWN_LOCATION @"unknow"

// MARK: - DISCOVERY
#define k_TERMSEARCH @"term_search"
#define k_LIMIT @"limit"

#pragma mark - POPUP_WINNER
#define K_URL @"url"
#define K_POSITION @"position"
#define K_POPUPS @"popups"

// MARK: - GSB
#define k_GSB @"gsb"
#define k_GSB_MEDAL @"gsb_medal"
#define k_WINNERS @"winners"
#define k_TERM @"term"


#pragma mark - FACTORY PROTOCOL
#define k_TY @"__ty"
#define k_Chat_Message_ID @"mid"
#define k_UPLOAD @"upl"

// MARK: - GSB
#define k_GSB_MEDAL @"gsb_medal"

// HEADERS
#define h_AUTHENTICATION @"Authentication"

// METHOD
#define m_GET @"GET"
#define m_POST @"POST"
#define m_DELETE @"DELETE"
#define m_HEAD @"HEAD"
#define m_PUT @"PUT"

//LINKS
#define l_PAYMENT @"en/store/"
#define l_FAQ @"faq/"
#define l_WEBSITE @"en/"

#define l_FACEBOOK @"https://www.facebook.com/bloomerapp"


#define e_SUPPORT @"support@bloomerapp.com"

@interface APIDefine : NSObject
//ENVIROMENT
+(Environment)getEnvironment;
//MARK: - HOST
+(NSString *)getrootURL;
+(NSString *)getrootWebURL;
//+(NSString *)getMessageRootURL;
+(NSString *)getChatRootURL;
+(NSString *)getPhotoRootURL;

//MARK: - URL
+(NSString *)shareInviteCodeLink;

+ (RequestURL *)auth_registerLink;
+ (RequestURL *)auth_authorizeLink;
+ (RequestURL *)auth_logoutLink;

+ (RequestURL *)race_fetchesLink;
+ (RequestURL *)getRaceList;
+ (RequestURL *)races_surprise_fetechesLink;
+ (RequestURL *)races_MyRank_fetchesLink;
+ (RequestURL *)race_favourites_oneLink;
+ (RequestURL *)race_name_fetchLink;
+ (RequestURL *)race_banner_fetchesLink;
+ (RequestURL *)race_gallery_fetchesLink;
+ (RequestURL *)races_search_fetchesLink;

+ (RequestURL *)user_feed_fetchesLink;
+ (RequestURL *)race_feed_fetchesLink;
+ (RequestURL *)access_codeLink;

+ (RequestURL *)discovery_fetchesLink;
+ (RequestURL *)discovery_searchLink;
+ (RequestURL *)post_user_fetchesLink;
+ (RequestURL *)get_FeedLink;

+ (RequestURL *)post_createLink;
+ (RequestURL *)post_fetch_postsLink;
+(RequestURL *)post_fetch_posts_userLink;
+ (RequestURL *)post_fetch_a_postLink;
+(RequestURL *)post_commentLink;
+(RequestURL *)post_comments_fetchLink;
+ (RequestURL *)post_followers_fetchLink;

+ (RequestURL *)auth_checkMobileLinkFacebook;
+ (RequestURL *)profile_updateLink;
+ (RequestURL *)profile_update_about_meLink;
+ (RequestURL *)profile_New_fetchLink;
+ (RequestURL *)profile_meLink;
+ (RequestURL *)profile_settingLink;
+(RequestURL *)isChat_fetchLink;
+ (RequestURL *)profile_bannerLink;
+(RequestURL *)profile_galleryLink;
+ (RequestURL *)profile_avatarsLink;
+(RequestURL *)profile_post_galleryLink;
+(RequestURL *)content_post_fetchesLink;
+ (RequestURL *)profile_postLink;
+ (RequestURL *)profile_bannerAddLink;
+ (RequestURL *)profile_nameLink;
+ (RequestURL *)profile_usernameLink;
+ (RequestURL *)profile_statusLink;
+ (RequestURL *)profile_locationLink;
+ (RequestURL *)profile_passwordLink;
+ (RequestURL *)profile_set_PasswordLink;
+ (RequestURL *)profile_genderLink;
+ (RequestURL *)profile_followerLink;
+ (RequestURL *)profile_followingLink;
+ (RequestURL *)profile_updateBirthday;

+ (RequestURL *)profile_searchFllower;
+ (RequestURL *)profile_searchFllowing;

+ (RequestURL *)profile_setting_fetchesLink;
+ (RequestURL *)profile_mobileLink;
+ (RequestURL *)profile_emailLink;
+ (RequestURL *)profile_addLocation;
+ (RequestURL *)profile_checkPasswordLink;
+ (RequestURL *)profile_checkPassUser;
+ (RequestURL *)profile_mobileVerifyLink;
+ (RequestURL *)post_captionLink;
+ (RequestURL *)profile_privateShareLink;
+ (RequestURL *)profile_fetchBlockerLink;
//+ (RequestURL *)profile_Block_Link;
+ (RequestURL *)profile_Block_Link;
//+ (RequestURL *)profile_Block_newLink;
+ (RequestURL *)profile_unBlock_newLink;
+ (RequestURL *)profile_notiSettingLink;
+ (RequestURL *)profile_unFollowLink;
+ (RequestURL *)profile_reFollowLink;

+ (RequestURL *)flower_giveLink;
+ (RequestURL *)flower_give_profileLink;
+ (RequestURL *)flower_give_postLink;
+ (RequestURL *)sponsor_fetchLink;
+ (RequestURL *)sponsor_post_fetchLink;
+ (RequestURL *)reason_fetchLink;
+ (RequestURL *)reportLink;
+ (RequestURL *)reportUserLink;
+ (RequestURL *)flower_givingPopupLink;

+ (RequestURL *)avatar_attachedLink;
+ (RequestURL *)avatar_race_attchedLink;
+(NSString *)hImageLink;
+(NSString *)hProfileLink;
//+(NSString *)photoLoadLink;
+(RequestURL *)payment_buyLink;
+(RequestURL *)galleriesLoadLink;

+ (RequestURL *)message_connectLink;
+ (RequestURL *)message_pull_roomLink;
+ (RequestURL *)message_pull_rosterLink;
+ (RequestURL *)message_presence_roomLink;
+ (RequestURL *)message_presence_rosterLink;
+ (RequestURL *)message_sendLink;
+ (RequestURL *)message_disconnectLink;

+ (RequestURL*)rooms_fetchLink;
+ (RequestURL*)room_delete;
+ (RequestURL*)room_read;

+ (RequestURL *) auth_sendcodeLink;
//Deprecated
+ (RequestURL *) auth_registerInfoLink;
+ (RequestURL*)auth_register_sendcodeLink;
+ (RequestURL*) auth_resendcodeLink;
+ (RequestURL *)auth_resendcodeLoginLink;
+ (RequestURL *)auth_resendcodeUpdateLink;
+ (RequestURL *)auth_register_callsupportlink;
+ (RequestURL*)auth_register_verifycodeLink;
+ (RequestURL*)auth_checkpasswordLink;

+ (RequestURL*)account_forget_whoLink;
+ (RequestURL *)account_forget_voicecall;
+ (RequestURL*)account_forget_verifycodeLink;
+ (RequestURL*)account_forget_changepassLink;

//+ (NSString*)photo_limit_attachedLink;

//+ (NSString*)race_fetches_byme_scrollLink;
//+ (NSString*)race_fetches_bymeLink;
//+ (NSString*)rank_historyLink;
+ (RequestURL *)new_rank_active_history;
+ (RequestURL *)new_rank_closed_history;
+ (RequestURL *)race_tag_fetchLink;

+ (RequestURL*)notification_pullLink;
+ (RequestURL*)setting_chatupdateLink;
+ (RequestURL*)notification_fetchLink;
+ (RequestURL*)notification_getListUser;

//+ (NSString*)favourite_addLink;
+ (RequestURL*)auth_expiredLink;

+ (RequestURL*)refresh_tokenLink;
//+ (NSString*)user_searchLink;

//+ (NSString*)favourite_removeLink;

//+ (NSString*)block_addLink;
//+ (NSString*)block_removeLink;
+ (RequestURL*)block_fetchLink;

//+ (NSString*)covers_loadLink;
//+ (NSString*)photo_cover_cropLink;
+ (RequestURL*)post_comment_deleteLink;
+ (RequestURL*)post_deleteLink;
+ (RequestURL*)post_edit_captionLink;

//+ (NSString*)race_searchLink;

//+ (NSString*)people_randomLink;
+ (RequestURL*)profile_change_genderLink;

+ (RequestURL*)regions_fetchLink;
+ (RequestURL *)covers_addLink;

+ (RequestURL*)payment_packageLink;
+ (RequestURL*)transaction_checkLink;

+ (RequestURL *)joinrace_link;
+ (RequestURL *)checkjoinedrace_link;
+ (RequestURL *)leaverace_link;
//+ (NSString*)raceinfo_link;
//+ (NSString*)location_fetchLink;
+ (RequestURL*)location_loadLink;
//+ (NSString*)join_race_confirmLink;

+ (NSString*)termsOfUseLink;
+ (NSString*)privacyPolicyLink;

+ (RequestURL*)shareFacebookLink;
+ (RequestURL*)suggestedListLink;
+ (RequestURL*)verifyInviteCodeLink;

//Tu Le: api get current
+ (RequestURL *)getVersionLink;

//Tu L: Add new chat block api
+ (RequestURL*)blockChat_addLink;
+ (RequestURL*)blockChat_removeLink;
//+ (NSString*)blockChat_loadLink;

+ (RequestURL*)user_race_posts_link;
+ (RequestURL*)getPopupMarketingLink;
//+ (NSString*)popup_marketing_link;

+ (RequestURL*)getNotiMarketing;
//+ (NSString*)noti_marketing_link;

+ (RequestURL *)anonymous_load_location_racesLink;
+ (RequestURL *)anonymous_discovery_fetchesLink;
+ (RequestURL *)anonymous_discovery_searchLink;

+ (RequestURL*)getAnonymousRaceList;
+ (RequestURL*)anonymous_feedLink;
+ (RequestURL*)anonymous_feed_race_closedLink;
+ (RequestURL*)deletePopupNoti;

+ (RequestURL *)anonymous_race_name_fetchesLink;
+ (RequestURL *)anonymous_race_fetchesLink;
+ (RequestURL *)anonymous_races_surprise_fetchesLink;
+ (RequestURL *)anonymous_race_banner_fetchesLink;

+ (RequestURL *)anonymous_profile_bannerLink;
+ (RequestURL *)anonymous_profile_New_fetchLink;
+ (RequestURL *)anonymous_profile_galleryLink;
+ (RequestURL *)anonymous_profile_post_galleryLink;
//+ (NSString*)anonymous_user_race_posts_link;

+ (RequestURL*)getBannerMarketing;
+ (RequestURL*)getAnonymousBannerMarketing;

+ (RequestURL*)getInviteCodeLink;
+ (RequestURL*)getTopWinnersLink;
+ (RequestURL*)getRaceMoreScrollLink;

//GSB
+ (RequestURL*)getPopupMembership;
+ (RequestURL*)getRewardMembership;
+ (NSString*)infoGSB;
+ (NSString*)benefitsGSB;

+ (RequestURL*)loadPhoto;
+ (RequestURL *)getClubWinnersFetchLink;
+ (RequestURL *)getClubWinnersSearchLink;
+ (RequestURL*)CheckPhoneExistLink;
+ (RequestURL*)ShareTopWinner;

#pragma mark FB
+ (RequestURL*)FBCheckExistLink;
+ (RequestURL*)FBSendCodeLink;
+ (RequestURL*)FBVerifyCodeLink;
+ (RequestURL*)FBRegisterLink;
+ (RequestURL*)FBAuthenticationLink;
+ (RequestURL *) AuthorizeByPassLink;
+ (RequestURL *)AuthorizeByCodeLink;
+ (RequestURL*)getCountriesLink;

//MARK:- WEB_SOCKET
+ (NSString *) hostSocket;
+ (NSString *) authenticateEvent;
+ (NSString *) sendMessageEvent;
+ (NSString *) sendMessageResponse;
+ (NSString *) receiveMessageEvent;
+ (NSString *) messageHistoryRequest;
+ (NSString *) messageHistoryResponse;
+ (NSString *) blockChatRequest;
+ (NSString *) blockChatResponse;
+ (NSString *) unBlockChatRequest;
+ (NSString *) unBlockChatResponse;
+ (NSString *) messageHistoryResponse;
+ (NSString *) errorEvent;
+ (NSString *) authenEvent;

@end
