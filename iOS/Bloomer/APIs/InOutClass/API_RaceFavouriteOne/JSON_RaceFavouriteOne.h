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
#import "RaceFavouriteObj.h"

@interface JSON_RaceFavouriteOne : NSObject <BaseJSON>

@property (strong, nonatomic) NSMutableArray<RaceFavouriteObj *> *favourites;

@end
