//
//  JSON_Auth_Expired.h
//  Bloomer
//
//  Created by Le Chau Tu on 12/13/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"

@interface JSON_Auth_Expired : NSObject<BaseJSON>

@property (nonatomic, assign) BOOL is_expired;

@end
