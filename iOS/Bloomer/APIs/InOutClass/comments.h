//
//  comments.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/15/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface comments : NSObject

@property (assign, nonatomic) NSInteger uid;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *content;
@property (assign, nonatomic) long long timestamp;

- (id)initWithName:(NSString *)name
            avatar:(NSString *)avatar
          username:(NSString *)username
           content:(NSString *)content
               uid:(NSInteger)uid
         timestamp:(long long)timestamp;

@end
