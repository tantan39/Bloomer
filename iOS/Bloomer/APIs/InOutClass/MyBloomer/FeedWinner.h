//
//  FeedWinner.h
//  Bloomer
//
//  Created by Le Chau Tu on 8/11/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedWinner : NSObject

@property (assign, nonatomic) NSInteger uid;
@property (strong, nonatomic) NSString *moCode;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *spCode;
@property (strong, nonatomic) NSString *username;
@property (assign, nonatomic) NSInteger flower;


-(id) initWithUserID:(NSInteger) uid
              moCode:(NSString*)moCode
                name:(NSString*)name
              avatar:(NSString*)avatar
              spCode:(NSString*)spCode
            username:(NSString*)username
              flower:(NSInteger) flower;

@end
