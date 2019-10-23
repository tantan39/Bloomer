//
//  PostTag.h
//  Bloomer
//
//  Created by Le Chau Tu on 8/10/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostTag : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *key;

-(id)initWithName:(NSString*)name key:(NSString*)key;

@end
