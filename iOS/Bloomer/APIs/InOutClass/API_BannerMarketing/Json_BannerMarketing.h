//
//  Json_BannerMarketing.h
//  Bloomer
//
//  Created by Steven on 7/16/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BaseJSON.h"
#import "BannerMarketing.h"

@interface Json_BannerMarketing : NSObject <BaseJSON>

@property (strong, nonatomic) NSMutableArray *banners;

@end
