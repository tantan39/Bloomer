//
//  ChatListTableViewCell.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/6/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "ChatListTableViewCell.h"

@implementation ChatListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _avatar.layer.cornerRadius = _avatar.frame.size.width / 2;
    _avatar.layer.borderWidth = 2;
    _avatar.layer.borderColor = [UIColor colorWithRed:0.592 green:0.592 blue:0.592 alpha:1.0].CGColor;
    _avatar.clipsToBounds = TRUE;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
