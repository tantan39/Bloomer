//
//  AvatarCollectionViewCell.m
//  Bloomer
//
//  Created by VanLuu on 6/9/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "AvatarCollectionViewCell.h"

@implementation AvatarCollectionViewCell
- (void)awakeFromNib
{
    _avatarImg.image = [[UIImage alloc]init];
    [_lblraceName setText:@""];
    _raceKey = @"";
}

- (void)prepareForReuse
{
    _avatarImg.image = [[UIImage alloc]init];
    [_lblraceName setText:@""];
    _raceKey = @"";
}
@end
