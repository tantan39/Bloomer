//
//  out_post_user_fetches.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/4/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "post_user.h"
#import "jsonAbstractClass.h"

@interface out_post_user_fetches : jsonAbstractClass

@property (strong, nonatomic) NSMutableArray *postUserList;

@end
