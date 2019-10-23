//
//  out_blocklists_fetches.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/30/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "blockers.h"
#import "BaseJSON.h"
#import "APIDefine.h"

@interface out_blocklists_fetches : NSObject<BaseJSON>

@property (strong, nonatomic) NSMutableArray *blockList;

@end
