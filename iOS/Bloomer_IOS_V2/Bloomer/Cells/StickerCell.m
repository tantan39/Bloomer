//
//  StickerCell.m
//  Bloomer
//
//  Created by Steven on 2/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "StickerCell.h"

@implementation StickerCell

+ (CGFloat)cellHeight
{
    return 100;
}

+ (NSString*)cellIdentifier
{
    return @"StickerCell";
}

+ (NSString*)nibName
{
    return @"StickerCell";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
