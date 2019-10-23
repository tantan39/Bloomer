//
//  API_Profile_Follower_Search.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/22/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "out_follower_search.h"
#import "BaseJSON.h"

@interface API_Profile_FollowerSearch : BloomerRestful

@property (assign, nonatomic) BOOL isLoadMore;

-(instancetype)initWithAccessToken:(NSString *)access_token
            device_token:(NSString *)device_token
             term_search:(NSString *) termSearch;

@end
