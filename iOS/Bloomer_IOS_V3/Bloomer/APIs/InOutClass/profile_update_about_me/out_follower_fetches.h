//
//  out_follower_fetches.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/4/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "follower.h"
#import "BaseJSON.h"

@interface out_follower_fetches : NSObject<BaseJSON>

@property (strong, nonatomic) NSMutableArray *followerList;
@property (assign, nonatomic) BOOL isFinal;
@property (assign, nonatomic) NSInteger index;

@end
