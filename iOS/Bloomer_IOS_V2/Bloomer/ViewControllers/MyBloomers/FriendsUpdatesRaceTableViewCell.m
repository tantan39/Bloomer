//
//  FriendsUpdatesRaceTableViewCell.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 2/16/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "FriendsUpdatesRaceTableViewCell.h"
#import "AppHelper.h"
#import "AnonymousUserProfileViewController.h"

@implementation FriendsUpdatesRaceTableViewCell{
    GENDER currentRaceGender;
}

-(GENDER)getCurrentRaceGender {
    return currentRaceGender;
}

+ (CGFloat)cellHeight
{
    return 520;
}

+ (NSString*)cellIdentifier
{
    return @"UpdatesRaceCell";
}

+ (NSString*)nibName
{
    return @"FriendsUpdatesRaceTableViewCell";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    _firstRankAvatar.clipsToBounds = TRUE;
    _firstRankAvatar.layer.cornerRadius = _firstRankAvatar.frame.size.height / 2;
    _firstRankAvatar.layer.borderWidth = 3;
    _firstRankAvatar.layer.borderColor = [UIColor colorWithRed:0.698 green:0.133 blue:0.145 alpha:1.0].CGColor;
    
    _secondAvatar.clipsToBounds = TRUE;
    _secondAvatar.layer.cornerRadius = _secondAvatar.frame.size.height / 2;
    _secondAvatar.layer.borderWidth = 2;
    _secondAvatar.layer.borderColor = [UIColor colorWithRed:0.741 green:0.741 blue:0.741 alpha:1.0].CGColor;
    
    _thirdAvatar.clipsToBounds = TRUE;
    _thirdAvatar.layer.cornerRadius = _thirdAvatar.frame.size.height / 2;
    _thirdAvatar.layer.borderWidth = 2;
    _thirdAvatar.layer.borderColor = [UIColor colorWithRed:0.741 green:0.741 blue:0.741 alpha:1.0].CGColor;
    
    _fourthAvatar.clipsToBounds = TRUE;
    _fourthAvatar.layer.cornerRadius = _fourthAvatar.frame.size.height / 2;
    _fourthAvatar.layer.borderWidth = 2;
    _fourthAvatar.layer.borderColor = [UIColor colorWithRed:0.741 green:0.741 blue:0.741 alpha:1.0].CGColor;
    
    _fifthAvatar.clipsToBounds = TRUE;
    _fifthAvatar.layer.cornerRadius = _fifthAvatar.frame.size.height / 2;
    _fifthAvatar.layer.borderWidth = 2;
    _fifthAvatar.layer.borderColor = [UIColor colorWithRed:0.741 green:0.741 blue:0.741 alpha:1.0].CGColor;
    
    self.firstRankCircle.layer.cornerRadius = self.firstRankCircle.frame.size.height / 2;
    self.firstRankCircle.clipsToBounds = true;
    self.secondRankCircle.layer.cornerRadius = self.secondRankCircle.frame.size.height / 2;
    self.secondRankCircle.clipsToBounds = true;
    self.thirdRankCircle.layer.cornerRadius = self.thirdRankCircle.frame.size.height / 2;
    self.thirdRankCircle.clipsToBounds = true;
    self.fourthRankCircle.layer.cornerRadius = self.fourthRankCircle.frame.size.height / 2;
    self.fourthRankCircle.clipsToBounds = true;
    self.fifthRankCircle.layer.cornerRadius = self.fifthRankCircle.frame.size.height / 2;
    self.fifthRankCircle.clipsToBounds = true;
    
    currentRaceGender = FEMALE;
    
    self.labelWinnerTitle.text = [AppHelper getLocalizedString:@"FriendsUpdatesRace.labelWinnerTitle"];
    [self.femaleButton setTitle:[AppHelper getLocalizedString:@"FriendsUpdatesRace.buttonFemale"] forState:UIControlStateNormal];
    [self.maleButton setTitle:[AppHelper getLocalizedString:@"FriendsUpdatesRace.buttonMale"] forState:UIControlStateNormal];
    [self.buttonViewMoreResults setTitle:[AppHelper getLocalizedString:@"FriendsUpdatesRace.buttonViewMoreResults"] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)reloadRaceFeedByList:(NSMutableArray*)winnerList
{
    for (int i = 0; i < 5; i++)
    {
        UIView* rankView = self.rankViews[i];
        
        UIImageView* avatar = (UIImageView *)[rankView viewWithTag:1];
        
        if (i < winnerList.count)
        {
            [rankView setHidden:NO];
            FeedWinner* winner = winnerList[i];
            
            [avatar setImageWithURL:[NSURL URLWithString:winner.avatar]];
            
            [(UILabel *)[rankView viewWithTag:2] setText:winner.name];
            [(UILabel *)[rankView viewWithTag:3] setText:winner.username];
            
            [(UILabel *)[rankView viewWithTag:4] setFlowers:winner.flower];
        }
        else
        {
            [rankView setHidden:YES];
        }
    }
}

// MARK: - Actions

- (IBAction)onTouchMaleRace:(id)sender {
    
    [self.femaleButton setEnabled:true];
    self.animatedLineLeftMargin.constant = self.maleButton.frame.origin.x;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.animatedLine layoutIfNeeded];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.maleButton setEnabled:false];
        
    }];
    
    [self reloadRaceFeedByList:_maleRace.winnerList];
    currentRaceGender = MALE;
}

- (IBAction)onTouchFemaleRace:(id)sender {
    
    [self.maleButton setEnabled:true];
    self.animatedLineLeftMargin.constant = self.femaleButton.frame.origin.x;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.animatedLine layoutIfNeeded];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.femaleButton setEnabled:false];

    }];
    
    [self reloadRaceFeedByList:_femaleRace.winnerList];
    currentRaceGender = FEMALE;
}

- (IBAction)viewRaceResult:(id)sender {
    switch (currentRaceGender) {
        case MALE:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: _maleRace.raceURL]];
            break;
        case FEMALE:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: _femaleRace.raceURL]];
            break;
        default:
            break;
    }
}

- (IBAction)touchButtonAvatar:(id)sender {
    UIButton *button = (UIButton*)sender;
    NSInteger index = button.tag - 5;
    UserDefaultManager *userDefaultManager = [[UserDefaultManager alloc] init];
    
    FeedWinner *winner;
    
    if (currentRaceGender == MALE)
    {
        winner = (FeedWinner*)[self.maleRace.winnerList objectAtIndex:index];
    }
    else
    {
        winner = (FeedWinner*)[self.femaleRace.winnerList objectAtIndex:index];
    }
    
    if ([userDefaultManager isAnonymous])
    {
        AnonymousUserProfileViewController *view = [[AnonymousUserProfileViewController alloc] initWithNibName:@"AnonymousUserProfileViewController" bundle:nil];
        view.uid = winner.uid;
        
        [self.navigationController pushViewController:view animated:YES];
    }
    else
    {
        if (winner.uid == [userDefaultManager getUserProfileData].uid)
        {
            [AppDelegate setSelectedIndexTabbar:4];
        }
        else
        {
            UserProfileViewController *view = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
            view.uid = winner.uid;
            
            [self.navigationController pushViewController:view animated:YES];
        }
    }
}

@end
