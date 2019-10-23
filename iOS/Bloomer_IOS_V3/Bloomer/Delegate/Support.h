//
//  Support.h
//  Bloomer
//
//  Created by VanLuu on 8/4/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonCrypto.h>
//#import "NSData+Base64.h"
#import "APIDefine.h"

#import "ErrorMessageView.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_IPHONE_4 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 480.0f)
#define IS_IPHONE_X (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 812.0f)
#define IS_IPHONE_PLUS (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0f)
#define IS_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0f)

// SWICH CASE FOR NSSTRING
#define CASE(str)                       if ([__s__ isEqualToString:(str)])
#define SWITCH(s)                       for (NSString *__s__ = (s); ; )
#define DEFAULT

//FONT
#define DEFAULT_FONT_NAME @"SourceSansPro-Light"
#define DEFAULT_FONT_SIZE 14
#define TITLE_FONT_NAME @"SourceSansPro-Regular"
#define TITLE_FONT_SIZE 16
#define SFUIDisplay_Semibold @"SFUIDisplay-Semibold"
#define SFUIDisplay_Regular @"SFUIDisplay-Regular"

//THANK YOU POPUP
#define THANK_YOU_FONT_SIZE 18
#define THANK_YOU_SMILE_FONT_SIZE 40
#define THANK_YOU_CONTENT NSLocalizedString(@"Chat.popup.thankyou", nil)
#define THANK_YOU_SMILE_CONTENT @"😍"
#define THANK_YOU_COLLECTION_CELL_CONTENT NSLocalizedString(@"userprofile.thankYou.popup",nil)

// FLower button - Navigation bar
#define FIRST_FLOWER_BUTTON_VALUE 1
#define SECOND_FLOWER_BUTTON_VALUE 10
#define THIRD_FLOWER_BUTTON_VALUE 100
#define NAVIGATION_TITLE_FONT_SIZE 18
#define NAVIGATION_TITLE_FONT_NAME @"SFProText-Medium"
#define BIG_FlOWER_ICON_NAME @"Btn_Flowers_Normal_WhileHolding.png"
#define NOTIFICATION_PULL_DURATION 30
#define ERROR_MESSAGE_DURATION 2
#define DELTA_IPHONE_4 88

//EDITTING ACCOUNT INFO
#define REGEX_PASSWORD @"^(?=.{10,})(?=.*[0-9])(?=.*[a-zA-Z])([@#$%^&=a-zA-Z0-9_-]+)$"
#define REGEX_PASSWORD_MSG @""
#define REGEX_DISPLAY_NAME @""
#define REGEX_DISPLAY_NAME_MSG @"Display name is invalid."
#define REGEX_ID_NAME @"[A-Za-z0-9._-]{1,20}"
#define REGEX_ID_NAME_MSG @"Only alpha numeric characters are allowed and limit 1-20"
#define REGEX_EMAIL @"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+.[a-zA-Z]{2,4}$"
#define REGEX_EMAIL_MSG @"Enter valid email."
#define REGEX_MOBILE @"[0-9]{9,11}"
#define REGEX_MOBILE_MSG @"Wrong format phone number."

//RACE view
#define OBJECT_WIDTH 80.0f
#define OBJECT_HEIGHT 80.0f
#define MARGIN_VERTICAL 0.0f
#define MARGIN_HORIZONTAL 0.0f
#define DRAGGABLE_LOCATION_WIDTH  ((OBJECT_WIDTH  * 3) + (MARGIN_HORIZONTAL * 5))
#define DRAGGABLE_LOCATION_HEIGHT ((OBJECT_HEIGHT * 3) + (MARGIN_VERTICAL   * 5))

#define WIDTH_SCREEN [[UIScreen mainScreen] bounds].size.width
#define HEIGHT_SCREEN [[UIScreen mainScreen] bounds].size.height

@interface Support : NSObject

//#define USE_EARLY_ACCESS_CODE
typedef enum AUTHENTYPE{
    Via_FACEBOOK=0,
    Via_PHONENUMBER=1,

} AUTHENTYPE;

enum {
    FEMALE=0,
    MALE=1,
    BOTH_FEMALE_MALE=2
};
typedef NSUInteger GENDER;

typedef enum RaceJoined {
    RACE_NOT_ALLOW_TO_JOIN=0,
    RACE_NOT_JOINED=1,
    RACE_JOINED=2
} RaceJoined;

typedef enum RaceStatus {
    RACE_ACTIVE=1,
    RACE_LEFT=2,
    RACE_CLOSED=3
} RaceStatus;

typedef enum RaceCategory {
    RACECATEGORY_COUNTRY=1,
    RACECATEGORY_LOCATION=2,
    RACECATEGORY_SPECIALTY=3,
    RACECATEGORY_SPONSOR=4,
    RACECATEGORY_EVENT=5
    //    RACECATEGORY_OTHER > 2 : THEMES
} RaceCategory;

typedef enum SeeNewUpdates {
    NO_NEW_UPDATES = 0,
    HAS_NEW_UPDATES = 1
} SeeNewUpdates;

typedef enum ThankYouStyle {
    ThankYouStyleForTableViewCell = 0,
    ThankYouStyleForCollectionViewCell = 1,
    ThankYouStyleForProfile = 2,
    ThankYouStyleForBloomerProfile = 3,
    ThankYouStyleForTopBloomerProfile = 4,
} ThankYouStyle;

typedef enum NotificationType {
    NOTIFICATION_DEFAULT_NULL,
    NOTIFICATION_TYPE_FLOWER_PHOTO,
    NOTIFICATION_TYPE_FLOWER_RACE,
    NOTIFICATION_TYPE_FLOWER_AVATAR,
    NOTIFICATION_TYPE_FLOWER_DAILY,
    NOTIFICATION_TYPE_COMMENT,
    NOTIFICATION_TYPE_TOP_RANK,
    NOTIFICATION_TYPE_SPECIAL_RACE_OPENED,
    NOTIFICATION_TYPE_EVENT_RACE_OPENED,
    NOTIFICATION_TYPE_MONTHLY_CLOSED_1DAY,
    NOTIFICATION_TYPE_SPONSOR_RACE_OPENED,
    NOTIFICATION_TYPE_UNLOCK_CHAT,
    NOTIFICATION_TYPE_LEADERBOARD_RESULT,
    NOTIFICATION_TYPE_TOP_COUNTRY,
    NOTIFICATION_TYPE_WELCOME_GSB,
    NOTIFICATION_TYPE_INVITEE_RECEIVE_FLOWER,
    NOTIFICATION_TYPE_INVITER_RECEIVE_FLOWER,
    NOTIFICATION_TYPE_SHARE,
    NOTIFICATION_TYPE_PAYMENT,
    NOTIFICATION_TYPE_NORMAL_MARKET
} NotificationType;

typedef enum TutorialType {
    Leaderboard,
    MyBloomer,
    OtherProfile,
    Discovery
} TutorialType;

+ (NSString *)suffixForRank:(NSInteger)rank;
+(UILabel*) formatLabel:(UILabel*)label raceName:(NSString*)name status:(NSInteger)status;
+ (float)calculateLabelHeight:(NSString*)text font:(UIFont*)font lineBreakMode:(NSLineBreakMode)mode;
+ (float)calculateLabelHeight:(NSString*)text font:(UIFont*)font lineBreakMode:(NSLineBreakMode)mode maxWidth:(float)maxWidth;
+(UIView*) createErrorMessageWith:(NSString*)content target:(id)target;
+(void) addErrorMessage:(NSString*) error intoView:(UIView*)view;
@end
