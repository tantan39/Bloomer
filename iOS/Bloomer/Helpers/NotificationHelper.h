//
//  NotificationHelper.h
//  Bloomer
//
//  Created by Steven on 12/18/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "races_list.h"

@interface NotificationNames : NSObject

+ (NSString*)NeedToReloadRaceList;
+ (NSString*)CompleteConfirmingJoiningRace;
+ (NSString*)GoToSpecificRace;
+ (NSString*)TouchJoinButton;
+ (NSString*)OpenVideo;
+ (NSString*)OpenRaceInfoLink;
+ (NSString*)SwitchStickerKeyboard;
+ (NSString*)OpenGift;
+ (NSString*)OpenAnonymousTab;
+ (NSString*)SwitchLocationContest;
+ (NSString*)UpdateAboutMe;
+ (NSString*)UpdateProfileName;
+ (NSString*)UpdateProfileUsername;
+ (NSString*)UidProfileLock;
+ (NSString*)AuthenSuccess;
+ (NSString*)UpdateNumberPhone;

@end

@interface NotificationKey : NSObject

+ (NSString*)LocationID;
+ (NSString*)Key;
+ (NSString*)Gsb;
+ (NSString*)Gender;
+ (NSString*)RaceData;
+ (NSString*)VideoLink;
+ (NSString*)RaceInfoLink;
+ (NSString*)RaceName;
+ (NSString*)GiftLink;
+ (NSString*)TimeStampKey;
+ (NSString*)AboutMe;
+ (NSString*)ProfileName;
+ (NSString*)ProfileUsername;
+ (NSString*)UidProfile;
@end

@interface NotificationHelper : NSObject

+ (void)postNotificationForReloadingRaceList;
+ (void)postNotificationForCompletingConfirmingJoiningRace:(NSInteger)locationID key:(NSString*)key;
+ (void)postNotificationForGoingToSpecificRace:(NSInteger)gender key:(NSString*)key timeStampKey:(NSString *) timestampKey;
+ (void)postNotificationForGoingToSpecificRace:(NSInteger)gender key:(NSString*)key timeStampKey:(NSString *) timestampKey gsb:(NSInteger)gsb;
+ (void)postNotificationForTouchingJoinButton:(races_list*)raceData gender:(NSInteger)gender;
+ (void)postNotificationForOpeningVideo:(NSString*)videoLink;
+ (void)postNotificationForOpeningRaceInfoLink:(NSString*)raceInfoLink raceName:(NSString*)raceName;
+ (void)postNotificationForSwitchingStickerKeyboard;
+ (void)postNotificationForOpeningGift:(NSString*)giftLink;
+ (void)postNotificationForopeningAnonymousTab;
+ (void)postNotificationSwitchLocationContestSuccess;
+ (void)postNotificationForUpdatingAboutMe:(NSString*)aboutMe;
+ (void)postNotificationForUpdatingProfileName:(NSString*)profileName;
+ (void)postNotificationForUpdatingProfileUsername:(NSString*)profileUsername;
+ (void)postNotificationWhenLockProfile:(NSInteger) uidProfile;
+ (void)postNotificationWhenAuthenSocketSuccess;
+ (void)postNotificationUpdateNumberPhone;

@end
