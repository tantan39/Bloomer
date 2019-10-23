//
//  API_GetActiveAchievement.h
//  Bloomer
//
//  Created by Thanh Tu Nguyen on 8/16/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BloomerRestful.h"
#import "JSON_Achievement.h"

@interface API_GetActiveAchievement : BloomerRestful

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token user_id:(NSInteger)user_id;
- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString*)device_token user_id:(NSInteger)user_id andKey:(NSString*) key;

@end
