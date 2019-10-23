//
//  jsonAbstractClass.m
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/8/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import "jsonAbstractClass.h"

@implementation jsonAbstractClass

- (id)init {
    self = [super init];
    
    if (self) {
    
    }
    
    return self;
}

- (NSString *)createStringJSON {
    return nil;
}

- (void)formJsonToData:(NSDictionary *)data {
    [self isSuccess:data];
    
    if (stt == YES) {
        [self extractData:data];
    }
}

- (void)extractData:(NSDictionary *)data {
    
}

- (bool)isSuccess:(NSDictionary *)data {
    NSLog(@"DATA: %@", data);
    BOOL localResult;
    
    BOOL strResult = [[data objectForKey:k_STATUS] boolValue];
    
    sttState = @(strResult).stringValue;
    intState = @(strResult).integerValue;
    if (data == nil) {
        self->stt = FALSE;
        self->megs = @"Connection failed.";
        self->title = @"Error";
        localResult = NO;
    } else {
        if (!strResult) {
            self->stt = NO;
            NSDictionary *dic = [data objectForKey:@"error"];
            self->megs = [dic objectForKey:@"msg"];
            self->code = [[dic objectForKey:k_CODE] integerValue];
            self->title = [dic objectForKey:@"title"];
            localResult = NO;
            
            if ([dic objectForKey:k_EXPIRED_TIME] != [NSNull null]) {
                self->expireTime = [[dic objectForKey:k_EXPIRED_TIME] integerValue];
            }
           

        } else {
            self->stt = YES;
            if ([data objectForKey:k_IS_EXPIRED] != [NSNull null]) {
                self->isExpired = [[data objectForKey:k_IS_EXPIRED] boolValue];
            }
            localResult = YES;
        }
    }
    
    return localResult;
}


- (bool)getStt {
    return self->stt;
}

- (NSString *)getMegs {
    return self->megs;
}

- (NSString *)getTitle {
    return self->title;
}

- (NSString *)getSttState {
    return self->sttState;
}

- (NSInteger )getIntState {
    return self->intState;
}

- (NSInteger)getExpireTime {
    return self->expireTime;
}
- (BOOL)getExpired{
    return self->isExpired;
}

- (NSInteger)getCode {
    return self->code;
}

+ (NSString *)md5:(NSString *)input {
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

@end
