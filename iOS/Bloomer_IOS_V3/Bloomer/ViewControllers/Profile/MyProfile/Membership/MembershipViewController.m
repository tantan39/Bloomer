//
//  MembershipViewController.m
//  Bloomer
//
//  Created by Ahri on 10/11/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "MembershipViewController.h"

@interface MembershipViewController () {
    UserDefaultManager* userDefaultManager;
    BOOL viewAlreadyLayout;
    
    UIColor *bronzeThemeColor;
    UIColor *silverThemeColor;
    UIColor *goldThemeColor;
    
    AchievementViewController *curRankViewController;
    AchievementViewController *topResultsViewController;
    
    NSMutableArray<UIView *> *halfRoundPanelsArr;
    PopupForGSB *popup;
    
    NSInteger curGender;
}

@end

@implementation MembershipViewController

// MARK: - View LifeCycles

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    
    self.navigationItem.title = NSLocalizedString(@"MembershipViewController.membership", );
    [self.membershipButton setTitle:NSLocalizedString(@"MembershipWinnersClubButton.title", ) forState:UIControlStateNormal];
    [self.currentRankButton setTitle:NSLocalizedString(@"MembershipCurrentRank.title", ) forState:UIControlStateNormal];
    [self.topResultButton setTitle:NSLocalizedString(@"MembershipBestRank.title", ) forState:UIControlStateNormal];
    [self.infoButton setTitle:NSLocalizedString(@"Membership.whatIsWinnersClub",) forState:UIControlStateNormal];
    for (int i = 0; i < self.tapToSeeLabels.count; i++) {
        UILabel *label = self.tapToSeeLabels[i];
        label.text = NSLocalizedString(@"Membership.tapToSee",);
    }
    
    self.bronzeLabel.text = [AppHelper getLocalizedString: @"Membership.bronze"];
    self.silverLabel.text = [AppHelper getLocalizedString: @"Membership.silver"];
    self.goldLabel.text = [AppHelper getLocalizedString: @"Membership.gold"];

    
    bronzeThemeColor = [UIColor rgb:68 green:68 blue:68];
    silverThemeColor = [UIColor rgb:68 green:68 blue:68];
    goldThemeColor = [UIColor rgb:68 green:68 blue:68];
    
    halfRoundPanelsArr = [[NSMutableArray alloc] initWithObjects:self.halfRoundPanel_Bronze,
                          self.halfRoundPanel_Silver, self.halfRoundPanel_Gold, nil];
    self.membershipButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.currentRankButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.topResultButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self loadTopButtonsIntoGroup];
    [self addCurRankSubview];
    [self addTopResultSubview];
