//
//  JSON_Discovery_Fetches.h
//  Bloomer
//
//  Created by Ahri on 8/11/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"
#import "DiscoveryModel.h"
#import "feed_pic.h"

@interface JSON_DiscoveryFetches : NSObject<BaseJSON>

@property (strong, nonatomic) NSMutableArray<DiscoveryModel *> *discoveryList;

@end
