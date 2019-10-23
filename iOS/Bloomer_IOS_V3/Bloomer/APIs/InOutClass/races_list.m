//
//  races_list.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 3/25/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "races_list.h"
#import "AppHelper.h"

@implementation races_list

- (id)initWithName:(NSString *)name
            isJoin:(NSInteger)is_join
               key:(NSString *)key
             start:(long long)start
               end:(long long)end
         startDate:(NSString *)startDate
           endDate:(NSString *)endDate
          raceInfo:(NSString *)raceInfo
          joinInfo:(NSString *)joinInfo
         leaveInfo:(NSString *)leaveInfo
      categoryName:(NSString *)category_name
            childs:(NSString *)childs
          isClosed:(NSInteger)isClosed
           isMulti:(NSInteger)isMulti
        locationID:(NSInteger)locationID
          category:(NSInteger)category
         closedURL:(NSString *)closedURL
            avatar:(NSString *)avatar
        video_link:(NSString *)video_link
              gift:(NSString *)gift
              logo:(NSString *)logo
    countryAvatars:(NSArray *) countryAvatars
               gsb:(NSInteger)gsb
{
    self = [super init];
    
    if (self)
    {
        _name = name;
        _is_join = is_join;
        _key = key;
        _start = start;
        _startDate = startDate; //[dateFormat dateFromString:startDate];
        _end = end;
        _endDate = endDate; //[dateFormat dateFromString:endDate];
        _raceInfo = raceInfo;
        _joinInfo = joinInfo;
        _leaveInfo = leaveInfo;
        _category_name = category_name;
        _childs = childs;
        _isClosed = isClosed;
        _isMulti = isMulti;
        _locationID = locationID;
        _category = category;
        _closedURL = closedURL;
        self.avatar = avatar;
        self.video_link = video_link;
        _gift = gift;
        _logo = logo;
        _gsb = gsb;
        _countryAvatarList = [[NSMutableArray alloc] init];
        for (NSDictionary *json in countryAvatars) {
            if (json) {
                CountryAvatar *obj = [[CountryAvatar alloc] initWithJSON:json];
                if (![obj.urlAvatar isEqualToString:@""]) {
                    [_countryAvatarList addObject:obj];
                }
            }
        }
    }
    
    return self;
}

- (CSSearchableItem*)searchableItemItemWithGender:(NSInteger)gender
{
    CSSearchableItemAttributeSet *attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(__bridge NSString *)kUTTypeMP3];
//    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.avatar]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.avatar]];
        dispatch_async(dispatch_get_main_queue(), ^{
            attributeSet.thumbnailData = imageData;
        });
    });
    NSString *uniqeIdentifier = [NSString stringWithFormat:@"%@#$#%@#$#%@", kSpotlightSearchLeaderboard, self.key, gender == 0 ? @"Female" : @"Male"];
    
    attributeSet.title = self.name;
    attributeSet.displayName = self.name;
    attributeSet.contentDescription = gender == 0 ? @"Female Contest" : @"Male Contest";
    attributeSet.artist = self.endDate;
//    attributeSet.thumbnailData = imageData;
    attributeSet.keywords = @[self.name, uniqeIdentifier];

    CSSearchableItem *searchItem = [[CSSearchableItem alloc] initWithUniqueIdentifier:uniqeIdentifier domainIdentifier:kSpotlightSearchLeaderboard attributeSet:attributeSet];
    
    return searchItem;
}

- (CSSearchableItemAttributeSet*)searchableItemAttributeSetWithGender:(NSInteger)gender
{
    CSSearchableItemAttributeSet *attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(__bridge NSString *)kUTTypeMP3];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.avatar]];
    
    attributeSet.domainIdentifier = kSpotlightSearchLeaderboard;
    attributeSet.identifier = [NSString stringWithFormat:@"Bloomer_%@_%@", self.key, gender == 0 ? @"Female" : @"Male"];
    attributeSet.title = [NSString stringWithFormat:@"Bloomer_%@_%@", self.key, gender == 0 ? @"Female" : @"Male"];
    attributeSet.displayName = self.name;
    attributeSet.contentDescription = gender == 0 ? @"Female Contest" : @"Male Contest";
    attributeSet.artist = self.endDate;
    attributeSet.thumbnailData = imageData;
    attributeSet.supportsPhoneCall = [NSNumber numberWithBool:true];
    attributeSet.supportsNavigation = [NSNumber numberWithBool:true];
    attributeSet.keywords = @[self.name];
    
    return attributeSet;
}

@end
