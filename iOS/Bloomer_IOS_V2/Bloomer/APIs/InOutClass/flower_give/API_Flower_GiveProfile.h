//
//  API_Flower_Give.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/18/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "flower_give_profile.h"
#import "out_flower_give.h"


@interface API_Flower_GiveProfile : BloomerRestful

@property (assign, nonatomic) NSInteger receiverID;

- (instancetype)initWithParams:(flower_give_profile *) params;


@end
