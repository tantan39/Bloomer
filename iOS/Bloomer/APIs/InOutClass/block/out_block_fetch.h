//
//  out_block_fetch.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 5/8/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

//#import "jsonAbstractClass.h"
#import "BaseJSON.h"
#import "blocker.h"

@interface out_block_fetch : NSObject<BaseJSON>

@property (strong, nonatomic) NSMutableArray* blockers;

@end


