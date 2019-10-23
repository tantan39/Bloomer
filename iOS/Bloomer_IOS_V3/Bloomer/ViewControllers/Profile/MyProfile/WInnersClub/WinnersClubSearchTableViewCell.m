//
//  RacesSearchTableViewCell.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/13/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "WinnersClubSearchTableViewCell.h"

@implementation WinnersClubSearchTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _avatar.layer.cornerRadius = _avatar.frame.size.width / 2;
    _avatar.layer.borderWidth = 1;
    _avatar.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _avatar.clipsToBounds = TRUE;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)cellIdentifier {
    return @"RacesSearchTableViewCell";
}

@end
