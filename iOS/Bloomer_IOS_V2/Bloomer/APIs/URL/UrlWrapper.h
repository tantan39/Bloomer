//
//  UrlWrapper.h
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/8/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UrlWrapper : NSObject {
    @protected NSString *url;
}

- (id)init;
- (id)initWithUrl:(NSString *)myUrl;
- (void)setUrl:(NSString *)myURL;
- (NSString *)getUrl;

@end
