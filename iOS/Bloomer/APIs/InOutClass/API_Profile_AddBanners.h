//
//  API_Profile_AddBanners.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/24/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "BaseJSON.h"
#import "banners_add.h"
#import "out_banner_add.h"

@interface API_Profile_AddBanners : BloomerRestful

- (instancetype)initWithParams:(banners_add *) params;

@end
