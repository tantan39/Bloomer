//
//  out_avatars_fetches.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/19/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "avatar.h"
#import "BaseJSON.h"

@interface out_avatars_fetches : NSObject<BaseJSON>

@property (strong, nonatomic) NSMutableArray *avatarList;

@end
