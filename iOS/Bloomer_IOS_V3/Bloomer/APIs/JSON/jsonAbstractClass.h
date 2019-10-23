//
//  jsonAbstractClass.h
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/8/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "APIDefine.h"

@interface jsonAbstractClass : NSObject {
    @protected bool stt;
    NSString *sttState;
    NSString *megs;
    NSInteger code;
    NSInteger expireTime;
    BOOL isExpired;
    NSString *title;
    NSInteger intState;
}

- (id)init;
- (void)formJsonToData:(NSDictionary *)data;
- (bool)isSuccess:(NSDictionary *)data;
- (bool)getStt;
- (NSString *)createStringJSON;
- (NSString *)getMegs;
+ (NSString *)md5:(NSString *)input;
- (NSInteger)getExpireTime;
- (BOOL)getExpired;
- (NSInteger)getCode;
- (NSString *)getSttState;
- (NSString *)getTitle;
- (NSInteger )getIntState;

@end
