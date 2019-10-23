//
//  giver.h
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/15/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"

@interface giver : NSObject<BaseJSON>

@property (assign, nonatomic) NSInteger uid;
@property (strong, nonatomic) NSString* screen_name;

-(id)initWithUid:(NSInteger)userID andScreenName:(NSString *) name;

@end
