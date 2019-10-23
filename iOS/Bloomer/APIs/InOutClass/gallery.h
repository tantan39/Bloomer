//
//  gallery.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 3/29/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface gallery : NSObject

@property (strong, nonatomic) NSString *post_id;
@property (strong, nonatomic) NSString *photo_url;
@property (strong, nonatomic) NSString *photo_id;
@property long mygiveflower;

- (id)initWithPostID:(NSString *)post_id
            photoURL:(NSString *)photo_url
            photo_id:(NSString *)photo_id myGiveFlower:(long) flower;

@end