//    [self setupAvatarRoundShape];
    [self setupGSBCongratulationLabelsDefault];
    [self loadGSBServerDataToCurScene];
    [self enableShowingWinnersClub];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self addRoundShapeToPanels];
    if (!viewAlreadyLayout) {
        [self.membershipButton didTouchButton];
        viewAlreadyLayout = true;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [userDefaultManager setMedalKey:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// MARK: - View Auto-Rotation

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return false;
}

// MARK: - APIs

- (void)loadGSBServerDataToCurScene {
    // Setup NextMission label text
    if (self.isUserMembership) {
        UIColor *targetThemeColor = nil;
        NSString *nextMissionLabelTxt;
        
        if (self.gold > 0) {
            targetThemeColor = UIColor.blackColor;
            nextMissionLabelTxt = [NSString stringWithFormat:[AppHelper getLocalizedString:@"Membership.highestRankNotice_forUser"],
                                   [[AppHelper getLocalizedString:@"Membership.gold"] uppercaseString]];
            self.avatarImageView.image = [UIImage imageNamed:@"ic_achievement_gold"];
        } else if (self.silver > 0) {
            targetThemeColor = UIColor.blackColor;
            nextMissionLabelTxt = [NSString stringWithFormat:[AppHelper getLocalizedString:@"Membership.highestRankNotice_forUser"],
                                   [[AppHelper getLocalizedString:@"Membership.silver"] uppercaseString]];
            self.avatarImageView.image = [UIImage imageNamed:@"ic_achievement_silver"];
        } else if (self.bronze > 0) {
            self.avatarImageView.layer.borderColor = bronzeThemeColor.CGColor;
            targetThemeColor = UIColor.blackColor;
            nextMissionLabelTxt = [NSString stringWithFormat:[AppHelper getLocalizedString:@"Membership.highestRankNotice_forUser"],
                                   [[AppHelper getLocalizedString:@"Membership.bronze"] uppercaseString]];
            self.avatarImageView.image = [UIImage imageNamed:@"ic_achievement_brone"];
        } else {
            nextMissionLabelTxt = [AppHelper getLocalizedString:@"Membership.memberNotInClub_forUser"];
            self.avatarImageView.image = [UIImage imageNamed:@"ic_achievement_not_cup"];
        }
        
        [self setTextBoldColorInStrings:[[NSMutableArray alloc] initWithObjects:nextMissionLabelTxt, nil]
                     prevAttributedStrs:nil
                           targetStrArr:[[NSMutableArray alloc] initWithObjects:self.profileData.name, nil]
                         targetFontSize:15
                            themeColors:[[NSMutableArray alloc] initWithObjects:targetThemeColor, nil]
                           targetLabels:[[NSMutableArray alloc] initWithObjects:self.nextMissionLabel, nil]];
    
    } else {
        if (self.gold > 0) {
            self.avatarImageView.layer.borderColor = goldThemeColor.CGColor;
            self.nextMissionLabel.text = [NSString stringWithFormat:[AppHelper getLocalizedString:@"Membership.highestRankNotice"],
                                          [AppHelper getLocalizedString:@"Membership.gold"].uppercaseString];
            self.avatarImageView.image = [UIImage imageNamed:@"ic_achievement_gold"];
        } else if (self.silver > 0) {
            self.avatarImageView.layer.borderColor = silverThemeColor.CGColor;
            self.nextMissionLabel.text = [NSString stringWithFormat:[AppHelper getLocalizedString:@"Membership.highestRankNotice"],
                                          [AppHelper getLocalizedString:@"Membership.silver"].uppercaseString];
            self.avatarImageView.image = [UIImage imageNamed:@"ic_achievement_silver"];
        } else if (self.bronze > 0) {
            self.avatarImageView.layer.borderColor = bronzeThemeColor.CGColor;
            self.nextMissionLabel.text = [NSString stringWithFormat:[AppHelper getLocalizedString:@"Membership.highestRankNotice"],
                                          [AppHelper getLocalizedString:@"Membership.bronze"].uppercaseString];
            self.avatarImageView.image = [UIImage imageNamed:@"ic_achievement_brone"];

        } else {
            self.nextMissionLabel.text = [AppHelper getLocalizedString:@"Membership.memberNotInClub"];
            self.avatarImageView.image = [UIImage imageNamed:@"ic_achievement_not_cup"];
        }
    }
    [self setupGSBCongratulationLabels];
}

// MARK: General

- (void)enableShowingWinnersClub {
    if (self.isUserMembership) {
        curGender = self.profileData.gender;
    } else {
        curGender = [userDefaultManager getUserProfileData].gender;
    }
    
    UIGestureRecognizer *showBronzeClubTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBronzeWinnersClub)];
    [self.halfRoundPanel_Bronze addGestureRecognizer:showBronzeClubTap];
    [self.bronzeClubButton addTarget:self
                              action:@selector(showBronzeWinnersClub)
                    forControlEvents:UIControlEventTouchUpInside];
    
    UIGestureRecognizer *showSilverClubTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSilverWinnersClub)];
    [self.halfRoundPanel_Silver addGestureRecognizer:showSilverClubTap];
    [self.silverClubButton addTarget:self
                              action:@selector(showSilverWinnersClub)
                    forControlEvents:UIControlEventTouchUpInside];
    
    UIGestureRecognizer *showGoldClubTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showGoldWinnersClub)];
    [self.halfRoundPanel_Gold addGestureRecognizer:showGoldClubTap];
    [self.goldClubButton addTarget:self
                            action:@selector(showGoldWinnersClub)
                  forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadTopButtonsIntoGroup {
    NSMutableArray<GroupButtonWithColor *> *topButtonsGroup = [[NSMutableArray alloc]
                                                               initWithObjects:self.membershipButton,
                                                               self.topResultButton,
                                                               self.currentRankButton, nil];
    self.membershipButton.buttonsGroup = topButtonsGroup;
    self.topResultButton.buttonsGroup = topButtonsGroup;
    self.currentRankButton.buttonsGroup = topButtonsGroup;
}

- (void)addRoundShapeToPanels {
    int radius = 8;
    for (int i = 0; i < halfRoundPanelsArr.count; i++) {
        UIView *panel = halfRoundPanelsArr[i];
        panel.layer.opaque = true;
        panel.layer.shouldRasterize = true;
        
        panel.layer.rasterizationScale = UIScreen.mainScreen.scale;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:panel.bounds
                                                   byRoundingCorners:UIRectCornerAllCorners
                                                         cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = panel.bounds;
        [maskLayer setPath:path.CGPath];
        panel.layer.mask = maskLayer;
    }
}

- (void)setupGSBCongratulationLabelsDefault {
    NSMutableArray *congratLabels = [[NSMutableArray alloc] initWithObjects:self.congratulationTextBronze,
                                     self.congratulationTextSilver, self.congratulationTextGold, nil];
    NSMutableArray *themeColors = [[NSMutableArray alloc] initWithObjects:bronzeThemeColor, silverThemeColor, goldThemeColor, nil];
    NSMutableArray *generalNoticeStrs = [[NSMutableArray alloc] initWithObjects:[AppHelper getLocalizedString:@"Membership.generalNoticeBronze"],
                                  [AppHelper getLocalizedString:@"Membership.generalNoticeSilver"], [AppHelper getLocalizedString:@"Membership.generalNoticeGold"], nil];
    NSMutableArray *targetStrs = [[NSMutableArray alloc] initWithObjects:[AppHelper getLocalizedString:@"Membership.bronzeNotice"],
                                  [AppHelper getLocalizedString:@"Membership.silverNotice"], [AppHelper getLocalizedString:@"Membership.goldNotice"], nil];
    NSMutableArray *strArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < 3; i++) {
        NSString *str = [NSString stringWithFormat:@"%@%@",
         generalNoticeStrs[i], targetStrs[i]];
        [strArr addObject:str];
    }
    
    [self setTextBoldColorInStrings:generalNoticeStrs prevAttributedStrs:nil targetStrArr:targetStrs
                     targetFontSize:12 themeColors:themeColors targetLabels:congratLabels];
}

