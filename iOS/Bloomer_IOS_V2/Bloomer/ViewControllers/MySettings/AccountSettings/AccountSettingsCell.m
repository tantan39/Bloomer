//
//  AccountSettingsCell.m
//  Bloomer
//
//  Created by Steven on 10/18/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "AccountSettingsCell.h"
#import "UIColor+Extension.h"

@implementation AccountSettingsCell

+ (CGFloat)cellHeight
{
    return 64;
}

+ (NSString*)cellIdentifier
{
    return @"AccountSettingsCell";
}

+ (NSString*)nibName
{
    return @"AccountSettingsCell";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)changeStyle:(BOOL)isPlaceholderStyle
{
    if (isPlaceholderStyle)
    {
        self.labelValue.textColor = [UIColor colorFromHexString: @"#d3d3d3"];
        self.labelValue.font = [UIFont fontWithName:@"SFProText-Regular" size:14];
    }
    else
    {
        self.labelValue.textColor = [UIColor colorFromHexString: @"#444444"];
        self.labelValue.font = [UIFont fontWithName:@"SFProText-Bold" size:14];
    }
}

@end
