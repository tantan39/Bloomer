//
//  childs.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 3/28/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface childs : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *key;

- (id)initWithName:(NSString *)name
               key:(NSString *)key;

@end
