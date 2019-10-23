//
//  out_gallery_fetches.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 3/30/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "gallery.h"
#import "BaseJSON.h"

@interface JSON_GalleryFetches : NSObject <BaseJSON>

@property (strong, nonatomic) NSMutableArray<gallery *> *galleryList;

@end
