//
//  blockers.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/30/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface blockers : NSObject

@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger uid;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *username;

- (id)initWithName:(NSString *)name
               uid:(NSInteger)uid
            avatar:(NSString *)avatar
          username:(NSString *)username;

@end
