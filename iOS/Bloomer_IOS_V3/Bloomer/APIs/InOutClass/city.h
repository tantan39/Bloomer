//
//  city.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 3/22/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"
#import "APIDefine.h"
@interface city : NSObject<BaseJSON>

@property (strong, nonatomic) NSString *city_name;
@property (strong, nonatomic) NSString *city_short_name;
@property (assign, nonatomic) NSInteger city_id;

@end
