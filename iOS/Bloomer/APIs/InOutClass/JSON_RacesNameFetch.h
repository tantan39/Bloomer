//
//  JSON_PostUserFetches.h
//  Bloomer
//
//  Created by Ahri on 8/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"
#import "APIDefine.h"
#import "childs.h"

@interface JSON_RacesNameFetch : NSObject <BaseJSON>

@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger isJoin;
@property (assign, nonatomic) long long start;
@property (assign, nonatomic) long long end;
@property (strong, nonatomic) NSString *rules;
@property (assign, nonatomic) NSInteger category;
@property (assign, nonatomic) NSInteger locationID;
@property (assign, nonatomic) NSInteger isActive;
@property (strong, nonatomic) NSMutableArray *childsList;
@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *raceInfo;
@property (strong, nonatomic) NSString *joinInfo;
@property (strong, nonatomic) NSString *leaveInfo;
@property (strong, nonatomic) NSString *closedURL;
@property (strong, nonatomic) NSString *startDate;
@property (strong, nonatomic) NSString *endDate;
@property (assign, nonatomic) BOOL isClosed;
@property (assign, nonatomic) BOOL isComingSoon;

@end
