//
//  FlowerGiverCell.m
//  Bloomer
//
//  Created by Steven on 4/14/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "FlowerGiverCell.h"
#import "UIColor+Extension.h"

@implementation FlowerGiverCell

+ (CGFloat)cellHeight
{
    return 70;
}
    
+ (NSString*)cellIdentifier
{
    return @"FlowerGiverCell";
}
    
+ (NSString*)nibName
{
    return @"FlowerGiverCell";
}
    
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.avatar.layer.cornerRadius = self.avatar.frame.size.width / 2;
    self.avatar.layer.borderWidth = 1;
    self.avatar.layer.borderColor = [UIColor colorFromHexString:@"#e4e4e4"].CGColor;
    self.avatar.clipsToBounds = TRUE;
    
    self.labelName.textColor = [UIColor rgb:172 green:24 blue:32];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
