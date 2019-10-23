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
#import "WinnerObj.h"

@interface JSON_WinnersClub : NSObject <BaseJSON>

@property (strong, nonatomic) NSMutableArray<WinnerObj *> *winners;

@end
