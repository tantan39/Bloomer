//
//  photo.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/20/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface photo : NSObject

@property (strong, nonatomic) NSString *post_id;
@property (strong, nonatomic) NSString *photo_id;
@property (strong, nonatomic) NSString *photo_url;
@property (strong, nonatomic) NSString *photo_url_fullSize;

- (id)initWithPostID:(NSString *)post_id
            photo_id:(NSString *)photo_id
           photo_url:(NSString *)photo_url photo_url_fullSize:(NSString *) photo_url_fullSize;

@end
