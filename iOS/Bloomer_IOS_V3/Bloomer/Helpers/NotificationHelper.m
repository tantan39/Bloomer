//
//  NotificationHelper.m
//  Bloomer
//
//  Created by Steven on 12/18/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "NotificationHelper.h"

@implementation NotificationNames

+ (NSString*)NeedToReloadRaceList
{
    return @"NeedToReloadRaceList";
}

+ (NSString*)CompleteConfirmingJoiningRace
{
    return @"CompleteConfirmingJoiningRace";
}

+ (NSString*)GoToSpecificRace
{
    return @"GoToSpecificRace";
}

+ (NSString*)TouchJoinButton
{
    return @"TouchJoinButton";
}

+ (NSString*)OpenVideo
{
    return @"OpenVideo";
}

+ (NSString*)OpenRaceInfoLink
{
    return @"OpenRaceInfoLink";
}

+ (NSString*)SwitchStickerKeyboard
{
    return @"SwitchStickerKeyboard";
}

+ (NSString*)OpenGift
{
    return @"OpentGift";
}

+(NSString *)OpenAnonymousTab
{
    return @"OpenAnonymousTab";
}

+ (NSString *)SwitchLocationContest
{
    return @"SwitchLocationContest";
}

+ (NSString*)UpdateAboutMe
{
    return @"UpdateAboutMe";
}

+ (NSString*)UpdateProfileName
{
    return @"UpdateProfileName";
}

+ (NSString*)UpdateProfileUsername
{
    return @"UpdateProfileUsername";
}

+ (NSString*)UidProfileLock
{
    return @"UidProfileLock";
}
+ (NSString*) AuthenSuccess {
    return @"AuthenSuccess";
}

@end

@implementation NotificationKey : NSObject

+ (NSString*)LocationID
{
    return @"LocationID";
}

+ (NSString*)Key
{
    return @"Key";
}

+ (NSString*)Gsb
{
    return @"gsb";
}

+ (NSString*)Gender
{
    return @"Gender";
}

+ (NSString*)RaceData
{
    return @"RaceData";
}

+ (NSString*)VideoLink
{
    return @"VideoLink";
}

+ (NSString*)RaceInfoLink
{
    return @"RaceInfoLink";
}

+ (NSString*)RaceName
{
    return @"RaceName";
}

+ (NSString*)GiftLink
{
   return @"GiftLink"; 
}

+ (NSString *)TimeStampKey
{
    return @"TimeStamp";
}

+ (NSString*)AboutMe
{
    return @"AboutMe";
}

+ (NSString*)ProfileName
{
    return @"ProfileName";
}

+ (NSString*)ProfileUsername
{
    return @"ProfileUsername";
}

+ (NSString*)UidProfile
{
    return @"UidProfileLock";
}
@end

@implementation NotificationHelper

+ (void)postNotificationForReloadingRaceList
{
    [[NSNotificationCenter defaultCenter] postNotificationName:[NotificationNames NeedToReloadRaceList] object:nil];
}

+ (void)postNotificationForCompletingConfirmingJoiningRace:(NSInteger)locationID key:(NSString*)key
{
    NSDictionary *userInfo = @{[NotificationKey LocationID]: [NSNumber numberWithInteger:locationID], [NotificationKey Key] : key};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:[NotificationNames CompleteConfirmingJoiningRace] object:nil userInfo:userInfo];
}

+ (void)postNotificationForGoingToSpecificRace:(NSInteger)gender key:(NSString*)key timeStampKey:(NSString *) timestampKey
{
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithDictionary:@{[NotificationKey Gender] : [NSNumber numberWithInteger:gender], [NotificationKey Key] : key}];
    
    if (timestampKey) {
        [userInfo setObject:timestampKey forKey:[NotificationKey TimeStampKey]];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:[NotificationNames GoToSpecificRace] object:nil userInfo:userInfo];
}

