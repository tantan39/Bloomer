//
//  JSON_CheckFBExist.h
//  Bloomer
//
//  Created by Le Chau Tu on 11/27/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "out_auth_authorize.h"

@interface JSON_CheckFBExist : out_auth_authorize<BaseJSON>

@property (nonatomic, assign) BOOL is_exist,unverify;
@property (strong, nonatomic) out_auth_authorize * user;

-(id)initWithJSON:(NSDictionary *)json;

@end
