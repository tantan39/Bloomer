//
//  API_PostComment.m
//  Bloomer
//
//  Created by Tran Thai Tan on 10/2/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_PostComment.h"

@implementation API_PostComment
- (instancetype)initWithParam:(post_comment *)param{
    
    self = [super initWith:[APIDefine post_commentLink] Params:[param encodeToJSON]];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    
    if (json) {
        return  (BaseJSON *)[[out_post_comment alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[out_post_comment alloc] init];
}
@end
