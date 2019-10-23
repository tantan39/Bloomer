//
//  CountryAvatar.h
//  Bloomer
//
//  Created by Tran Thai Tan on 7/11/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIDefine.h"

@interface CountryAvatar : NSObject

@property NSString * urlAvatar;
@property NSString * child;
@property NSString * name;

- (instancetype) initWithJSON:(NSDictionary *) json;

@end
