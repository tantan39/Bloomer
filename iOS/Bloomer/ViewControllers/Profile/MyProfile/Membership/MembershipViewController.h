//
//  MembershipViewController.h
//  Bloomer
//
//  Created by Ahri on 10/11/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIColor+Extension.h"
#import "NSMutableAttributedString+Extension.h"
#import "CustomRankingPanel.h"
#import "RightRoundCornerLabel.h"
#import "GroupButtonWithColor.h"
#import "BlueRoundButton.h"
#import "API_Get_RewardMemebership.h"
#import "AchievementViewController.h"
#import "PopupForGSB.h"
#import "WinnersClubViewController.h"

@interface MembershipViewController : UIViewController

// MARK: - Top slider buttons
@property (weak, nonatomic) IBOutlet GroupButtonWithColor *membershipButton;
@property (weak, nonatomic) IBOutlet GroupButtonWithColor *currentRankButton;
@property (weak, nonatomic) IBOutlet GroupButtonWithColor *topResultButton;

// MARK: Slider components
@property (weak, nonatomic) IBOutlet UIView *scrollLine;
@property (weak, nonatomic) IBOutlet UIView *animatedLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *animatedLineLeftMargin;

// MARK: ScrollView - subViews
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *membershipSubview;
@property (weak, nonatomic) IBOutlet UIView *curRankSubview;
@property (weak, nonatomic) IBOutlet UIView *topResultsSubview;

// MARK: Ranking Panels Properties
@property (weak, nonatomic) IBOutlet UIView *halfRoundPanel_Bronze;
@property (weak, nonatomic) IBOutlet UIView *halfRoundPanel_Silver;
@property (weak, nonatomic) IBOutlet UIView *halfRoundPanel_Gold;
@property (weak, nonatomic) IBOutlet UILabel *congratulationTextBronze;
@property (weak, nonatomic) IBOutlet UILabel *congratulationTextSilver;
@property (weak, nonatomic) IBOutlet UILabel *congratulationTextGold;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *tapToSeeLabels;
@property (weak, nonatomic) IBOutlet UIButton *bronzeClubButton;
@property (weak, nonatomic) IBOutlet UIButton *silverClubButton;
@property (weak, nonatomic) IBOutlet UIButton *goldClubButton;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nextMissionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextMissionLabelHeight;
@property (weak, nonatomic) IBOutlet BlueRoundButton *infoButton;

// MARK - API Properties
@property (assign, nonatomic) NSInteger uid;
@property (assign, nonatomic) BOOL isUserMembership;
@property (assign, nonatomic) NSInteger bronze;
@property (assign, nonatomic) NSInteger silver;
@property (assign, nonatomic) NSInteger gold;
@property (weak, nonatomic) out_profile_fetch *profileData;

@end
