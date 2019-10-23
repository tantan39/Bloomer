//
//  AlbumCollectionViewCell.m
//  Bloomer
//
//  Created by Tan Tan on 11/20/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "AlbumCollectionViewCell.h"

@implementation AlbumCollectionViewCell

+ (CGFloat)cellHeight{
    return 300;
}

+ (NSString *)cellIdentifier{
    return @"AlbumCollectionViewCell";
}

+ (NSString *)nibName{
    return @"AlbumCollectionViewCell";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
@end
