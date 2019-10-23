//
//  UserDefaultManager.m
//  Xinh
//
//  Created by Truong Thuan Tai on 12/15/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import "UserDefaultManager.h"

@implementation UserDefaultManager
{
    NSUserDefaults *userDefaults;
}

- (id)init {
    self = [super init];
    
    if (self) {
        userDefaults = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

- (void)saveAccessToken:(NSString*)accessToken
{
    [userDefaults setObject:accessToken forKey:k_ACCESS_TOKEN];
    [userDefaults synchronize];
}

- (NSString *)getAccessToken
{
    NSString *accessToken = [userDefaults objectForKey:k_ACCESS_TOKEN];
    
    return accessToken;
}

- (void)removeAccessToken
{
    [userDefaults removeObjectForKey:k_ACCESS_TOKEN];
    [userDefaults synchronize];
}

- (void)saveUserProfileData:(out_profile_fetch *)profileData
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:profileData];
    [userDefaults setObject:encodedObject forKey:@"profile_data"];
    [userDefaults synchronize];
    
    [self saveChatSetting:(long)profileData.number_chatting];
}

- (out_profile_fetch*)getUserProfileData
{
    NSData *decodedObject = [userDefaults objectForKey:@"profile_data"];
    out_profile_fetch *profileData = [NSKeyedUnarchiver unarchiveObjectWithData:decodedObject];
    return profileData;
}

- (void)removeUserProfileData
{
    [userDefaults removeObjectForKey:@"profile_data"];
    [userDefaults synchronize];
}

- (void)saveFace:(NSMutableArray*)faceData
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:faceData];
    [userDefaults setObject:encodedObject forKey:@"Face"];
}

- (NSMutableArray*)getFace
{
    NSData *decodedObject = [userDefaults objectForKey:@"Face"];
    NSMutableArray *data = [NSKeyedUnarchiver unarchiveObjectWithData:decodedObject];
    return data;
}

- (void)savePostID:(NSString*)postID
{
    [userDefaults setObject:postID forKey:@"PostID"];
    [userDefaults synchronize];
}

- (NSString*)getPostID
{
    return [userDefaults objectForKey:@"PostID"];
}

- (void)saveSponsorState:(NSString*)state
{
    [userDefaults setObject:state forKey:@"SponsorState"];
    [userDefaults synchronize];
}

- (NSString*)getSponsorState
{
    return [userDefaults objectForKey:@"SponsorState"];
}

- (void)saveDeviceToken:(NSString*)deviceToken
{
    [userDefaults setObject:deviceToken forKey:k_DEVICE_TOKEN ];
    [userDefaults synchronize];
}

- (void)didTutorialGiveFlowerRace:(BOOL)isTutorial
{
    [userDefaults setBool:isTutorial forKey:@"IS_TUTORIAL_GIVE_FLOWER_RACE"];
    [userDefaults synchronize];
}

- (BOOL)isTutorialGiveFlowerRace
{
    return [userDefaults boolForKey:@"IS_TUTORIAL_GIVE_FLOWER_RACE"];
}

- (NSString *) getDeviceToken
{
    return [userDefaults objectForKey:k_DEVICE_TOKEN];
}

- (NSString*)getNotificationToken
{
    NSString* notificationToken = [userDefaults objectForKey:@"notification_token"];
    return notificationToken == nil ? @"" : notificationToken;
}

