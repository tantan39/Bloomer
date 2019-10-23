//
//  BaseJSON.h
//  Bloomer
//
//  Created by Tran Thai Tan on 7/25/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIDefine.h"

@protocol BaseJSON <NSObject>
@optional
- (instancetype) initWithJSON:(NSDictionary *) json;

- (NSDictionary *) encodeToJSON;

@end
