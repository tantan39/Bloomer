//
//  BloomerRestful.m
//  Bloomer
//
//  Created by Tran Thai Tan on 7/24/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "AppDelegate.h"

@interface BloomerRestful()
{
    AFHTTPSessionManager * sessionManager;
    RequestURL * _requestURL;
}

@end

@implementation BloomerRestful
@synthesize _params;

- (instancetype)initWith:(RequestURL *)requestURL Params:(NSDictionary *)params{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration * configure = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configure];
        sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        sessionManager.requestSerializer.timeoutInterval = 30.0;
        [self setHeaderForRequest:sessionManager.requestSerializer];
        _requestURL = requestURL;
        _params = params;
    }
    
    return self;
}

- (void)setHeaderForRequest:(AFHTTPRequestSerializer *) request{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *secretAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    NSString *tzName = [timeZone name];
    [request setValue:tzName forHTTPHeaderField:@"time_zone"];
    NSString *locale = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
    [request setValue:locale forHTTPHeaderField:@"locale"];
    NSString* version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [request setValue:version forHTTPHeaderField:@"version"];
    [request setValue:secretAgent forHTTPHeaderField:@"User-Agent"];
}

- (void)postParamToHeader:(id)params forKey:(NSString *)key{
    
    [sessionManager.requestSerializer setValue:params forHTTPHeaderField:key];
}

//- (RequestURL *)getRequestURL{
//    return _requestURL ? _requestURL : nil;
//}

//- (NSDictionary *)getParameter{
//    return _params ? _params : nil;
//}

- (void)request:(void (^)(BaseJSON *jsonObject, RestfulResponse *response))completionBlock ErrorHandlure:(void (^)(NSError *error))failure
{
    NSLog(@"%@", _requestURL.url);
    switch (_requestURL.requestMethod)
    {
        case GET:
        {
            [self getRequest:^(BaseJSON *json, RestfulResponse *response) {
                completionBlock(json, response);
            } ErrorHandlure:^(NSError *error) {
                failure(error);
            }];
            break;
        }
        case POST:
        {
            [self postRequest:^(BaseJSON *json, RestfulResponse *response) {
                completionBlock(json, response);
            } ErrorHandlure:^(NSError *error) {
                failure(error);
            }];
            break;
        }
        case DELETE:
        {
            [self deleteRequest:^(BaseJSON *json, RestfulResponse *response) {
                completionBlock(json, response);
            } ErrorHandlure:^(NSError *error) {
                failure(error);
            }];
            break;
        }
        case PUT:
        {
            [self putRequest:^(BaseJSON *json, RestfulResponse *response) {
                completionBlock(json, response);
            } ErrorHandlure:^(NSError *error) {
                failure(error);
            }];
            break;
        }
    }
}

- (void) getRequest:(void (^)(BaseJSON *, RestfulResponse *))completionBlock ErrorHandlure:(void (^)(NSError *))failure {
    
    [sessionManager GET:_requestURL.url parameters:_params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (responseObject) {
            NSLog(@"%@ - %@", _requestURL.url, responseObject);
            RestfulResponse * restfulResponse = [[RestfulResponse alloc] initWithJSON:responseObject];
            BaseJSON * objJSON =  [self handleJSON:responseObject];
            [self handleResponse:restfulResponse];
            completionBlock(objJSON,restfulResponse);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleFailureRequest:error];
        failure(error);
    }];
}

- (void)postRequest:(void (^)(BaseJSON *, RestfulResponse *))completionBlock ErrorHandlure:(void (^)(NSError *))failure{
    
    if (!self.dataImage) {
        [sessionManager POST:_requestURL.url parameters:_params success:^(NSURLSessionDataTask *task, id responseObject) {
            
            if (responseObject) {
                NSLog(@"%@ - %@", _requestURL.url, responseObject);
                RestfulResponse * restfulResponse = [[RestfulResponse alloc] initWithJSON:responseObject];
                BaseJSON *objJSON =  [self handleJSON:responseObject];
                [self handleResponse:restfulResponse];
                completionBlock(objJSON,restfulResponse);
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self handleFailureRequest:error];
            
//            [AppHelper showMessageBox:[AppHelper getLocalizedString:@"NoInternetConnection"] message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
            failure(error);
        }];
    }else{
        [sessionManager POST:_requestURL.url parameters:_params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFormData:self.dataImage name:k_UPLOAD];
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            if (responseObject) {
                RestfulResponse * restfulResponse = [[RestfulResponse alloc] initWithJSON:responseObject];
                BaseJSON * objJSON =  [self handleJSON:responseObject];
                [self handleResponse:restfulResponse];
                completionBlock(objJSON,restfulResponse);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self handleFailureRequest:error];
//            [AppHelper showMessageBox:[AppHelper getLocalizedString:@"NoInternetConnection"] message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
            failure(error);
        }];
    }
}

