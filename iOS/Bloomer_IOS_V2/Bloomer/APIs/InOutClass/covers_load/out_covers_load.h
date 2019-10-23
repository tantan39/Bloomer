//
//  out_covers_load.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 5/18/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "jsonAbstractClass.h"
#import "jsonAbstractClassProtected.h"
#import "covers.h"

@interface out_covers_load : jsonAbstractClass

@property (strong, nonatomic) NSMutableArray *covers;

@end