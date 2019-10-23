//
//  feed_pic.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/14/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface feed_pic : NSObject

@property (strong, nonatomic) NSString *photo_id;
@property (strong, nonatomic) NSString *photo_url;
@property (assign, nonatomic) long long mygiveflower;

- (id)initWithPhotoID:(NSString *)photo_id
            photo_url:(NSString *)photo_url
         mygiveflower:(long long)mygiveflower;

@end
