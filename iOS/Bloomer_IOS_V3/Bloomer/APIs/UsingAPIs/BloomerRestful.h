//
//  BloomerRestful.h
//  Bloomer
//
//  Created by Tran Thai Tan on 7/24/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

@class BaseJSON;

#import <Foundation/Foundation.h>
#import "RequestURL.h"
#import "RestfulResponse.h"
#import "BaseJSON.h"

@interface BloomerRestful : NSObject

@property (strong, nonatomic) NSDictionary * _params;
@property (strong,nonatomic) NSData * dataImage;

- (instancetype) initWith:(RequestURL *) requestURL Params:(NSDictionary *) params;

//- (RequestURL *) getRequestURL;

- (NSDictionary *) getParameter;

- (void) getRequest:(void(^)(BaseJSON *, RestfulResponse *)) completionBlock ErrorHandlure:(void(^)(NSError *)) failure;

- (void) postRequest:(void(^)(BaseJSON *, RestfulResponse *)) completionBlock ErrorHandlure:(void(^)(NSError *)) failure;

- (void) putRequest:(void(^)(BaseJSON *, RestfulResponse *)) completionBlock ErrorHandlure:(void(^)(NSError *)) failure;

- (void) deleteRequest:(void(^)(BaseJSON *, RestfulResponse *)) completionBlock ErrorHandlure:(void(^)(NSError *)) failure;

- (void) postParamToHeader:(id) params forKey:(NSString *) key;

- (void) cancelCurrentRequest;

- (BaseJSON *) handleJSON:(NSDictionary *) json; //Subclass will override
- (void)request:(void (^)(BaseJSON *jsonObject, RestfulResponse *response))completionBlock ErrorHandlure:(void (^)(NSError *error))failure;

@end
