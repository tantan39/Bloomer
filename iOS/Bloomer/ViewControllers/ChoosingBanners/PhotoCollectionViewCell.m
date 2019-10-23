//
//  PhotoCollectionViewCell.m
//  GetPhoto
//
//  Created by Truong Thuan Tai on 7/20/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

+ (CGFloat)cellHeight
{
    return 104;
}

+ (NSString*)cellIdentifier
{
    return @"Photo";
}

+ (NSString*)nibName
{
    return @"PhotoCollectionViewCell";
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _image.clipsToBounds = TRUE;
    _image.layer.borderColor = UIColorFromRGB(0xb22124).CGColor;
}

-(void) prepareForReuse{
    _image.image = nil;
}

- (void) setHidenBorder:(BOOL) isHide
{
    if(isHide == true)
    {
        _image.layer.borderWidth = 0;
    }
    else
    {
        _image.layer.borderWidth = 3;
    }
}

@end
