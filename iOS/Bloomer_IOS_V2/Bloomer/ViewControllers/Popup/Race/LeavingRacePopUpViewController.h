//
//  LeavingRacePopUpViewController.h
//  Bloomer
//
//  Created by Tai Truong on 9/29/15.
//  Copyright © 2015 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RacesViewController.h"
#import "RaceListsTableViewCell.h"
#import "API_LeaveRace.h"

@interface LeavingRacePopUpViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *popupView;
- (IBAction)touchCancelButton:(id)sender;
- (IBAction)touchLeaveButton:(id)sender;
@property (weak, nonatomic) UIViewController *parentView;
@property (assign, nonatomic) NSInteger iRace;
@property (weak, nonatomic) NSString *key;
- (void)showInView:(UIView *)aView animated:(BOOL)animated;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnLeave;

@property (weak, nonatomic) NSString *content;
@property (weak, nonatomic) NSString *raceName;
@property (weak, nonatomic) NSString *raceTime;
@property (weak, nonatomic) IBOutlet UIWebView *leavingContentWebView;
@property (strong, nonatomic) void (^OnRaceLeft)();

@end