- (void)putRequest:(void (^)(BaseJSON *, RestfulResponse *))completionBlock ErrorHandlure:(void (^)(NSError *))failure{
    
    [sessionManager PUT:_requestURL.url parameters:_params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (responseObject) {
            
            RestfulResponse * restfulResponse = [[RestfulResponse alloc] initWithJSON:responseObject];
            BaseJSON * objJSON =  [self handleJSON:responseObject];
            [self handleResponse:restfulResponse];
            completionBlock(objJSON,restfulResponse);
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleFailureRequest:error];
//        [AppHelper showMessageBox:[AppHelper getLocalizedString:@"NoInternetConnection"] message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        failure(error);
    }];
    
}

- (void)deleteRequest:(void (^)(BaseJSON *, RestfulResponse *))completionBlock ErrorHandlure:(void (^)(NSError *))failure {
    
    [sessionManager DELETE:_requestURL.url parameters:_params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (responseObject) {
            RestfulResponse * restfulResponse = [[RestfulResponse alloc] initWithJSON:responseObject];
            BaseJSON * objJSON = [self handleJSON:responseObject];
            [self handleResponse:restfulResponse];
            completionBlock(objJSON, restfulResponse);
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleFailureRequest:error];
//        [AppHelper showMessageBox:[AppHelper getLocalizedString:@"NoInternetConnection"] message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        failure(error);
    }];
    
}

- (void) handleFailureRequest:(NSError *) error{
    if (error) {

        NSString * messageError =  [NSString stringWithFormat:@"%@", [error.userInfo objectForKey:@"NSLocalizedDescription"]];
        ErrorMessageView* messView = [[ErrorMessageView alloc]initWithMessage:messageError];
        [[[[UIApplication sharedApplication] windows] lastObject] addSubview:messView];
    }
}

- (void)cancelCurrentRequest{
    if (sessionManager.requestSerializer) {
        [sessionManager.operationQueue cancelAllOperations];
    }
}

- (void) handleResponse:(RestfulResponse *) response{
    if (!response.status )
    {
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        switch (response.code) {
            case 301: // invalid session
            case 304: // invalid token
            case 412: // account block
            { // LOG OUT
                
                if( appDelegate.isTokenRefreshing)
                    return;
                UserDefaultManager *userDefaultManager = [[UserDefaultManager alloc] init];
                [userDefaultManager removeAccessToken];
                [userDefaultManager removeCredentialEjab];
                [userDefaultManager removeAuthSession];
                [userDefaultManager removeIsUpdateInformation];
                [userDefaultManager removeRefresh_Token];
                [userDefaultManager saveTransactionID:@""];
                
                [self cancelCurrentRequest];
//                [appDelegate.pullAPITimer invalidate];
                [appDelegate.badgeNumber removeFromSuperview];
                [appDelegate.chatBadgeNumber removeFromSuperview];
                
                SelectScreenViewController *screenSelectVC = [[SelectScreenViewController alloc] initWithNibName:@"SelectScreenViewController" bundle:nil];
                
                UINavigationController *navController = (UINavigationController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
                
                for (UIViewController* viewController in navController.visibleViewController.navigationController.viewControllers)
                {
                    if ([viewController isKindOfClass:[TabBarViewController class]])
                    {
                        TabBarViewController* view = (TabBarViewController*)viewController;
                        [view.navigationController setNavigationBarHidden:YES animated:YES];
                        [view.navigationController setViewControllers:[NSArray arrayWithObject:screenSelectVC] animated:TRUE];
                        
                        for (UIView *sub in [[[UIApplication sharedApplication] delegate] window].subviews)
                        {
                            if ([sub isKindOfClass:[TabBarView class]])
                            {
                                [sub removeFromSuperview];
                                break;
                            }
                        }
                        
                        for (UIView *view in [[[UIApplication sharedApplication] delegate] window].subviews) {
                            if ([view isKindOfClass:[MKNumberBadgeView class]])
                            {
                                MKNumberBadgeView* badgeNumber = (MKNumberBadgeView*)view;
                                [badgeNumber removeFromSuperview];
                                break;
                            }
                        }
                        
                        return;
                    }
                }
                [navController setViewControllers:[NSArray arrayWithObject:screenSelectVC] animated:TRUE];
//                [AppHelper showMessageBox:NSLocalizedString(@"Alert.Title.ErrorMessage", nil) message:response.message];
                ErrorMessageView* messView = [[ErrorMessageView alloc]initWithMessage:response.message];
                [[[[UIApplication sharedApplication] windows] lastObject] addSubview:messView];
            }
                break;
            case 403: // EXPIRED
            {
                [self cancelCurrentRequest];
                [appDelegate.pendingRequests addObject:self];
                
                [appDelegate refreshToken];
            }
                break;
            case 409:
            case 472:
            case 426:
            case 415:
            case 432:
            {
                
            }
                break;
            default:
            {
                //                ErrorMessageView* messView = [[ErrorMessageView alloc]initWithMessage:[self->outputBehavior getMegs]];
                //                [[[[UIApplication sharedApplication] windows] lastObject] addSubview:messView];
            }
                break;
        }
    }
}



@end
