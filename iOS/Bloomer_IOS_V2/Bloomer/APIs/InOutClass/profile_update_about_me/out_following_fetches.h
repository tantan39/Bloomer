//
//  out_following_fetches.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/4/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "follower.h"
#import "BaseJSON.h"

@interface out_following_fetches : NSObject<BaseJSON>

@property (strong, nonatomic) NSMutableArray *followingList;
@property (assign, nonatomic) BOOL isFinal;
@end
