//
//  out_race_feed.h
//  Bloomer
//
//  Created by VanLuu on 6/1/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "feed_list.h"
#import "feed_pic.h"
#import "feed_winner.h"
#import "BaseJSON.h"

@interface out_race_feed : NSObject<BaseJSON>
@property (strong, nonatomic) NSMutableArray *winnerList;
@property (strong, nonatomic) NSString *raceURL;
@end
