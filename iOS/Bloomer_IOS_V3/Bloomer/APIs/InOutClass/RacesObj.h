//
//  races.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 3/28/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RacesObj : NSObject

@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger uid;
@property (strong, nonatomic) NSString *username;
@property (assign, nonatomic) long long flower;
@property (assign, nonatomic) NSInteger rank;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *moCode;
@property (strong, nonatomic) NSString *spCode;
@property (strong, nonatomic) NSString *aboutme;
@property (strong, nonatomic) NSString *video_link;
@property (strong, nonatomic) NSString *gsbMedal;
@property (assign, nonatomic) BOOL is_icon;

- (id)initWithName:(NSString *)name
               uid:(NSInteger)uid
          username:(NSString *)username
            flower:(long long)flower
              rank:(NSInteger)rank
            avatar:(NSString *)avatar
            moCode:(NSString *)moCode
            spCode:(NSString *)spCode
           aboutme:(NSString *)aboutme
           video_link:(NSString *)video_link
          gsbMedal:(NSString*)gsbMedal;

@end
