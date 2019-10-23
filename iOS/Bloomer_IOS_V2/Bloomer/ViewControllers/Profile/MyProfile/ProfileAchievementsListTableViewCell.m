//
//  ProfileAchievementsListTableViewCell.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 2/24/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "ProfileAchievementsListTableViewCell.h"

@implementation ProfileAchievementsListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initCell];
}
-(void)prepareForReuse{
    [self initCell];
}

-(void) initCell{
    _Dot.image = nil;
    _NameRank.text = @"";
    _Rank.text = @"";
    _BigTitle.text = @"";
    _LinkWeb.image = nil;
    _Lock.image = nil;
    _Flowers.image = nil;
    _FlowerQuantity.text = @"";
    _Rank.textColor = UIColorFromRGB(0x000000);
    _BigTitle.textColor = UIColorFromRGB(0x000000);
    _NameRank.textColor = UIColorFromRGB(0x000000);
}

- (void)setUpType0:(NSString*) Name rank:(NSString*) rank
{
    [self initCell];
    [_Dot setImage:[UIImage imageNamed:@"Dot_for_achieve"]];
    _NameRank.text = Name;
    NSString* newRank = [[NSString alloc] init];
    if([NSLocalizedString(@"EN",nil)  isEqual: @"EN"])
    {
        newRank = [Support suffixForRank:[rank intValue]];
    }
    else
    {
        newRank = [@"hạng " stringByAppendingString:rank];
    }
    _Rank.text = newRank;
    if([rank  isEqual: @"1"])
    {
        _Rank.textColor = UIColorFromRGB(FIRST_RANK);
    }
    else if([rank  isEqual: @"2"])
    {
        _Rank.textColor = UIColorFromRGB(SECOND_RANK);
    }
    else if([rank  isEqual: @"3"])
    {
        _Rank.textColor = UIColorFromRGB(THIRD_RANK);
    }
    self.viewMain.backgroundColor = UIColorFromRGB(0xf4f4f4);
}

-(void) setUpType1:(NSString*) Name flowers:(NSString*) quantityF
{
    [self initCell];
    _BigTitle.text = Name;
    _FlowerQuantity.text = quantityF;
    [_Flowers setImage:[UIImage imageNamed:@"Icon_Flower"]];
    self.viewMain.backgroundColor = UIColorFromRGB(0xffffff);
}

-(void) setUpType2:(NSString*) Name
{
    [self initCell];
    _LinkWeb.image = nil;
    _BigTitle.text = Name;
    self.viewMain.backgroundColor = UIColorFromRGB(0xffffff);
}

-(void) setUpType3:(NSString*) Name
{
    [self initCell];
    [_Lock setImage:[UIImage imageNamed:@"icon_Key_ClosedLeaderboard"]];
    _LinkWeb.image = nil;
    _NameRank.text = Name;
    _NameRank.textColor = UIColorFromRGB(0xacacac);
    self.viewMain.backgroundColor = UIColorFromRGB(0xffffff);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
