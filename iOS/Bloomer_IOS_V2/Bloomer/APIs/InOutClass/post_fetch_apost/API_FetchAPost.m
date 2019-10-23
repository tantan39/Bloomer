//
//  API_Post_FetchAPost.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/1/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_FetchAPost.h"

@implementation API_FetchAPost

- (id)initWithAccessToken:(NSString *)access_token Device_Token:(NSString *)device_token postID:(NSString *)postID cmin:(NSInteger)cmin cmax:(NSInteger)cmax{
    
    NSDictionary * params = @{
                              k_POST_ID : postID,
                              k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token,
                              k_CMIN : [NSNumber numberWithInteger:cmin],
                              k_CMAX : [NSNumber numberWithInteger:cmax]
                              };
    
    self = [super initWith:nil Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    out_post_fetch_apost * model;
    if (json) {
        model = [[out_post_fetch_apost alloc] initWithJSON:json];
    }
    return (BaseJSON *) model;
    
}

@end
