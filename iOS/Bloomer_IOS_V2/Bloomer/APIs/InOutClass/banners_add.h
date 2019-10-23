//
//  banners_add.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/20/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseJSON.h"

@interface banners_add : NSObject<BaseJSON>

@property (strong, nonatomic) NSString *access_token;
@property (strong, nonatomic) NSString *device_token;
@property (strong, nonatomic) NSMutableArray *posts;
@property (strong, nonatomic) NSMutableArray *croppedRects;

- (id)initWithAccessToken:(NSString *)access_token
             device_token:(NSString *)device_token
                    posts:(NSMutableArray *)posts
              croppedRects:(NSMutableArray *)croppedRects;

@end
