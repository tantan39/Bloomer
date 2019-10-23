//
//  Json_VerifyInviteCode.h
//  Bloomer
//
//  Created by Phan Van Thanh Dat on 10/15/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"

@interface Json_VerifyInviteCode : NSObject<BaseJSON>

@property (assign, nonatomic) NSInteger flower;
@property (strong, nonatomic) NSString *message;

@end
