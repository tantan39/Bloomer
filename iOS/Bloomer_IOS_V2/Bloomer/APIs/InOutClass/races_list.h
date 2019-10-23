//
//  races_list.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 3/25/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "races_list.h"
//#import "jsonAbstractClass.h"
#import "CountryAvatar.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreSpotlight/CoreSpotlight.h>

@interface races_list : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *category_name;
@property (strong, nonatomic) NSString *childs;
@property (assign, nonatomic) NSInteger is_join;
@property (assign, nonatomic) NSInteger category;
@property (assign, nonatomic) NSInteger isClosed;
@property (assign, nonatomic) NSInteger isMulti;
@property (assign, nonatomic) NSInteger locationID;
@property (strong, nonatomic) NSString *key;
//@property (strong, nonatomic) NSString *rules;
@property (assign, nonatomic) long long start;
@property (assign, nonatomic) long long end;
@property (strong, nonatomic) NSString *startDate;
@property (strong, nonatomic) NSString *endDate;
@property (strong, nonatomic) NSString *raceInfo;
@property (strong, nonatomic) NSString *joinInfo;
@property (strong, nonatomic) NSString *leaveInfo;
@property (strong, nonatomic) NSString *closedURL;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *logo;
@property (assign, nonatomic) Boolean joined;
@property (strong, nonatomic) NSString *video_link;
@property (strong, nonatomic) NSString *gift;
@property (assign, nonatomic) NSInteger gsb;
@property NSMutableArray * countryAvatarList;

- (id)initWithName:(NSString *)name
            isJoin:(NSInteger)is_join
               key:(NSString *)key
             start:(long long)start
               end:(long long)end
         startDate:(NSString *) startDate
           endDate:(NSString *) endDate
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
               gsb:(NSInteger)gsb;

- (CSSearchableItem*)searchableItemItemWithGender:(NSInteger)gender;
- (CSSearchableItemAttributeSet*)searchableItemAttributeSetWithGender:(NSInteger)gender;

@end
