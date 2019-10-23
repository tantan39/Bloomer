//
//  MenuRacePopupController.h
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 12/23/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDefaultManager.h"
#import "RacesViewController.h"
#import "RaceListsTableViewCell.h"
#import "API_JoinRace.h"
#import "Support.h"

@interface MenuRacePopupController : UIViewController<UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIButton *LastestPhotoBut;
@property (weak, nonatomic) IBOutlet UIButton *LeaderboardInfoBut;
@property (weak, nonatomic) IBOutlet UIButton *MyRankBut;
@property (weak, nonatomic) IBOutlet UIButton *SearchBut;
@property (weak, nonatomic) IBOutlet UIButton *ChangeStateBut;
@property (weak, nonatomic) IBOutlet UIButton *CancelBut;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *SearchToBottomContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LeaderBoardToBottom;

- (IBAction)TouchLastesUpload:(id)sender;
- (IBAction)TouchLeaderBoardInfo:(id)sender;
- (IBAction)TouchViewRank:(id)sender;
- (IBAction)TouchSearch:(id)sender;
- (IBAction)TouchChangeState:(id)sender;
- (IBAction)TouchCancel:(id)sender;

@property (weak, nonatomic) UIViewController *parentView;

@property (weak, nonatomic) NSString *rules;
@property (weak, nonatomic) NSString *raceContent;
@property (weak, nonatomic) NSString *raceName;
@property (weak, nonatomic) NSString *endTime;
@property (weak, nonatomic) NSString *key;
@property (assign, nonatomic) NSInteger categoryType;
@property (assign, nonatomic) NSInteger gender;
@property (assign, nonatomic) BOOL isViewRaceTop;
@property (weak, nonatomic) NSString *raceInfo;
@property (weak, nonatomic) NSString *joineInfo;
@property (weak, nonatomic) NSString *leaveInfo;
@property (assign, nonatomic) NSInteger locationID;
@property (assign, nonatomic) BOOL isJoin;
@property (weak, nonatomic) UINavigationController *MyNavigationController;
@property (weak, nonatomic) NSString *avatarString;
@property (assign, nonatomic) BOOL userHasRank;
@property (strong, nonatomic) void (^OnRacejoined)();

- (void)showInView:(UIView *)aView animated:(BOOL)animated;

@end
