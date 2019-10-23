//
//  RequestURL.m
//  Bloomer
//
//  Created by Tran Thai Tan on 7/24/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "RequestURL.h"

@implementation RequestURL

- (instancetype)initWithURL:(NSString *)url Host:(NSString *)host requestMethod:(HTTPRequestMethod)requestMethod
{
    self = [super init];
    
    if (self)
    {
        self.host = host;

        self.url = [self.host stringByAppendingString:url];

        self.requestMethod = requestMethod;
    }
    
    return self;
}

@end
