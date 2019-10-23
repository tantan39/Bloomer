//
//  PhotoGalleryCell.m
//  Bloomer
//
//  Created by Steven on 6/4/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "PhotoGalleryCell.h"

@implementation PhotoGalleryCell

// MARK: - Static Functions

+ (CGFloat)cellHeight
{
    return 80;
}

+ (NSString*)nibName
{
    return @"PhotoGalleryCell";
}

+ (NSString*)cellIdentifier
{
    return @"PhotoGalleryCell";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
