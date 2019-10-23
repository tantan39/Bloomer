//
//  RaceListsTableViewCell.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 1/26/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "RaceListsTableViewCell.h"
#import "LeavingRacePopUpViewController.h"
#import "JoinInfoPopupViewController.h"

@implementation RaceListsTableViewCell {
    LeavingRacePopUpViewController *leavePopup;
    JoinInfoPopupViewController *joinPopup;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _leaveButton.layer.cornerRadius = 13;
    _leaveButton.layer.borderWidth = 1;
    _leaveButton.layer.borderColor = [UIColor blackColor].CGColor;
    
    _joinButton.layer.cornerRadius = 13;
    _joinButton.layer.borderWidth = 1;
    _joinButton.layer.borderColor = [UIColor blackColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)touchLeave:(id)sender {
    leavePopup = [[LeavingRacePopUpViewController alloc] initWithNibName:@"LeavingRacePopUpViewController" bundle:nil];
    leavePopup.key = _key;
    leavePopup.parentView = _parentView;
    leavePopup.content = _leaveInfo;
    leavePopup.raceName = _name.text;
    leavePopup.raceTime = _timeEnd.text;//[_timeEnd.text stringByReplacingOccurrencesOfString:@"Ends" withString:@""];
    
    leavePopup.view.frame = [UIScreen mainScreen].bounds; // Get device's bounds
    [leavePopup showInView:[[[UIApplication sharedApplication] delegate] window] animated:TRUE];
}

- (IBAction)touchInfo:(id)sender {
    
}

- (IBAction)touchJoin:(id)sender {
    joinPopup = [[JoinInfoPopupViewController alloc] initWithNibName:@"JoinInfoPopupViewController" bundle:nil];
    joinPopup.key = _key;
    joinPopup.parentView = _parentView;
    joinPopup.raceNames = _name.text;
    joinPopup.locationID = _locationID;
    joinPopup.categoryType = _categoryType;
    joinPopup.rules = _joinInfo;
    joinPopup.sEndTime = _timeEnd.text;//sEndDate;
    
    joinPopup.view.frame = [UIScreen mainScreen].bounds; // Get device's bounds
    [joinPopup showInView:[[[UIApplication sharedApplication] delegate] window] animated:TRUE];
}

@end
