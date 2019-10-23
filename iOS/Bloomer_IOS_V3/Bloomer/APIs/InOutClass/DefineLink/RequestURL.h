//
//  RequestURL.h
//  Bloomer
//
//  Created by Tran Thai Tan on 7/24/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum HTTPRequestMethod
{
    GET,
    POST,
    PUT,
    DELETE
} HTTPRequestMethod;

@interface RequestURL : NSObject

@property (strong,nonatomic) NSString * url;
@property (strong,nonatomic) NSString * host;
@property (assign, nonatomic) HTTPRequestMethod requestMethod;

- (instancetype)initWithURL:(NSString *)url Host:(NSString *)host requestMethod:(HTTPRequestMethod)requestMethod;

@end
