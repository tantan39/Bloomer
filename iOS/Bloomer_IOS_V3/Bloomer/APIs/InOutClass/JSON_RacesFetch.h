//
//  JSON_PostUserFetches.h
//  Bloomer
//
//  Created by Ahri on 8/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"
#import "APIDefine.h"
#import "RacesObj.h"

@interface JSON_RacesFetch : NSObject <BaseJSON>

@property (assign, nonatomic) NSInteger myrank;
@property (strong, nonatomic) NSMutableArray<RacesObj *> *racesList;

@end