+ (void)postNotificationForGoingToSpecificRace:(NSInteger)gender key:(NSString*)key timeStampKey:(NSString *) timestampKey gsb:(NSInteger)gsb
{
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithDictionary:@{[NotificationKey Gender] : [NSNumber numberWithInteger:gender], [NotificationKey Key] : key, [NotificationKey Gsb] : @(gsb)}];
    
    if (timestampKey) {
        [userInfo setObject:timestampKey forKey:[NotificationKey TimeStampKey]];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:[NotificationNames GoToSpecificRace] object:nil userInfo:userInfo];
}

+ (void)postNotificationForTouchingJoinButton:(races_list*)raceData gender:(NSInteger)gender
{
    NSDictionary *userInfo = @{[NotificationKey RaceData] : raceData, [NotificationKey Gender] : [NSNumber numberWithInteger:gender]};
    [[NSNotificationCenter defaultCenter] postNotificationName:[NotificationNames TouchJoinButton] object:nil userInfo:userInfo];
}

+ (void)postNotificationForOpeningVideo:(NSString*)videoLink
{
    NSDictionary *userInfo = @{[NotificationKey VideoLink] : videoLink};
    [[NSNotificationCenter defaultCenter] postNotificationName:[NotificationNames OpenVideo] object:nil userInfo:userInfo];
}

+ (void)postNotificationForOpeningRaceInfoLink:(NSString*)raceInfoLink raceName:(NSString*)raceName
{
    NSDictionary *userInfo = @{[NotificationKey RaceInfoLink] : raceInfoLink, [NotificationKey RaceName] : raceName};
    [[NSNotificationCenter defaultCenter] postNotificationName:[NotificationNames OpenRaceInfoLink] object:nil userInfo:userInfo];
}

+ (void)postNotificationForSwitchingStickerKeyboard
{
    [[NSNotificationCenter defaultCenter] postNotificationName:[NotificationNames SwitchStickerKeyboard] object:nil userInfo:nil];
}

+ (void)postNotificationForOpeningGift:(NSString*)giftLink
{
    NSDictionary *userInfo = @{[NotificationKey GiftLink] : giftLink};
    [[NSNotificationCenter defaultCenter] postNotificationName:[NotificationNames OpenGift] object:nil userInfo:userInfo];
}

+(void)postNotificationForopeningAnonymousTab
{
    [[NSNotificationCenter defaultCenter] postNotificationName:[NotificationNames OpenAnonymousTab] object:nil userInfo:nil];
}

+ (void)postNotificationSwitchLocationContestSuccess
{
    [[NSNotificationCenter defaultCenter] postNotificationName:[NotificationNames SwitchLocationContest] object:nil userInfo:nil];
}

+ (void)postNotificationForUpdatingAboutMe:(NSString*)aboutMe
{
    NSDictionary *userInfo = @{[NotificationKey AboutMe] : aboutMe};
    [[NSNotificationCenter defaultCenter] postNotificationName:[NotificationNames UpdateAboutMe] object:nil userInfo:userInfo];
}

+ (void)postNotificationForUpdatingProfileName:(NSString*)profileName
{
    NSDictionary *userInfo = @{[NotificationKey ProfileName] : profileName};
    [[NSNotificationCenter defaultCenter] postNotificationName:[NotificationNames UpdateProfileName] object:nil userInfo:userInfo];
}

+ (void)postNotificationForUpdatingProfileUsername:(NSString*)profileUsername
{
    NSDictionary *userInfo = @{[NotificationKey ProfileUsername] : profileUsername};
    [[NSNotificationCenter defaultCenter] postNotificationName:[NotificationNames UpdateProfileUsername] object:nil userInfo:userInfo];
}

+ (void)postNotificationWhenLockProfile:(NSInteger) uidProfile
{
    NSDictionary *userInfo = @{[NotificationKey UidProfile] :[NSString stringWithFormat:@"%ld", (long)uidProfile]};
    [[NSNotificationCenter defaultCenter] postNotificationName:[NotificationNames UidProfileLock] object:nil userInfo:userInfo];
}

+ (void)postNotificationWhenAuthenSocketSuccess {
    [[NSNotificationCenter defaultCenter] postNotificationName:[NotificationNames AuthenSuccess] object:nil userInfo:nil];
}

@end
