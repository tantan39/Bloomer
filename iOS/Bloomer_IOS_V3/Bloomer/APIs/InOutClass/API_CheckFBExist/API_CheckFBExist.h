//
//  API_CheckFBExist.h
//  Bloomer
//
//  Created by Le Chau Tu on 11/27/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "JSON_CheckFBExist.h"
#import "CheckFBExistParams.h"

@interface API_CheckFBExist : BloomerRestful

-(id)initWithParams:(CheckFBExistParams*)params;

@end
