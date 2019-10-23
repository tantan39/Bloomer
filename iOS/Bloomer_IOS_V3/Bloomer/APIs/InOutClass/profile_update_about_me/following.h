//
//  following.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/4/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreSpotlight/CoreSpotlight.h>
#import <UIKit/UIKit.h>

@interface following : NSObject

@property (assign, nonatomic) NSInteger uid;
@property (assign, nonatomic) BOOL is_follow;
@property (strong, nonatomic) NSString *mocode;
@property (assign, nonatomic) long long gave_flower;
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) BOOL is_chat;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *spcode;
@property (strong, nonatomic) NSString *username;
@property (assign, nonatomic) BOOL matchingFlower;

- (id)initWithUid:(NSInteger)uid isFollow:(BOOL)isFollow mocode:(NSString *)mocode gaveFlower:(long long)gave_flower name:(NSString *)name isChat:(BOOL)is_chat avatar:(NSString *)avatar spcode:(NSString *)spcode username:(NSString *)username matchingFlower:(BOOL)matchingFlower;
- (CSSearchableItemAttributeSet*)searchableItemAttributeSet;
- (CSSearchableItem*)searchableItem;
@end
