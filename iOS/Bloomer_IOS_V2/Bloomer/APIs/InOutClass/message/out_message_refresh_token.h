//
//  out_message_refresh_token.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/3/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"

@interface out_message_refresh_token : NSObject<BaseJSON>

@property (weak, nonatomic) NSString* auth_session;

@end
