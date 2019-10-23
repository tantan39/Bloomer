//
//  reason.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/9/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface reason : NSObject

@property (assign, nonatomic) NSInteger type;
@property (strong, nonatomic) NSString *content;
@property (assign, nonatomic) NSInteger ids;
@property (assign, nonatomic) BOOL active;

- (id)initWithType:(NSInteger)type
               ids:(NSInteger)ids
            active:(BOOL)active
           content:(NSString *)content;

@end
