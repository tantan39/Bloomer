//
//  out_profile_post_fetches.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/20/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "photo.h"
#import "BaseJSON.h"

@interface out_profile_post_fetches : NSObject<BaseJSON>

@property (strong, nonatomic) NSMutableArray *photoList;

@end
