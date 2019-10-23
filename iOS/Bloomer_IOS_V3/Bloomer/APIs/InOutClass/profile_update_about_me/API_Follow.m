//
//  API_Follow.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/14/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Follow.h"

@implementation API_UnFollow

- (instancetype)initWithParams:(block_remove *)params{
    self = [super initWith:[APIDefine profile_unFollowLink] Params:[params encodeToJSON]];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return  (BaseJSON *)[[out_name_update alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[out_name_update alloc] init];
}

@end

//MARK: - API_ReFollow
@implementation API_ReFollow

- (instancetype)initWithParams:(block_remove *)params{
    self = [super initWith:[APIDefine profile_reFollowLink] Params:[params encodeToJSON]];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return  (BaseJSON *)[[out_name_update alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[out_name_update alloc] init];
}

@end
