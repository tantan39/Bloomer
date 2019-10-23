//
//  out_flower_give.h
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/12/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"
#import "DailyFlowerGivingPopUp.h"
@interface out_flower_give : NSObject<BaseJSON>

@property (assign, nonatomic) long long mFlower;
@property (assign, nonatomic) NSInteger receiver;
@property (strong, nonatomic) NSString *spcolor;
@property (strong, nonatomic) NSString *mcolor;
@property (assign, nonatomic) NSInteger flower_model;
@property (assign, nonatomic) NSInteger flower_onpost;
@property (assign, nonatomic) NSInteger mygiveFlower;
@property (assign, nonatomic) NSInteger rank_onrace;

@property (assign, nonatomic) long long my_nFlower;
@property (assign, nonatomic) NSInteger rank;
@property (assign, nonatomic) long long num_flower;
@property (assign, nonatomic) NSInteger isFav;
@property (assign, nonatomic) BOOL is_chat;
@property (assign, nonatomic) long long model_nflower;
@property (assign, nonatomic) long long numGiveFlower;

@property (assign, nonatomic) float bonus_flower;
@property (assign,nonatomic) NSInteger flowerGivingPopupType;

- (void) showFlowerGivingPopupIn:(id) view;

@end
