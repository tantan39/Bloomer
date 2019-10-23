//
//  BannerCollectionViewCell.m
//  Bloomer
//
//  Created by Tan Tan on 1/3/19.
//  Copyright © 2019 Glassegg. All rights reserved.
//

#import "BannerCollectionViewCell.h"

@implementation BannerCollectionViewCell

+ (NSString *)cellIdentifier{
    return @"BannerCollectionViewCell";
}

+ (NSString *)nibName{
    return @"BannerCollectionViewCell";
}

+ (CGFloat)cellHeight{
    return 350;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
