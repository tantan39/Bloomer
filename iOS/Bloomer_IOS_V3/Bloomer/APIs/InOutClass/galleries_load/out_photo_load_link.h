//
//  out_photo_load_link.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 7/23/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"
#import "galleries_photo.h"

@interface out_photo_load_link : NSObject<BaseJSON>

@property (strong, nonatomic) NSMutableArray *photos;

@end
