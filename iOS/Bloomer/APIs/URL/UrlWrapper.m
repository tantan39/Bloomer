//
//  UrlWrapper.m
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/8/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import "UrlWrapper.h"
#import "UrlWrapperProtected.h"
#import "APIDefine.h"

@implementation UrlWrapper : NSObject

- (id)init {
    self = [super init];
    if (self) {
        self->url = @"there nothing here";
    }
    
    return self;
}

- (id)initWithUrl:(NSString *)myUrl {
    self = [super init];
    
    if (self) {
        self->url = myUrl;
    }
    
    return self;
}

- (void)setUrl:(NSString *)myURL {
    self->url = myURL;
}

- (NSString *)getUrl {
    return self->url;
}

@end
