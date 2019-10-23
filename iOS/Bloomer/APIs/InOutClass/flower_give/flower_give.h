//
//  flower_give.h
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/12/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "jsonAbstractClass.h"
#import "BaseJSON.h"

#pragma mark - GIVING TO RACE
@interface flower_give : NSObject<BaseJSON>

@property (weak, nonatomic) NSString *access_token;
@property (weak, nonatomic) NSString *device_token;
@property (assign, nonatomic) long long num_flower;
@property (assign, nonatomic) NSInteger model;
@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *ckey;

-(id)initWithAccessToken:(NSString *)access_token
            device_token:(NSString *)device_token
              num_flower:(long long)num_flower
                   model:(NSInteger)model
                     key:(NSString *)key
                    ckey:(NSString *)ckey;

@end

//#pragma mark - GIVING TO CHAT
//@interface flower_give_chat : jsonAbstractClass
//
//@property (weak, nonatomic) NSString *access_token;
//@property (weak, nonatomic) NSString *device_token;
//@property (assign, nonatomic) long long num_flower;
//@property (assign, nonatomic) NSInteger receiver;
//
//- (id)initWithAccessToken:(NSString *)access_token
//             device_token:(NSString *)device_token
//               num_flower:(long long)num_flower
//                 receiver:(NSInteger)receiver;
//
//@end
