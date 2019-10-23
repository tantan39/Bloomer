//
//  Json_InviteCode.h
//  Bloomer
//
//  Created by Steven on 12/21/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"

@interface Json_InviteCode : NSObject<BaseJSON>

@property (strong, nonatomic) NSString* user_code;
@property (assign, nonatomic) long invite_flower;

@end