- (void)saveNotificationToken:(NSString*)notificationToken
{
    notificationToken = [notificationToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    notificationToken = [notificationToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    [userDefaults setObject:notificationToken forKey:@"notification_token"];
    [userDefaults synchronize];
}

- (void)saveNotificationName:(NSString*)name message:(NSString *)mess photo:(NSString*) image
{
    [userDefaults setObject:name forKey:@"name_notify"];
    [userDefaults setObject:mess forKey:@"message_notify"];
    [userDefaults setObject:image forKey:@"image_notify"];
    
    [userDefaults synchronize];
}

- (void)removeNotification
{
    [userDefaults removeObjectForKey:@"name_notify"];
    [userDefaults removeObjectForKey:@"message_notify"];
    [userDefaults removeObjectForKey:@"image_notify"];
    
    [userDefaults synchronize];
}

- (NSString*)getNameNotify
{
    NSString* name = [userDefaults objectForKey:@"name_notify"];
    
    return name;
}

- (NSString*)getMessageNotify
{
    NSString* message = [userDefaults objectForKey:@"message_notify"];
    
    return message;
}

- (NSString*)getPhotoNotify
{
    NSString* image = [userDefaults objectForKey:@"image_notify"];
    
    return image;
}

- (NSInteger)getNotificationNumber
{
    NSInteger number = [userDefaults integerForKey:@"NotificationNumber"];
    
    return number;
}


- (void)saveNotificationNumber:(NSInteger)num
{
    [userDefaults setInteger:num forKey:@"NotificationNumber"];
    [userDefaults synchronize];
}

- (NSInteger)getChatNotificationNumber
{
    NSInteger number = [userDefaults integerForKey:@"ChatNotificationNumber"];
    
    return number;
}


- (void)saveChatNotificationNumber:(NSInteger)num
{
    [userDefaults setInteger:num forKey:@"ChatNotificationNumber"];
    [userDefaults synchronize];
}

- (void)saveImageList:(NSMutableArray*)imageList
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:imageList];
    [userDefaults setObject:encodedObject forKey:@"ImageList"];
}

- (NSMutableArray*)getImageList
{
    NSData *decodedObject = [userDefaults objectForKey:@"ImageList"];
    NSMutableArray *data = [NSKeyedUnarchiver unarchiveObjectWithData:decodedObject];
    return data;
}

- (NSString *) generateSecretClient {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: 8];
    
    for (int i = 0; i < 8; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return randomString;
}

- (NSInteger)getAppID
{
    return 2;
}

- (NSString*)getAppSecret
{
    return @"bloomios";
}

- (NSString*)getAppKey
{
    return @"bloomer452678od9m0daedcw";
}

- (NSString *)encryptDESByKey:(NSString *)key data:(NSString *)value iv:(NSString*)iv
{
    const void *vplainText;
    size_t plainTextBufferSize;
    
    plainTextBufferSize = [value length];
    vplainText = (const void *) [value UTF8String];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const unsigned char *keyString = (const unsigned char *)[key cStringUsingEncoding: NSUTF8StringEncoding];
    const unsigned char *initializeVactorString = (const unsigned char *)[iv cStringUsingEncoding: NSUTF8StringEncoding];
    
    uint8_t ivData[kCCBlockSize3DES];
    memset((void *) ivData, 0x0, (size_t) sizeof(ivData));
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       keyString,
                       kCCKeySize3DES,
                       initializeVactorString,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSString *result;
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    
    if ([myData respondsToSelector:@selector(base64EncodedStringWithOptions:)])
    {
        result = [myData base64EncodedStringWithOptions:0];  // iOS 7+
    }
    else
    {
        result = [myData base64Encoding];                              // pre iOS7
    }
    
    return result;
}

