//
//  RaceListView.m
//  Bloomer
//
//  Created by Steven on 1/20/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "RaceListView.h"
#import "AppHelper.h"
#import "JoinRaceByTopicView.h"
#import "JoinInfoPopupViewController.h"
#import "NotificationHelper.h"

@implementation RaceListView

+ (CGSize)viewSize
{
    return CGSizeMake(150, 200);
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.titleView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.titleView.layer.borderWidth = 2;
    
    self.buttonJoin.layer.cornerRadius = self.buttonJoin.frame.size.height / 2;
    self.buttonJoin.layer.borderColor = [UIColor whiteColor].CGColor;
    self.buttonJoin.layer.borderWidth = 1;
    self.buttonJoin.clipsToBounds = true;
    
    self.mainView.layer.borderColor = [UIColor colorFromHexString:@"#EFEFEF"].CGColor;
    self.mainView.layer.borderWidth = 2;
    self.mainView.layer.cornerRadius = 10;
    
    [self.labelTitle sizeToFit];
    
    UIImage *btnVideoImage = [[UIImage imageNamed:@"Btn_video"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.buttonVideo setImage:btnVideoImage forState:UIControlStateNormal];
    self.buttonVideo.tintColor = UIColor.whiteColor;
    
    UIImage *btnGiftImage = [[UIImage imageNamed:@"ic_gift"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.ButtonGift setImage:btnGiftImage forState:UIControlStateNormal];
    self.ButtonGift.tintColor = UIColor.whiteColor;
}

- (IBAction)touchButtonGift:(id)sender {
    [NotificationHelper postNotificationForOpeningRaceInfoLink:self.raceData.gift raceName:self.raceData.name];
}

- (IBAction)touchButtonJoin:(id)sender
{
    if (self.raceData) {
        [NotificationHelper postNotificationForTouchingJoinButton:self.raceData gender:self.gender];
    }
}

- (IBAction)touchButtonProfile:(id)sender
{
    if (self.raceData.key) {
        [NotificationHelper postNotificationForGoingToSpecificRace:self.gender key:self.raceData.key timeStampKey:nil];
    }
}

- (IBAction)touchButtonVideo:(id)sender {
    [NotificationHelper postNotificationForOpeningVideo:self.raceData.video_link];
}

- (void)switchActionView:(RaceListState)state
{
    switch (state)
    {
        case Joined:
            self.iconJoinedRace.hidden = false;
            self.buttonJoin.hidden = true;
            self.actionViewWidth.constant = 50;
            break;
            
        case Switch:
            self.iconJoinedRace.hidden = true;
            self.buttonJoin.hidden = false;
            [self.buttonJoin setTitle:[AppHelper getLocalizedString:@"RaceList.buttonSwitch"] forState:UIControlStateNormal];
            
            self.actionViewWidth.constant = 50;
            break;
            
        case NotJoined:
            self.iconJoinedRace.hidden = true;
            self.buttonJoin.hidden = false;
            [self.buttonJoin setTitle:[AppHelper getLocalizedString:@"RaceList.buttonJoin"] forState:UIControlStateNormal];
            
            self.actionViewWidth.constant = 50;
            break;
            
        case Closed:
            self.iconJoinedRace.hidden = true;
            self.buttonJoin.hidden = true;
            self.actionViewWidth.constant = 0;
            break;
    }
}


@end
