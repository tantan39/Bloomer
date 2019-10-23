//
//  JSON_PopUpMarketing.h
//  Bloomer
//
//  Created by Steven on 4/12/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PopUpMarketing.h"
#import "BaseJSON.h"

@interface JSON_PopUpMarketing : NSObject<BaseJSON>

@property (strong, nonatomic) NSMutableArray *popUps;

@end
