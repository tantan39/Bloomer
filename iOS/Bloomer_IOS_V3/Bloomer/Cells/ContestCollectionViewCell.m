//
//  ContestCollectionViewCell.m
//  Bloomer
//
//  Created by Tan Tan on 1/3/19.
//  Copyright © 2019 Glassegg. All rights reserved.
//

#import "ContestCollectionViewCell.h"

@implementation ContestCollectionViewCell

+ (NSString *)cellIdentifier{
    return @"ContestCollectionViewCell";
}

+ (NSString *)nibName{
    return @"ContestCollectionViewCell";
}

+ (CGFloat)cellHeight{
    return 250;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
