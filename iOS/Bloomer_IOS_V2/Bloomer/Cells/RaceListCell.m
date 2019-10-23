//
//  RaceListCell.m
//  Bloomer
//
//  Created by Steven on 12/17/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "RaceListCell.h"
#import "JoinInfoPopupViewController.h"
#import "JoinRaceByTopicView.h"
#import "AppHelper.h"
#import "NotificationHelper.h"

@implementation RaceListCell
{
    JoinInfoPopupViewController *joinPopup;
    JoinRaceByTopicView *  joinRaceView;
}

+ (CGFloat)cellHeight
{
    return 200;
}

+ (NSString*)cellIdentifier
{
    return @"RaceListCell";
}

+ (NSString*)nibName
{
    return @"RaceListCell";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    self.mainView.layer.borderColor = [UIColor colorFromHexString:@"#EFEFEF"].CGColor;
    self.mainView.layer.borderWidth = 2;
    self.mainView.layer.cornerRadius = 10;
    
    self.buttonJoin.layer.cornerRadius = self.buttonJoin.frame.size.height / 2;
    self.buttonJoin.clipsToBounds = true;
    self.buttonJoin.layer.borderColor = [UIColor colorFromHexString:@"#5ED769"].CGColor;
    self.buttonJoin.layer.borderWidth = 1;
    
    self.buttonSwitch.layer.cornerRadius = self.buttonSwitch.frame.size.height / 2;
    self.buttonSwitch.clipsToBounds = true;
    self.buttonSwitch.layer.borderColor = [UIColor colorFromHexString:@"#5ED769"].CGColor;
    self.buttonSwitch.layer.borderWidth = 1;
    
    [self.buttonJoin setTitle:[AppHelper getLocalizedString:@"RaceList.buttonJoin"] forState:UIControlStateNormal];
    [self.buttonSwitch setTitle:[AppHelper getLocalizedString:@"RaceList.buttonSwitch"] forState:UIControlStateNormal];
}

- (void)switchActionView:(RaceListState)state
{
    switch (state) {
        case Joined:
            self.iconJoinedRace.hidden = false;
            self.buttonSwitch.hidden = true;
            self.buttonJoin.hidden = true;
            self.actionViewWidth.constant = 50;
            break;
            
        case Switch:
            self.iconJoinedRace.hidden = true;
            self.buttonSwitch.hidden = false;
            self.buttonJoin.hidden = true;
            self.actionViewWidth.constant = 50;
            break;
            
        case NotJoined:
            self.iconJoinedRace.hidden = true;
            self.buttonSwitch.hidden = true;
            self.buttonJoin.hidden = false;
            self.actionViewWidth.constant = 50;
            break;
            
        case Closed:
            self.iconJoinedRace.hidden = true;
            self.buttonSwitch.hidden = true;
            self.buttonJoin.hidden = true;
            self.actionViewWidth.constant = 0;
            break;
    }
}

- (IBAction)touchButtonJoin:(id)sender {
    [NotificationHelper postNotificationForTouchingJoinButton:self.raceData gender:self.gender];
}

- (IBAction)TouchButtonGift:(id)sender {
    [NotificationHelper postNotificationForOpeningRaceInfoLink:self.raceData.gift raceName:self.raceData.name];
}

@end
