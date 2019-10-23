//
//  ChatSettingViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/17/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SEFilterControl.h"
#import "UserDefaultManager.h"
#import "out_profile_fetch.h"
#import "API_Setting_Update.h"
#import "FlowerMenuPostPopupViewController.h"

@interface ChatSettingViewController : UIViewController 
@property (weak, nonatomic) IBOutlet UILabel *numberFlower;
@property (assign, nonatomic) long long numFlower;
@property (weak, nonatomic) IBOutlet SEFilterControl *sliderControl;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;

@end
