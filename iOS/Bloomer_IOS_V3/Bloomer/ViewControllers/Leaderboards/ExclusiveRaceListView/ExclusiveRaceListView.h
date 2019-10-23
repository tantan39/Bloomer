//
//  RaceListView.h
//  Bloomer
//
//  Created by Steven on 1/20/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RaceListCell.h"
#import "races_list.h"

@interface ExclusiveRaceListView : UIView

+ (CGSize)viewSize;

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet UIImageView *imageLogo;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UIImageView *iconJoinedRace;
@property (weak, nonatomic) IBOutlet UIButton *buttonJoin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actionViewWidth;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIButton *buttonVideo;
@property (weak, nonatomic) IBOutlet UIButton *ButtonGift;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *avatarFullWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *avatarHalfWidthConstraints;
@property (strong, nonatomic) IBOutlet UIImageView *trophyImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *trophyWidthConstraint;

- (IBAction)touchButtonGift:(id)sender;
- (IBAction)touchButtonJoin:(id)sender;
- (IBAction)touchButtonProfile:(id)sender;
- (IBAction)touchButtonVideo:(id)sender;
- (IBAction)touchButtonInfo:(id)sender;

@property (weak, nonatomic) races_list *raceData;
@property (assign, nonatomic) NSInteger gender;
@property (weak, nonatomic) UIViewController *parentView;

- (void)switchActionView:(RaceListState)state;

@end
