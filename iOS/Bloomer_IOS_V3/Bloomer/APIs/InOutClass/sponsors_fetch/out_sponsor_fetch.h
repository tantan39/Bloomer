//
//  out_sponsor_fetch.h
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/15/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"
#import "sponsors.h"
//#import "jsonAbstractClassProtected.h"

@interface out_sponsor_fetch : NSObject<BaseJSON>

@property (strong, nonatomic) NSMutableArray * sponsorData;

@end
