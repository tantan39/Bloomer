//
//  MenuRaceViewJoinViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 3/30/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDefaultManager.h"
#import "ImagePickerRaceViewController.h"
#import "JoinInfoPopupViewController.h"
#import "LeavingRacePopUpViewController.h"

@interface MenuRaceViewJoinViewController : UIViewController

- (void)showInView:(UIView *)aView animated:(BOOL)animated;
- (IBAction)touchJoin:(id)sender;
- (IBAction)touchCancel:(id)sender;
- (IBAction)touchSeeRace:(id)sender;
- (IBAction)touchTaggedRace:(id)sender;
- (IBAction)touchSearch:(id)sender;
- (IBAction)touchSurprise:(id)sender;
- (IBAction)touchViewMyRank:(id)sender;
- (IBAction)touchLeave:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *seeRaceTaggedPhotosButton;
@property (weak, nonatomic) IBOutlet UIButton *seeRaceInfoButton;
@property (weak, nonatomic) IBOutlet UIButton *searchPeopleButton;
@property (weak, nonatomic) IBOutlet UIButton *cacncelButton;
@property (weak, nonatomic) IBOutlet UIButton *viewMyRank;
@property (weak, nonatomic) IBOutlet UIButton *surpriseMe;
@property (weak, nonatomic) IBOutlet UIButton *joinRace;
@property (weak, nonatomic) UIViewController *parentView;
@property (weak, nonatomic) NSString *rules;
@property (weak, nonatomic) NSString *raceInfo;
@property (weak, nonatomic) NSString *joineInfo;
@property (weak, nonatomic) NSString *leaveInfo;
@property (weak, nonatomic) NSString *raceName;
@property (assign, nonatomic) NSString *endTime;
@property (weak, nonatomic) NSString *key;
@property (assign, nonatomic) NSInteger categoryType;
@property (assign, nonatomic) NSInteger locationID;
@property (assign, nonatomic) NSInteger gender;
@property (assign, nonatomic) BOOL isJoin;
@property (weak, nonatomic) IBOutlet UIButton *leaveRaceButton;
@property (assign, nonatomic) BOOL isViewRaceTop;
@property (weak, nonatomic) IBOutlet UIView *actionContents;

@end
