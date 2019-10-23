//
//  comment.h
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/15/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"

@interface comment : NSObject<BaseJSON>

@property (assign, nonatomic) NSInteger uid;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *username;

@property (strong, nonatomic) NSString *comment_id;
@property (strong, nonatomic) NSString *content;
@property (assign, nonatomic) long long timestamp;

@end
