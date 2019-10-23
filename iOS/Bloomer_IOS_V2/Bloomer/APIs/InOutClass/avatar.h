//
//  avatar.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/19/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface avatar : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *photo_url;
@property (assign, nonatomic) NSInteger categoryID;

- (id)initWithName:(NSString *)name
               key:(NSString *)key
          phptoURL:(NSString *)photo_url
          category:(NSInteger)categoryID;

@end
