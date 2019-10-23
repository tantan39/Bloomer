//
//  givers.h
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/15/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"
#import "giver.h"

@interface givers : NSObject<BaseJSON>

@property (strong, nonatomic) NSMutableArray* giversData;

@end
