//
//  ChatTableViewCellFlower.m
//  Bloomer
//
//  Created by VanLuu on 3/29/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "ChatTableViewCellFlower.h"

@implementation ChatTableViewCellFlower

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