- (NSString *)decryptDESByKey:(NSString *)key data:(NSString *)value iv:(NSString*)iv
{
    const void *vplainText;
    size_t plainTextBufferSize;
    
    NSData *encryptData;
    
    if ([NSData instancesRespondToSelector:@selector(initWithBase64EncodedString:options:)])
    {
        encryptData = [[NSData alloc]initWithBase64EncodedString:value options:0];  // iOS 7+
    }
    else
    {
        encryptData = [[NSData alloc]initWithBase64Encoding:value]; // pre iOS7
    }
    
    plainTextBufferSize = [encryptData length];
    vplainText = [encryptData bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const unsigned char *keyString = (const unsigned char *)[key cStringUsingEncoding: NSUTF8StringEncoding];
    const unsigned char *initializeVactorString = (const unsigned char *)[iv cStringUsingEncoding: NSUTF8StringEncoding];
    
    uint8_t ivData[kCCBlockSize3DES];
    memset((void *) ivData, 0x0, (size_t) sizeof(ivData));
    
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       keyString,
                       kCCKeySize3DES,
                       initializeVactorString,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSString *result = [[NSString alloc] initWithData: [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes] encoding:NSASCIIStringEncoding];
    
    return result;
}

- (void)saveSecretClient:(NSString*)secret_client
{
    [userDefaults setObject:secret_client forKey:k_SECRET_CLIENT];
    [userDefaults synchronize];
}

- (NSString*)getSecretClient
{
    return [userDefaults objectForKey:k_SECRET_CLIENT];
}

- (void)saveCredentialEjab:(NSString*)credential_ejab
{
    [userDefaults setObject:credential_ejab forKey:@"credential_ejab"];
    [userDefaults synchronize];
}

- (NSInteger)getGender {
    out_profile_fetch *profileJson = [self getUserProfileData];
    
//    NSData *decodedObject = [userDefaults objectForKey:@"profile_data"];
//    out_profile_fetch *profileData = [NSKeyedUnarchiver unarchiveObjectWithData:decodedObject];
    
    return profileJson.gender;
}

- (void)saveGender:(NSInteger)saveGender {
//    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"profile_data"];
    out_profile_fetch *profileJson = [[out_profile_fetch alloc]init];
    profileJson = [self getUserProfileData];
    profileJson.gender = saveGender;
    
    [self saveUserProfileData:profileJson];
    
//    out_profile_fetch *test = [self getUserProfileData];
    
}

- (NSString*)getCredentialEjab
{
    return [userDefaults objectForKey:@"credential_ejab"];
}

- (void)saveAuthSession:(NSString*)auth_session
{
    [userDefaults setObject:auth_session forKey:k_AUTH_SESSION];
    [userDefaults synchronize];
}

- (NSString*)getAuthSession
{
    return [userDefaults objectForKey:k_AUTH_SESSION];
}

- (void)didTutorial:(BOOL)isTutorial
{
    [userDefaults setBool:isTutorial forKey:@"IS_TUTORIAL"];
    [userDefaults synchronize];
}

- (BOOL)isTutorial
{
    return [userDefaults boolForKey:@"IS_TUTORIAL"];
}

- (void) removeSecretClient
{
    [userDefaults removeObjectForKey:k_SECRET_CLIENT];
}

- (void) removeCredentialEjab
{
    [userDefaults removeObjectForKey:@"credential_ejab"];
}

- (void) removeAuthSession
{
    [userDefaults removeObjectForKey:k_AUTH_SESSION];
}

- (void) setIsUpdateInformation:(BOOL)isUpdate
{
    [userDefaults setBool:isUpdate forKey:@"update_information"];
    [userDefaults synchronize];
}

- (BOOL) isUpdateInformation
{
    return [userDefaults boolForKey:@"update_information"];
}

- (void) removeIsUpdateInformation
{
    [userDefaults removeObjectForKey:@"update_information"];
}

- (BOOL) checkIsUpdateInformationExisted
{
    if ([userDefaults objectForKey:@"update_information"] == nil)
    {
        return FALSE;
    }
    else
    {
        return TRUE;
    }
}

- (void)saveM_ID:(NSInteger)m_id
{
    [userDefaults setInteger:m_id forKey:@"m_id"];
    [userDefaults synchronize];
}

- (NSInteger)getM_ID
{
    return [userDefaults integerForKey:@"m_id"];
}

- (void)removeM_ID
{
    [userDefaults removeObjectForKey:@"m_id"];
    [userDefaults synchronize];
}

- (UIColor *) colorFromHexString:(NSString *)hexString
{
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (void) saveRefresh_Token:(NSString*)refresh_token
{
    NSString *decryptedRefreshToken = [self decryptDESByKey:self.getAppKey data:refresh_token iv:self.getAppSecret];
    [userDefaults setObject:decryptedRefreshToken forKey:@"refresh_token"];
    [userDefaults synchronize];
}

- (NSString*) getRefresh_Token
{
    return [userDefaults objectForKey:@"refresh_token"];
}

- (void) removeRefresh_Token
{
    [userDefaults removeObjectForKey:@"refresh_token"];
    [userDefaults synchronize];
}

- (void) saveUserPass:(NSString*)userpass
{
    [userDefaults setObject:userpass forKey:@"user_pass"];
    [userDefaults synchronize];
}

- (NSString*) getUserPass
{
    return [userDefaults objectForKey:@"user_pass"];
}

- (void) saveIs_Model:(BOOL)is_model
{
    [userDefaults setBool:is_model forKey:@"is_model"];
    [userDefaults synchronize];
}

- (BOOL)getIs_Model
{
    return [userDefaults boolForKey:@"is_model"];
}

- (void)saveIRace:(NSInteger)iRace
{
    [userDefaults setInteger:iRace forKey:k_iRACE];
    [userDefaults synchronize];
}

- (NSInteger)getIRace
{
    return [userDefaults integerForKey:k_iRACE];
}

- (void)saveRaceName:(NSString*)race_name
{
    [userDefaults setObject:race_name forKey:k_RACE_NAME];
    [userDefaults synchronize];
}

- (NSString*)getRaceName
{
    return [userDefaults objectForKey:k_RACE_NAME];
}

- (BOOL)isNotification
{
    if ([userDefaults objectForKey:@"Is_Notification"] == nil)
    {
        return false;
    }
    
    return [userDefaults boolForKey:@"Is_Notification"];
}

- (void)saveIsNotification:(BOOL)notification
{
    [userDefaults setBool:notification forKey:@"Is_Notification"];
    [userDefaults synchronize];
}

- (void)removeIsNotification
{
    [userDefaults removeObjectForKey:@"Is_Notification"];
    [userDefaults synchronize];
}

- (void)saveUserInfo:(NSDictionary*)userInfo
{
    [userDefaults setObject:userInfo forKey:@"User_Info"];
}

- (NSDictionary*)getUserInfo
{
    return [userDefaults objectForKey:@"User_Info"];
}

- (void)saveTransactionID:(NSString*)transactionID
{
    [userDefaults setObject:transactionID forKey:@"Transaction_ID"];
    [userDefaults synchronize];
}

- (NSString*)getTransactionID
{
    NSString *string = [userDefaults objectForKey:@"Transaction_ID"];
    if(string == nil)
        string = @"";
    return string;
}

- (void)saveTransactionStoreID:(NSString*)transactionID
{
    [userDefaults setObject:transactionID forKey:@"Transaction_Store_ID"];
    [userDefaults synchronize];
}

- (NSString*)getTransactionStoreID
{
    NSString *string = [userDefaults objectForKey:@"Transaction_Store_ID"];
    if(string == nil)
        string = @"";
    return string;
}

- (void)saveProductID:(NSString*)productID
{
    [userDefaults setObject:productID forKey:@"Product_ID"];
    [userDefaults synchronize];
}

- (NSString*)getProductID
{
    return [userDefaults objectForKey:@"Product_ID"];
}

- (void)saveTransactionDate:(NSString*)transactionDate
{
    [userDefaults setObject:transactionDate forKey:@"Transaction_Date"];
    [userDefaults synchronize];
}

- (NSString*)getTransactionDate
{
    return [userDefaults objectForKey:@"Transaction_Date"];
}

- (void)saveState:(NSString*)state
{
    [userDefaults setObject:state forKey:@"Transaction_State"];
    [userDefaults synchronize];
}

- (NSString*)getState
{
    return [userDefaults objectForKey:@"Transaction_State"];
}

- (void)saveReceipt:(NSString*)receipt
{
    [userDefaults setObject:receipt forKey:@"Transaction_Receipt"];
    [userDefaults synchronize];
}

- (NSString*)getReceipt
{
    return [userDefaults objectForKey:@"Transaction_Receipt"];
}

- (void)saveIsPushNotificationToOtherRace:(BOOL)state
{
    [userDefaults setBool:state forKey:@"IsPushNotificationToOtherRace"];
    [userDefaults synchronize];
}

- (BOOL)IsPushNotificationToOtherRace
{
    return [userDefaults boolForKey:@"IsPushNotificationToOtherRace"];
}

- (void)saveChatSetting:(NSInteger)chatLimit
{
    [[NSUserDefaults standardUserDefaults] setInteger:chatLimit forKey:@"ChatLimit"];
    [userDefaults synchronize];
}
- (NSInteger)getChatSetting
{
   return [[NSUserDefaults standardUserDefaults] integerForKey:@"ChatLimit"] ;
}

- (NSString* ) getDayChecking
{
     return [userDefaults objectForKey:@"DayOpenTopPopUp"];
}
- (void) setDayChecking:(NSString * )dayOpen
{
    [userDefaults setObject:dayOpen forKey:@"DayOpenTopPopUp"];
    [userDefaults synchronize];
}

//PAYMENT
- (void)savePaymenPackages:(NSMutableArray*)packagesData
{
    NSData *temp = [NSKeyedArchiver archivedDataWithRootObject:packagesData];
    [[NSUserDefaults standardUserDefaults] setValue:temp forKey:@"PaymentPackages"];
    [userDefaults synchronize];
}
- (NSMutableArray*)getPaymenPackages
{
    NSData *data = [userDefaults objectForKey:@"PaymentPackages"];
    NSMutableArray * result = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return result;
}

- (void) saveIsEventPayment:(BOOL)isEvent
{
    [userDefaults setBool:isEvent forKey:@"IsEventPayMentForNoti"];
    [userDefaults synchronize];
}
- (BOOL) getIsEventPayment
{
    return [userDefaults boolForKey:@"IsEventPayMentForNoti"];
}
- (void) saveNotiEventContent:(NSString*)titleNoti
{
    [userDefaults setObject:titleNoti forKey:@"notiEventPaymentContent"];
    [userDefaults synchronize];
}
- (NSString*) getNotiEventContent
{
    return [userDefaults objectForKey:@"notiEventPaymentContent"];
}

- (void) saveNotiEventPercentBonus:(NSInteger)Percent
{
    [userDefaults setInteger:Percent forKey:@"EnventPercentBonus"];
    [userDefaults synchronize];
}
- (NSInteger) getNotiEventPercentBonus
{
    return [userDefaults integerForKey:@"EnventPercentBonus"];
}
//Tu Le: Add event title
-(void)setEventTitleWithString:(NSString *)string
{
    [userDefaults setObject:string forKey:K_PAYMENT_TITLE_EVENT];
    [userDefaults synchronize];
}
-(NSString*)getEventTitle
{
    return [userDefaults stringForKey:K_PAYMENT_TITLE_EVENT];
}

//DISCOVERY
- (void)saveDiscoveryOptions:(GENDER)gender location:(city*)city{
    NSData *data = [userDefaults objectForKey:@"DiscoveryOptions"];
    NSDictionary *result = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if(result != nil){
        gender = [[result objectForKey:@"DicoveryGender"] integerValue];
    }
    if(city == nil){
        if(result != nil){
            city = [result objectForKey:@"DiscoveryCity"];
        }
    }
    
    [userDefaults removeObjectForKey:@"DiscoveryOptions"];
    NSDictionary* options = [[NSDictionary alloc]initWithObjectsAndKeys: [NSNumber numberWithInteger:gender],@"DicoveryGender",city,@"DiscoveryCity", nil];
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:options];
    [userDefaults setObject:myEncodedObject forKey:@"DiscoveryOptions"];
    [userDefaults synchronize];
}
- (NSDictionary*)getDiscoveryOptions{
    NSData *data = [userDefaults objectForKey:@"DiscoveryOptions"];
    NSDictionary * result = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    /*
    if(result == nil){
         [userDefaults removeObjectForKey:@"DiscoveryOptions"];
        city* dis_city = [[city alloc]init];
        dis_city.city_id = 1;//[self getUserProfileData].location_id;
        dis_city.city_short_name = @"hcm";
        dis_city.city_name = @"Ho Chi Minh";
        
        result =[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:BOTH_FEMALE_MALE],@"DicoveryGender",dis_city,@"DiscoveryCity", nil];
        NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:result];
        [userDefaults setObject:myEncodedObject forKey:@"DiscoveryOptions"];
        [userDefaults synchronize];
    }*/
    return result;
}

//Tu L: add tut seen
-(void)setSeenLeaderboardTut:(BOOL)is_seen {
    [userDefaults setBool:is_seen forKey:@"SeenLeaderboardTut"];
    [userDefaults synchronize];
}

-(BOOL)isReloadDiscovery {
    if ([userDefaults objectForKey:@"IsReloadDiscovery"] == nil)
    {
        return FALSE;
    }
    return [userDefaults boolForKey:@"IsReloadDiscovery"];
}

-(void)setReloadDiscovery:(BOOL)is_reload {
    [userDefaults setBool:is_reload forKey:@"IsReloadDiscovery"];
    [userDefaults synchronize];
}

-(BOOL)isSeenLeaderboardTut {
    return [userDefaults boolForKey:@"SeenLeaderboardTut"];
}

-(void)setSeenMyBloomerTut:(BOOL)is_seen {
    [userDefaults setBool:is_seen forKey:@"SeenLMyBloomerTut"];
    [userDefaults synchronize];
}
-(BOOL)isSeenMyBloomerTut {
    return [userDefaults boolForKey:@"SeenLMyBloomerTut"];
}

-(void)setSeenDiscoveryTut:(BOOL)is_seen {
    [userDefaults setBool:is_seen forKey:@"SeenDiscoveryTut"];
    [userDefaults synchronize];
}
-(BOOL)isSeenDiscoveryTut {
    return [userDefaults boolForKey:@"SeenDiscoveryTut"];
}

-(void)setSeenUserProfileTut:(BOOL)is_seen {
    [userDefaults setBool:is_seen forKey:@"SeenUserProfileTut"];
    [userDefaults synchronize];
}
-(BOOL)isSeenUserProfileTut {
    return [userDefaults boolForKey:@"SeenUserProfileTut"];
}

- (BOOL)isAnonymous
{
    return [userDefaults boolForKey:@"BLOOMER_IsAnonymous"];
}

- (void)setAnonymous:(BOOL)isAnonymous
{
    [userDefaults setBool:isAnonymous forKey:@"BLOOMER_IsAnonymous"];
    [userDefaults synchronize];
}

- (BOOL)didPostDailyLocalNotification
{
    return [userDefaults boolForKey:@"BLOOMER.DidPostDailyLocalNotification"];
}

- (void)setDidPostDailyLocalNotification:(BOOL)didPost
{
    [userDefaults setBool:didPost forKey:@"BLOOMER.DidPostDailyLocalNotification"];
    [userDefaults synchronize];
}

- (void)setMedalKey:(NSString*)key {
    [userDefaults setObject:key forKey:@"RewardMedalKey"];
    [userDefaults synchronize];
}

- (NSString*)getMedalKey {
    NSString *key = [userDefaults objectForKey:@"RewardMedalKey"];
    if (key == nil) {
        key = @"new";
    }
    return key;
}

-(NSInteger)getCurrentRaceGsb {
    return [[userDefaults objectForKey:@"race_gsb"] integerValue];
}

-(void)setCurrentRaceGsb:(NSInteger)gsb {
    [userDefaults setInteger:gsb forKey:@"race_gsb"];
    [userDefaults synchronize];
}

-(NSString *)getDeepLinkTag {
    return [userDefaults stringForKey:@"DeeplinkTag"];
}

-(void)setDeepLinkTagWithString:(NSString *)tag {
    [userDefaults setObject:tag forKey:@"DeeplinkTag"];
    [userDefaults synchronize];
}

-(NSDictionary *)getDeeplinkParams {
    return [userDefaults objectForKey:@"DeeplinkParams"];
}

-(void)setDeeplinkParams:(NSDictionary *)params {
    [userDefaults setObject:params forKey:@"DeeplinkParams"];
    [userDefaults synchronize];
}

-(NSString*)getNumberMobile
{
    return [userDefaults objectForKey:@"mobileNumber"];
}
-(void)setNumberMobile:(NSString*)params
{
    [userDefaults setObject:params forKey:@"mobileNumber"];
    [userDefaults synchronize];
}

@end
