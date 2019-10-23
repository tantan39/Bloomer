//
//  JoinInfoPopupViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/18/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDefaultManager.h"
#import "ImagePickerRaceViewController.h"
#import "API_Profile_Location.h"
//#import "ConfirmationPopupViewController.h"
#import "API_JoinRace.h"
#import "RaceAlertView.h"


@interface JoinInfoPopupViewController : UIViewController <UIGestureRecognizerDelegate , UIWebViewDelegate /*, ConfirmationPopupDelegate*/>

- (void)showInView:(UIView *)aView animated:(BOOL)animated;
@property (weak, nonatomic) IBOutlet UILabel *raceName;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UITextView *rulesTextView;
@property (weak, nonatomic) IBOutlet UIView *popupView;
@property (weak, nonatomic) NSString *rules;
@property (weak, nonatomic) NSString *raceNames;
@property (assign, nonatomic) long long endTimes;
@property (weak, nonatomic) UIViewController *parentView;
@property (weak, nonatomic) NSString *key;
@property (assign, nonatomic) NSInteger locationID;
@property (assign, nonatomic) NSInteger categoryType;
@property (assign, nonatomic) NSString *sEndTime;
@property (strong, nonatomic) void (^OnRaceJoined)();

-(void)showInView:(UICollectionViewCell *)view withCompletionHandler:(void(^)(NSString *buttonTitle, NSInteger locationID))handler;

- (IBAction)touchCancel:(id)sender;
- (IBAction)touchOK:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *OKButton;

@end
