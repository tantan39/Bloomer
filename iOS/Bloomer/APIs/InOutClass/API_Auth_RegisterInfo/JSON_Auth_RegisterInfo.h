//
//  JSON_Auth_RegisterInfo.h
//  Bloomer
//
//  Created by Tan Tan on 10/17/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"
@interface JSON_Auth_RegisterInfo : NSObject<BaseJSON>

@property (assign, nonatomic) NSInteger m_id;
@property (strong,nonatomic) NSDictionary * errors;

@end
