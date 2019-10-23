//
//  SuggestedPerson.h
//  Bloomer
//
//  Created by Steven on 12/19/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SuggestedPerson : NSObject

@property (assign, nonatomic) NSInteger uid;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *username;

- (id)initWithUID:(NSInteger)uid name:(NSString*)name avatar:(NSString*)avatar username:(NSString*)username;

@end