- (void)setupGSBCongratulationLabels {
    NSMutableArray *congratLabels = [[NSMutableArray alloc] init];
    NSMutableArray *strArr = [[NSMutableArray alloc] init];
    NSMutableArray *targetStrs = [[NSMutableArray alloc] init];
    NSMutableArray *themeColors = [[NSMutableArray alloc] init];
    
    if (self.bronze > 0) {
        if (self.isUserMembership) {
            [strArr addObject:[NSString stringWithFormat:@"%@%@",
                               [NSString stringWithFormat:[AppHelper getLocalizedString:@"Membership.congratulationNotice_forUser"], self.profileData.name],
                               [AppHelper getLocalizedString:@"Membership.bronzeNotice2"]]];
        } else {
            [strArr addObject:[NSString stringWithFormat:@"%@%@",
                               [AppHelper getLocalizedString:@"Membership.congratulationNotice"],
                               [AppHelper getLocalizedString:@"Membership.bronzeNotice2"]]];
        }
        [congratLabels addObject:self.congratulationTextBronze];
        [themeColors addObject:bronzeThemeColor];
        [targetStrs addObject:[AppHelper getLocalizedString:@"Membership.bronzeNotice2"]];
    }
    if (self.silver > 0) {
        if (self.isUserMembership) {
            [strArr addObject:[NSString stringWithFormat:@"%@%@",
                               [NSString stringWithFormat:[AppHelper getLocalizedString:@"Membership.congratulationNotice_forUser"], self.profileData.name],
                               [AppHelper getLocalizedString:@"Membership.silverNotice2"]]];
        } else {
            [strArr addObject:[NSString stringWithFormat:@"%@%@",
                               [AppHelper getLocalizedString:@"Membership.congratulationNotice"],
                               [AppHelper getLocalizedString:@"Membership.silverNotice2"]]];
        }
        [congratLabels addObject:self.congratulationTextSilver];
        [themeColors addObject:silverThemeColor];
        [targetStrs addObject:[AppHelper getLocalizedString:@"Membership.silverNotice2"]];
    }
    if (self.gold > 0) {
        if (self.isUserMembership) {
            [strArr addObject:[NSString stringWithFormat:@"%@%@",
                               [NSString stringWithFormat:[AppHelper getLocalizedString:@"Membership.congratulationNotice_forUser"], self.profileData.name],
                               [AppHelper getLocalizedString:@"Membership.goldNotice2"]]];
        } else {
            [strArr addObject:[NSString stringWithFormat:@"%@%@",
                               [AppHelper getLocalizedString:@"Membership.congratulationNotice"],
                               [AppHelper getLocalizedString:@"Membership.goldNotice2"]]];
        }
        [congratLabels addObject:self.congratulationTextGold];
        [themeColors addObject:goldThemeColor];
        [targetStrs addObject:[AppHelper getLocalizedString:@"Membership.goldNotice2"]];
    }
    
    NSMutableArray *attributedStrings = [self setTextBoldColorInStrings:strArr prevAttributedStrs:nil targetStrArr:targetStrs
                                                   targetFontSize:12 themeColors:themeColors
                                                     targetLabels:congratLabels];
    
    if (self.isUserMembership && self.profileData != nil) {
        targetStrs = [[NSMutableArray alloc] initWithObjects:self.profileData.name, self.profileData.name, self.profileData.name, nil];
        [self setTextBoldColorInStrings:nil prevAttributedStrs:attributedStrings
                           targetStrArr:targetStrs targetFontSize:12 themeColors:nil targetLabels:congratLabels];
    }
}

