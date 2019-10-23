//
//  out_follower_search.h
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 2/22/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "follower.h"
#import "BaseJSON.h"

@interface out_follower_search : NSObject<BaseJSON>

@property (strong, nonatomic) NSMutableArray *followerList;

@end
