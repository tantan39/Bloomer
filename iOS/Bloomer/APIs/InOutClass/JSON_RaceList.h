//
//  out_races_list_fetches.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 3/25/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "BaseJSON.h"
#import "races_list.h"

@interface JSON_RaceList : NSObject <BaseJSON>

@property (strong, nonatomic) NSMutableArray *categoryList;
@property (strong, nonatomic) NSMutableDictionary *racesByCategory;
@property (assign, nonatomic) NSInteger gender;

@end
