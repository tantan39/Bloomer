//
//  API_Flower_GivePost.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/18/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "flower_give_post.h"
#import "out_flower_give.h"
@interface API_Flower_GivePost : BloomerRestful

@property (assign, nonatomic) NSInteger receiverID;
@property (assign, nonatomic) long long numberFlower;
@property (weak, nonatomic) NSString* postID;

- (instancetype) initWithParams:(flower_give_post *) params;

@end
