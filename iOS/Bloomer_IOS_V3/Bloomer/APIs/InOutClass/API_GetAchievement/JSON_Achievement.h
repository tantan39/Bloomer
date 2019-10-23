//
//  out_rank_history.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/14/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "BaseJSON.h"
#import "AchievementModel.h"

@interface JSON_Achievement : NSObject<BaseJSON>

//@property (strong, nonatomic) NSMutableArray *active_ranks;
//@property (strong, nonatomic) NSMutableArray *history_rank;
@property (strong, nonatomic) NSMutableArray *achievements;
@property (strong, nonatomic) NSString* keyEnd;

@end
