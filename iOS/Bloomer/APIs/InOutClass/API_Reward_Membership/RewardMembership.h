//
//  rewardMembership.h
//  Bloomer
//
//  Created by Thanh Tu Nguyen on 8/3/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"

@interface RewardMembership : NSObject <BaseJSON>

@property (assign, nonatomic) NSInteger Bronze;
@property (assign, nonatomic) NSInteger Silver;
@property (assign, nonatomic) NSInteger Gold;

@end
