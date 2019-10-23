//
//  blocker.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 5/11/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"

@interface blocker : NSObject<BaseJSON>

@property (strong, nonatomic) NSString* screen_name;
@property (assign, nonatomic) NSInteger uid;

@end

