//
//  post_user.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/4/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostUserObj : NSObject

@property (strong, nonatomic) NSString *post_id;
@property (strong, nonatomic) NSString *photo_url;
@property (assign, nonatomic) BOOL isAvatar;

- (id)initWithPostID:(NSString *)post_id
            photoURL:(NSString *)photo_url
            isAvatar:(BOOL)isAvatar;

@end
