//
//  JSON_GetVerifyCode.h
//  Bloomer
//
//  Created by Tan Tan on 3/6/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"
@interface JSON_GetVerifyCode : NSObject<BaseJSON>

@property (assign, nonatomic) NSInteger m_id;
@property (assign, nonatomic) BOOL unverify;

@end
