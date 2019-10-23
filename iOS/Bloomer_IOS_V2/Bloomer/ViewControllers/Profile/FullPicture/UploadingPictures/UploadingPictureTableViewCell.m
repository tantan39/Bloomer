//
//  UploadingPictureTableViewCell.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 10/23/15.
//  Copyright © 2015 Glassegg. All rights reserved.
//

#import "UploadingPictureTableViewCell.h"

@implementation UploadingPictureTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _photo.clipsToBounds = TRUE;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
