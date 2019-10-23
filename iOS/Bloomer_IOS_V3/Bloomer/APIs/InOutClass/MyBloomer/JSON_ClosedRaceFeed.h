//
//  JSON_ClosedRaceFeed.h
//  Bloomer
//
//  Created by Le Chau Tu on 8/11/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"
#import "FeedWinner.h"
#import "APIDefine.h"

@interface JSON_ClosedRaceFeed : NSObject<BaseJSON>

@property (strong, nonatomic) NSMutableArray *winnerList;
@property (strong, nonatomic) NSString *raceURL;

@end
