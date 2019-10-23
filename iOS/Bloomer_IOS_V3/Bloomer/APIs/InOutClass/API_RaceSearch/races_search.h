//
//  races_search.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/13/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface races_search : NSObject

@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger uid;
@property (assign, nonatomic) NSInteger rank;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *username;
@property (assign, nonatomic) long long flower;

- (id)initWithName:(NSString *)name
               uid:(NSInteger)uid
              rank:(NSInteger)rank
            avatar:(NSString *)avatar
          username:(NSString *)username
            flower:(long long)flower;

@end
