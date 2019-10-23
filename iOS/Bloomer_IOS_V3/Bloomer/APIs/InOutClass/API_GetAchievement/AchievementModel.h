//
//  rank.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/15/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface AchievementModel : NSObject

@property (assign, nonatomic) NSInteger rank;
@property (strong, nonatomic) NSString *raceName;
@property (strong, nonatomic) NSString *raceKey;
@property (assign, nonatomic) long long num_flower;
@property (strong, nonatomic) NSMutableArray *childs;
//@property (assign, nonatomic) NSInteger iRace;
//@property (assign, nonatomic) NSString *hRank;
//@property (assign, nonatomic) NSString *color_code;
//@property (assign, nonatomic) NSString *date_closed;



@end
