//
//  UserDefaultManager.h
//  Xinh
//
//  Created by Truong Thuan Tai on 12/15/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "out_auth_authorize.h"
#import "out_auth_logout.h"
#import "out_profile_fetch.h"
#import "out_profile_update.h"
//#import "notification_pull_using.h"
#import <CommonCrypto/CommonCrypto.h>
//#import "NSData+Base64.h"
#import "region.h"
#import "Support.h"
#import "city.h"

//#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
//#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
//#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
//#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
//#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


@interface UserDefaultManager : NSObject
- (void) saveAccessToken:(NSString*)accessToken;
- (NSString*) getAccessToken;
- (void) removeAccessToken;
- (void) saveUserProfileData:(out_profile_fetch*)profileData;
- (out_profile_fetch*) getUserProfileData;
- (void) saveFace:(NSMutableArray*)faceData;
- (NSMutableArray*) getFace;
- (void) savePostID:(NSString*)postID;
- (NSString*) getPostID;
- (void) saveDeviceToken:(NSString*)deviceToken;
- (NSString *) getDeviceToken;
- (void) saveNotificationName:(NSString*)name message:(NSString *)mess photo:(NSString*) image;
- (void) removeNotification;
- (NSString*) getNameNotify;
- (NSString*) getMessageNotify;
- (NSString*) getPhotoNotify;
- (NSInteger)getNotificationNumber;
- (void)saveNotificationNumber:(NSInteger)num;
- (NSInteger)getChatNotificationNumber;
- (void)saveChatNotificationNumber:(NSInteger)num;
- (void) saveImageList:(NSMutableArray*)imageList;
- (NSMutableArray*) getImageList;
- (NSString *) generateSecretClient;
- (NSInteger)getAppID;
- (NSString*) getAppSecret;
- (NSString*) getAppKey;
- (NSString *) encryptDESByKey:(NSString *)key data:(NSString *)value iv:(NSString*)iv;
- (NSString *) decryptDESByKey:(NSString *)key data:(NSString *)value iv:(NSString*)iv;
- (void) saveSecretClient:(NSString*)secret_client;
- (NSString*) getSecretClient;
- (void) saveCredentialEjab:(NSString*)credential_ejab;
- (NSString*) getCredentialEjab;
- (void) saveAuthSession:(NSString*)auth_session;
- (NSString*) getAuthSession;
- (void)didTutorial:(BOOL)isTutorial;
- (BOOL)isTutorial;
- (void) didTutorialGiveFlowerRace:(BOOL)isTutorial;
- (BOOL)isTutorialGiveFlowerRace;
- (void) removeSecretClient;
- (void) removeCredentialEjab;
- (void) removeAuthSession;
- (void) setIsUpdateInformation:(BOOL)isUpdate;
- (BOOL) isUpdateInformation;
- (void) removeIsUpdateInformation;
- (BOOL) checkIsUpdateInformationExisted;
- (void)saveM_ID:(NSInteger)m_id;
- (NSInteger)getM_ID;
- (void)removeM_ID;
- (UIColor *) colorFromHexString:(NSString *)hexString;
- (void) saveRefresh_Token:(NSString*)refresh_token;
- (NSString*) getRefresh_Token;
- (void) removeRefresh_Token;
- (void) saveUserPass:(NSString*)userpass;
- (NSString*) getUserPass;
- (void) saveIs_Model:(BOOL)is_model;
- (BOOL)getIs_Model;
- (void)saveIRace:(NSInteger)iRace;
- (NSInteger)getIRace;
- (void)saveRaceName:(NSString*)race_name;
- (NSString*)getRaceName;
- (BOOL)isNotification;
- (void)saveIsNotification:(BOOL)notification;
- (void)removeIsNotification;
- (void)saveUserInfo:(NSDictionary*)userInfo;
- (NSDictionary*)getUserInfo;
- (NSString*)getNotificationToken;
- (void)saveNotificationToken:(NSString*)notificationToken;

- (void)saveTransactionID:(NSString*)transactionID;
- (NSString*)getTransactionID;
- (void)saveTransactionStoreID:(NSString*)transactionStoreID;
- (NSString*)getTransactionStoreID;
- (void)saveProductID:(NSString*)productID;
- (NSString*)getProductID;
- (void)saveTransactionDate:(NSString*)transactionDate;
- (NSString*)getTransactionDate;
- (void)saveState:(NSString*)state;
- (NSString*)getState;
- (void)saveReceipt:(NSString*)receipt;
- (NSString*)getReceipt;
- (void)saveGender:(NSInteger)saveGender;
- (NSInteger)getGender;
- (void)saveChatSetting:(NSInteger)chatLimit;
- (NSInteger)getChatSetting;
- (void)savePaymenPackages:(NSMutableArray*)packagesData;
- (NSMutableArray*)getPaymenPackages;
- (void) saveIsEventPayment:(BOOL)isEvent;
- (BOOL) getIsEventPayment;
- (void) saveNotiEventContent:(NSString*)titleNoti;
- (NSString*) getNotiEventContent;
- (void) saveNotiEventPercentBonus:(NSInteger)Percent;
- (NSInteger) getNotiEventPercentBonus;

- (NSString* ) getDayChecking;
- (void) setDayChecking:(NSString * )dayOpen;

- (void)saveDiscoveryOptions:(GENDER)gender location:(city*)city;
- (NSDictionary*)getDiscoveryOptions;

- (void)saveIsPushNotificationToOtherRace:(BOOL)state;
- (BOOL)IsPushNotificationToOtherRace;
- (void)removeUserProfileData;

//Tu Le: add eventTitle
-(void)setEventTitleWithString:(NSString*)string;
-(NSString*)getEventTitle;

//Tu L: add tut seen
-(void)setSeenLeaderboardTut:(BOOL)is_seen;
-(BOOL)isSeenLeaderboardTut;
-(void)setSeenMyBloomerTut:(BOOL)is_seen;
-(BOOL)isSeenMyBloomerTut;
-(void)setSeenDiscoveryTut:(BOOL)is_seen;
-(BOOL)isSeenDiscoveryTut;
-(void)setSeenUserProfileTut:(BOOL)is_seen;
-(BOOL)isSeenUserProfileTut;

- (BOOL)isAnonymous;
- (void)setAnonymous:(BOOL)isAnonymous;
- (BOOL)didPostDailyLocalNotification;
- (void)setDidPostDailyLocalNotification:(BOOL)didPost;

- (void)setMedalKey:(NSString*)key;
- (NSString*)getMedalKey;

-(NSInteger)getCurrentRaceGsb;

-(void)setCurrentRaceGsb:(NSInteger)gsb;

-(NSString*)getDeepLinkTag;
-(void)setDeepLinkTagWithString:(NSString*)tag;

-(NSDictionary*)getDeeplinkParams;
-(void)setDeeplinkParams:(NSDictionary*)params;

-(NSString*)getNumberMobile;
-(void)setNumberMobile:(NSString*)params;

-(BOOL)isReloadDiscovery;
-(void)setReloadDiscovery:(BOOL)is_reload;

@end
