//
//  API_Flower_Give.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/18/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "BaseJSON.h"
#import "flower_give.h"
#import "out_flower_give.h"

@interface API_Flower_Give : BloomerRestful

- (instancetype) initWithParams:(flower_give *) params;

@end
