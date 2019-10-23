//
//  region.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 7/24/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"
//#import "jsonAbstractClassProtected.h"

@interface region : NSObject<BaseJSON>

@property (strong, nonatomic) NSString* country_code;
@property (strong, nonatomic) NSString* country_name;
@property (strong, nonatomic) NSString* short_name;

@end
