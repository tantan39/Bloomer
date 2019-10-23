//
//  JSON_RaceSearch.h
//  Bloomer
//
//  Created by Le Chau Tu on 8/16/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"
#import "RacesObj.h"
#import "APIDefine.h"

@interface JSON_RaceSearch : NSObject<BaseJSON>

@property (strong, nonatomic) NSMutableArray *searchList;

@end
