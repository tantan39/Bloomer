//
//  out_banner_fetches.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 3/29/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BannerObj.h"
#import "BaseJSON.h"

@interface JSON_BannerFetch : NSObject <BaseJSON>

@property (strong, nonatomic) NSMutableArray<BannerObj *> *bannerList;

@end
