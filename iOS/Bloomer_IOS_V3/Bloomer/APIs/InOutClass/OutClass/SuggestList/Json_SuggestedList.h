//
//  Json_SuggestedList.h
//  Bloomer
//
//  Created by Steven on 12/19/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "jsonAbstractClass.h"
#import "BaseJSON.h"
#import "SuggestedPerson.h"

@interface Json_SuggestedList : NSObject<BaseJSON>

@property (strong, nonatomic) NSMutableArray *suggestedPeople;

@end
