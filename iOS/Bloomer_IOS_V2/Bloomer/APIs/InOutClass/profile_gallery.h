//
//  profile_gallery.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/6/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface profile_gallery : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *key;
@property (assign, nonatomic) NSInteger status;

- (id)initWithName:(NSString *)name
               key:(NSString *)key
            status:(NSInteger )status;
@end
