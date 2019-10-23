//
//  out_location_load.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 3/22/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "jsonAbstractClass.h"
//#import "jsonAbstractClassProtected.h"
#import "APIDefine.h"
#import "BaseJSON.h"
@interface out_location_load : NSObject<BaseJSON>

@property (strong, nonatomic) NSMutableArray *citys;
@property (assign, nonatomic) BOOL status;

@end
