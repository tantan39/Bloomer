//
//  people_random.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 7/23/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "BaseJSON.h"

@interface people_random : NSObject<BaseJSON>

@property (assign, nonatomic) NSInteger uid;
@property (strong, nonatomic) NSString* avatar;
@property (strong, nonatomic) NSString* color_code;

@end
