//
//  API_Profile_FollowingSearch.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/22/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "out_following_search.h"

@interface API_Profile_FollowingSearch : BloomerRestful
@property (assign, nonatomic) BOOL isLoadMore;

-(instancetype)initWithAccessToken:(NSString *)access_token
            device_token:(NSString *)device_token
              termSearch:(NSString*) term_seach;

@end
