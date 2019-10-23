//
//  PostContent.h
//  Bloomer
//
//  Created by Le Chau Tu on 8/11/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedProfile.h"
#import "PostContent.h"

@interface Post : NSObject

@property (strong, nonatomic) FeedProfile *profile;
@property (strong, nonatomic) PostContent *content;

-(id)initWithContent:(PostContent*)content profile:(FeedProfile*)profile;

@end
