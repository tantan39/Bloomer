//
//  RestfulResponse.m
//  Bloomer
//
//  Created by Tran Thai Tan on 7/24/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "RestfulResponse.h"

@implementation RestfulResponse
@synthesize status,message,code,expireTime,isExpired;

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {

        if (json == nil) {
            status = FALSE;
            self.message = [AppHelper getLocalizedString:@"NoInternetConnection"];

        } else {
            status = [[json objectForKey:k_STATUS] boolValue];
            
            if (!status) {

                NSDictionary *dic = [json objectForKey:@"error"];
                
                self.message = [dic objectForKey:k_MSG];
                self.nameError = [dic objectForKey:kNameError];
                self.phoneError = [dic objectForKey:kPhoneError];
                self.emailError = [dic objectForKey:kEmailError];
                
                code = [[dic objectForKey:k_CODE] integerValue];
                
                if ([dic objectForKey:k_EXPIRED_TIME] != [NSNull null]) {
                    expireTime = [[dic objectForKey:k_EXPIRED_TIME] integerValue];
                }
                
            } else {
                status = YES;
                if ([json objectForKey:k_IS_EXPIRED] != [NSNull null]) {
                    isExpired = [[json objectForKey:k_IS_EXPIRED] boolValue];
                }
            }
        }

    }
    
    return self;
}

@end
