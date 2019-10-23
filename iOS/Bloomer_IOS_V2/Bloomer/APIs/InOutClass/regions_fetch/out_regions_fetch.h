//
//  out_regions_fetch.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 7/24/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"
//#import "jsonAbstractClassProtected.h"
#import "region.h"

@interface out_regions_fetch : NSObject<BaseJSON>

@property (strong, nonatomic) NSMutableArray *regions;

@end