- (NSMutableArray<NSMutableAttributedString *> *)setTextBoldColorInStrings:(NSMutableArray *)strArr
                                                        prevAttributedStrs:(NSMutableArray *)prevAttributedStrs
                                                              targetStrArr:(NSMutableArray *)targetStrArr targetFontSize:(CGFloat)targetFontSize
                themeColors:(NSMutableArray *)themeColors targetLabels:(NSMutableArray *)targetLabels {
    
//    if (strArr != nil) {
//        NSMutableArray *attributedStrings = [[NSMutableArray alloc] init];
//        for (int i = 0; i < targetLabels.count; i++) {
//            UILabel *label = targetLabels[i];
//            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:strArr[i]];
//            if (themeColors != nil && i < themeColors.count && themeColors[i] != nil) {
//                [string setColorForText:targetStrArr[i] withColor:themeColors[i]];
//            }
//            [string setBoldForText:targetStrArr[i] fontSize:targetFontSize];
//            label.attributedText = string;
//            [attributedStrings addObject:string];
//        }
//        return attributedStrings;
//    }
    
    for (int i = 0; i < targetLabels.count; i++) {
        UILabel *label = targetLabels[i];
//        if (themeColors != nil && i < themeColors.count && themeColors[i] != nil) {
//            [prevAttributedStrs[i] setColorForText:targetStrArr[i] withColor:themeColors[i]];
//        }
//        [prevAttributedStrs[i] setBoldForText:targetStrArr[i] fontSize:targetFontSize];
//        label.attributedText = prevAttributedStrs[i];
        label.text = strArr[i];
    }
    return prevAttributedStrs;
}

