//
//  out_profile_gallery_fetches.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/6/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "profile_gallery.h"
#import "BaseJSON.h"

@interface out_profile_gallery_fetches : NSObject<BaseJSON>

@property (strong, nonatomic) NSMutableArray *galleryList;

@end
