//
//  out_flower_give.m
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/12/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import "out_flower_give.h"

@implementation out_flower_give

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        NSDictionary *payload = [json objectForKey:k_PAYLOAD];
        _mFlower = [[payload objectForKey:k_MFLOWER] longLongValue];
        _receiver = [[payload objectForKey:k_RECEIVER] integerValue];
        _spcolor = [payload objectForKey:k_SP_COLOR];
        _mcolor = [payload objectForKey:k_MO_COLOR];
        _flower_model = [[payload objectForKey:k_FLOWER_MODEL] integerValue];
        _flower_onpost = [[payload objectForKey:k_FLOWER_ONPOST] integerValue];
        _rank_onrace = [[payload objectForKey:k_RANK_ON_RACE] integerValue];
        _bonus_flower = [[payload objectForKey:@"bonus_flower"] longLongValue];
        _flowerGivingPopupType = [[payload objectForKey:@"type"] integerValue];
        self.numGiveFlower = [[payload objectForKey:@"num_give_flower"] longLongValue];
        self.mygiveFlower = [[payload objectForKey:k_MYGIVEFLOWER] integerValue];
    }
    return self;
}

- (void)showFlowerGivingPopupIn:(id)view{
    switch (self.flowerGivingPopupType) {
        case 1:
            [DailyFlowerGivingPopUp createProcessViewInView:view finishedDay:1];
            break;
        case 2:
            [DailyFlowerGivingPopUp createProcessViewInView:view finishedDay:2];
            break;
        case 3:
            [DailyFlowerGivingPopUp createProcessViewInView:view finishedDay:3];
            break;
        case 4:
            [DailyFlowerGivingPopUp createDoubleViewInView:view];
            break;
        default:
            break;
    }
}

@end
