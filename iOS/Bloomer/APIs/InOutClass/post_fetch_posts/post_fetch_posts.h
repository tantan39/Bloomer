//
//  post_fetch_posts.h
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/15/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"
#import "post_detail.h"

@interface post_fetch_posts : NSObject<BaseJSON>

@property(strong , nonatomic) NSMutableArray *arrayPost;

@end
