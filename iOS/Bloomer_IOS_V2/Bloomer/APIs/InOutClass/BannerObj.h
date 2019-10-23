//
//  banner.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 3/29/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BannerObj : NSObject

@property (strong, nonatomic) NSString *photo_id;
@property (strong, nonatomic) NSString *photo_url;
@property (strong, nonatomic) NSString *post_id;
@property (assign, nonatomic) NSInteger uid;
@property (assign, nonatomic) NSInteger rank;
@property (assign, nonatomic) CGFloat x1;
@property (assign, nonatomic) CGFloat y1;
@property (assign, nonatomic) CGFloat x2;
@property (assign, nonatomic) CGFloat y2;

- (id)initWithUid:(NSInteger)uid
             rank:(NSInteger)rank
          photoID:(NSString *)photo_id
         photoURL:(NSString *)photo_url
           postID:(NSString *)post_id
               x1:(CGFloat)x1
               y1:(CGFloat)y1
               x2:(CGFloat)x2
               y2:(CGFloat)y2;

@end
