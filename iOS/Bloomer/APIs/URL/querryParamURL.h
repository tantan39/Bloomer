//
//  querryParamURL.h
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/10/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UrlWrapper.h"

@interface querryParamURL : UrlWrapper {
    @protected NSMutableArray *params;
}

- (id)init;
- (id)initWithUrl:(NSString *)linkUrl andparams:(NSMutableArray *)parameter;

@end
