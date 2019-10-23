//
//  API_Post_FetchAPost.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/1/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "APIDefine.h"
#import "out_post_fetch_apost.h"
@interface API_FetchAPost : BloomerRestful
-(id)initWithAccessToken:(NSString *)access_token Device_Token:(NSString*)device_token postID:(NSString*)postID cmin:(NSInteger)cmin cmax:(NSInteger)cmax;

@end
