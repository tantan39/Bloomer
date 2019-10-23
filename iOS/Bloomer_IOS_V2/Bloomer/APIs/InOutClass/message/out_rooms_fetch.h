//
//  out_rooms_fetch.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/6/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "jsonAbstractClass.h"
#import "room.h"
#import "BaseJSON.h"

@interface out_rooms_fetch : NSObject<BaseJSON>

@property (strong, nonatomic) NSMutableArray* roomsData;

@end

