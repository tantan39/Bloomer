//
//  ChoosingRacesTableViewCell.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/8/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "ChoosingRacesTableViewCell.h"

@implementation ChoosingRacesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _tick.image = [UIImage imageNamed:@"icon_tick"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
