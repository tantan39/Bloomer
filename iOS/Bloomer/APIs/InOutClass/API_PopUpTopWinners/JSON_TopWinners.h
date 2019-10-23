//
//  JSON_TopWinners.h
//  Bloomer
//
//  Created by Steven on 1/2/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"
#import "TopWinner.h"

@interface JSON_TopWinners : NSObject <BaseJSON>

@property (strong, nonatomic) NSMutableArray *topWinners;
@property (assign, nonatomic) NSInteger flower;

@end
