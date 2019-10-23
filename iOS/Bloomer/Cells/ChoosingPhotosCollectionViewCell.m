//
//  ChoosingPhotosCollectionViewCell.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 7/23/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "ChoosingPhotosCollectionViewCell.h"

@implementation ChoosingPhotosCollectionViewCell

+ (CGFloat)cellHeight
{
    return 104;
}

+ (NSString*)nibName
{
    return @"ChoosingPhotosCollectionViewCell";
}

+ (NSString*)cellIdentifier
{
    return @"Photo";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_RedPanel setHidden:TRUE];
    _image.layer.borderColor = UIColorFromRGB(0xb22124).CGColor;
    _RedPanel.layer.cornerRadius = 4.0;
}

-(void)onClickImage:(NSInteger) number
{
    [_RedPanel setHidden:false];
    _image.layer.borderWidth = 3;
    _Number.text = [NSString stringWithFormat: @"%ld", (long)number];
}

-(void) getCellToNormal
{
    [_RedPanel setHidden:true];
    _image.layer.borderWidth = 0;
}

@end