// MARK: Show Winners CLub

- (void)showBronzeWinnersClub {
    WinnersClubViewController *view = [[WinnersClubViewController alloc] init];
    view.gsbType = GSBBronze;
    view.gender = curGender;
    [self.navigationController pushViewController:view animated:true];
}

- (void)showSilverWinnersClub {
    WinnersClubViewController *view = [[WinnersClubViewController alloc] init];
    view.gsbType = GSBSilver;
    view.gender = curGender;
    [self.navigationController pushViewController:view animated:true];
}

- (void)showGoldWinnersClub {
    WinnersClubViewController *view = [[WinnersClubViewController alloc] init];
    view.gsbType = GSBGold;
    view.gender = curGender;
    [self.navigationController pushViewController:view animated:true];
}

// MARK: - Add Top results subviews

- (void)addCurRankSubview {
    AchievementViewController *curRankView = [[AchievementViewController alloc] initWithNibName:@"AchievementViewController" bundle:nil];
    curRankViewController = curRankView;
    curRankView.uid = self.uid;
    curRankView.activeRaces = true;
    [curRankView loadAchievements];
    
    [self.curRankSubview addSubview:curRankView.view];
    [self addChildViewController:curRankView];
    [curRankView didMoveToParentViewController:self];
    [curRankView.view setFrame:CGRectMake(0, 0, self.curRankSubview.frame.size.width, self.curRankSubview.frame.size.height)];
}

- (void)addTopResultSubview {
    AchievementViewController *topResultsView = [[AchievementViewController alloc] initWithNibName:@"AchievementViewController" bundle:nil];
    topResultsViewController = topResultsView;
    topResultsView.uid = self.uid;
    topResultsView.activeRaces = false;
    [topResultsView loadAchievements];
    
    [self.topResultsSubview addSubview:topResultsView.view];
    [self addChildViewController:topResultsView];
    [topResultsView didMoveToParentViewController:self];
    [topResultsView.view setFrame:CGRectMake(0, 0, self.topResultsSubview.frame.size.width, self.topResultsSubview.frame.size.height)];
}

// MARK: - Actions

- (IBAction)touchInfoButton:(id)sender {
    GSBViewController* view = [[GSBViewController alloc] initWithNibName:@"GSBViewController" bundle:nil];
//    popup.view.frame = [UIScreen mainScreen].bounds; // Get device's bounds
//    //    popup.view.frame = [[UIApplication sharedApplication] keyWindow].bounds; // get app windows's bounds
//    [popup showInView:[[UIApplication sharedApplication] keyWindow] animated:true];
    [self.navigationController pushViewController:view animated:true];
}

- (IBAction)touchMembership:(id)sender {
    [self.scrollView scrollRectToVisible:CGRectMake(self.membershipSubview.frame.origin.x, 0,
                                                    CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame))
                                animated:true];
}

- (IBAction)touchCurRank:(id)sender {
    [self.scrollView scrollRectToVisible:CGRectMake(self.curRankSubview.frame.origin.x, 0,
                                                    CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame))
                                animated:true];
}

- (IBAction)touchTopResults:(id)sender {
    [self.scrollView scrollRectToVisible:CGRectMake(self.topResultsSubview.frame.origin.x, 0,
                                                    CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame))
                                animated:true];
}

// MARK: - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    [self animateLine:offsetX / 3];
    
    CGFloat offsetX = self.scrollView.contentOffset.x;
    self.animatedLineLeftMargin.constant = offsetX/3;
    if (offsetX / 3 == self.membershipButton.frame.origin.x) {
        [self.membershipButton didTouchButton];
    }
    if ((int) offsetX / 3 == (int) self.currentRankButton.frame.origin.x) {
        [self.currentRankButton didTouchButton];
    }
    if ((int) offsetX / 3 == (int) self.topResultButton.frame.origin.x) {
        [self.topResultButton didTouchButton];
    }
}

@end
