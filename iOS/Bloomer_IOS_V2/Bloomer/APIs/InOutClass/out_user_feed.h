//
//  out_user_feed.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 3/31/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "feed_list.h"
#import "feed_pic.h"
#import "BaseJSON.h"
#import "out_content_post.h"

@interface out_user_feed : NSObject<BaseJSON>

@property (strong, nonatomic) NSMutableArray *feedList;

@end

@interface out_user_feed_content : NSObject<BaseJSON>

@property (strong, nonatomic) NSMutableArray *contentList;

@end
