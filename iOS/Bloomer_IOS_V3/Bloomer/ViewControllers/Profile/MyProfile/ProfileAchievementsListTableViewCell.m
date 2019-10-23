//
//  ProfileAchievementsListTableViewCell.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 2/24/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "ProfileAchievementsListTableViewCell.h"
#import "UIView+Extension.h"

@implementation ProfileAchievementsListTableViewCell {
    NSString* colorRank;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    colorRank = @"#444444";
    [self.backgroundheaderView setShadowRadius:4.0f shadowOffset:CGSizeMake(0, 0)];
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
    _headerImageView.hidden = true;
    _Rank.textColor = UIColorFromRGB(0x000000);
    _BigTitle.textColor = UIColorFromRGB(0x000000);
    _NameRank.textColor = UIColorFromRGB(0x000000);
    self.backgroundheaderView.hidden = TRUE;
}

- (void)setUpType0:(NSString*) Name rank:(NSString*) rank
{
    [self initCell];
//    [_Dot setImage:[UIImage imageNamed:@"Dot_for_achieve"]];
    self.NameRank.font = [UIFont fontWithName:@"SFProText-Medium" size:16];
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
        _Rank.textColor = [UIColor colorFromHexString:colorRank];
    }
    else if([rank  isEqual: @"2"])
    {
        _Rank.textColor = [UIColor colorFromHexString:colorRank];
    }
    else if([rank  isEqual: @"3"])
    {
        _Rank.textColor = [UIColor colorFromHexString:colorRank];
    }
    self.viewMain.backgroundColor = UIColorFromRGB(0xffffff);
    self.backgroundheaderView.hidden = true;

}

-(void) setUpType1:(NSString*) Name flowers:(NSString*) quantityF
{
    [self initCell];
    _BigTitle.text = Name;
    _FlowerQuantity.text = quantityF;
    [_Flowers setImage:[UIImage imageNamed:@"Icon_Flower"]];
//    self.viewMain.backgroundColor = UIColorFromRGB(0xf4f4f4);
    self.viewMain.layer.cornerRadius = 4.0f;
    self.headerImageView.hidden = false;
    self.backgroundheaderView.hidden = FALSE;
}

-(void) setUpType2:(NSString*) Name
{
    [self initCell];
    _LinkWeb.image = nil;
    _BigTitle.text = Name;
    _headerImageView.hidden = false;
//    self.viewMain.backgroundColor = UIColorFromRGB(0xf4f4f4);
    self.backgroundheaderView.hidden = FALSE;
}

-(void) setUpType3:(NSString*) Name
{
    [self initCell];
    [_Lock setImage:[UIImage imageNamed:@"ic_lock_red"]];
    _LinkWeb.image = nil;
    self.NameRank.font = [UIFont fontWithName:@"SFProText-Semibold" size:18];
    _NameRank.text = Name;
//    _NameRank.textColor = UIColorFromRGB(0xacacac);
//    self.viewMain.backgroundColor = UIColorFromRGB(0xf4f4f4);
    self.headerImageView.hidden = false;
    self.backgroundheaderView.hidden = FALSE;
}

@end
