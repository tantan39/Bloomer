//
//  race_favourite.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/16/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIDefine.h"

@interface RaceFavouriteObj : NSObject

@property (assign, nonatomic) NSInteger uid;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* avatar;
@property (strong, nonatomic) NSString* photo_id;
@property (assign, nonatomic) long long num_flower;
@property (assign, nonatomic) NSInteger status_of_rank;
@property (strong, nonatomic) NSString* race_name;
@property (assign, nonatomic) NSInteger rank;
@property (strong, nonatomic) NSString* color_code;
@property (assign, nonatomic) NSInteger codes;

- (void)extractData:(NSDictionary *)data;

@end
