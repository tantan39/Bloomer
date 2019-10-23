//
//  API_Sponsor_Post_Fetch.m
//  Bloomer
//
//  Created by Tran Thai Tan on 10/6/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Sponsor_Post_Fetch.h"

@implementation API_Sponsor_Post_Fetch

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token post_id:(NSString *)post_id min:(NSInteger)minValue max:(NSInteger)maxValue{

    NSDictionary * params = @{k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token,
                              k_POST_ID : post_id,
                              k_MIN : [NSString stringWithFormat:@"%ld", (long)minValue],
                              k_MAX : [NSString stringWithFormat:@"%ld", (long)maxValue]
                              };
    
    self = [super initWith:[APIDefine sponsor_post_fetchLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return (BaseJSON *)[[out_sponsor_fetch alloc] initWithJSON:json];
    }
    return (BaseJSON *)[[out_sponsor_fetch alloc] init];
}

@end
