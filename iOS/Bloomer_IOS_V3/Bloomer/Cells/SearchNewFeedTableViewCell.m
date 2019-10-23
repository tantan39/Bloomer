//
//  SearchNewFeedTableViewCell.m
//  Bloomer
//
//  Created by Phan Van Thanh Dat on 12/24/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "SearchNewFeedTableViewCell.h"

@implementation SearchNewFeedTableViewCell

+ (NSString *)cellIdentifier{
    return @"SearchNewFeedTableViewCell";
}

+ (NSString *)nibName{
    return @"SearchNewFeedTableViewCell";
}

+ (CGFloat)cellHeight{
    return 84.0f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.height / 2;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
