//
//  out_banner_add.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/20/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"
//#import "jsonAbstractClassProtected.h"

@interface out_banner_add : NSObject<BaseJSON>

@property (strong, nonatomic) NSMutableArray *bannerList;

@end
