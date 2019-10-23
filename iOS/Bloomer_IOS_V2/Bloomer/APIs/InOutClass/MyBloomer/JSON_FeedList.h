//
//  JSON_FeedList.h
//  Bloomer
//
//  Created by Le Chau Tu on 8/10/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"
#import "APIDefine.h"
#import "Feed.h"
#import "PostTag.h"

@interface JSON_FeedList : NSObject<BaseJSON>

@property (strong, nonatomic) NSMutableArray *feeds;

@end
