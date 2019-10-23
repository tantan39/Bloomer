//
//  JSON_CheckPhoneExist.h
//  Bloomer
//
//  Created by Le Chau Tu on 11/27/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"

@interface JSON_CheckPhoneExist : NSObject<BaseJSON>

@property (nonatomic, assign) BOOL is_exist;
@property (nonatomic, assign) BOOL unverify;

@end
