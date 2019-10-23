//
//  JoinRaceByTopicView.h
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 12/20/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDefaultManager.h"
#import "ImagePickerRaceViewController.h"
#import "API_Profile_Location.h"
#import "API_JoinRace.h"

@interface JoinRaceByTopicView : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *ImageRace;
@property (weak, nonatomic) IBOutlet UIImageView *BottomImageRace;
@property (weak, nonatomic) IBOutlet UILabel *RaceName;
@property (weak, nonatomic) IBOutlet UILabel *DateEnd;
@property (weak, nonatomic) IBOutlet UIWebView *ContentWeb;
@property (weak, nonatomic) IBOutlet UIButton *jointButton;

@property (weak, nonatomic) NSString *rules;
@property (weak, nonatomic) NSString *raceNames;
@property (assign, nonatomic) long long endTimes;
@property (weak, nonatomic) UIViewController *parentView;
@property (weak, nonatomic) NSString *key;
@property (assign, nonatomic) NSInteger gender;
@property (assign, nonatomic) NSInteger locationID;
@property (assign, nonatomic) NSInteger categoryType;
@property (assign, nonatomic) NSString *sEndTime;
@property (weak, nonatomic) NSString *avatar;
@property (weak, nonatomic) UINavigationController *myNavigationController;

@property (weak, nonatomic) TabBarView *tabbar;
@property (assign, nonatomic) NSInteger gsb;
@property (strong, nonatomic) void (^OnRaceJoined)();

@end
