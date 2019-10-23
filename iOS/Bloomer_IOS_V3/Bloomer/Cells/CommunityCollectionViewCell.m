//
//  CommunityCollectionViewCell.m
//  Bloomer
//
//  Created by Tan Tan on 1/3/19.
//  Copyright © 2019 Glassegg. All rights reserved.
//

#import "CommunityCollectionViewCell.h"

@implementation CommunityCollectionViewCell

+ (NSString *)cellIdentifier{
    return @"CommunityCollectionViewCell";
}

+ (NSString *)nibName{
    return @"CommunityCollectionViewCell";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self customInit];
}

- (void) customInit{
    [self setupCollectionView];
}

- (void) setupCollectionView{
    [self.collectionView registerNib:[UINib nibWithNibName:[BannerCollectionViewCell nibName] bundle:nil] forCellWithReuseIdentifier:[BannerCollectionViewCell cellIdentifier]];
    
    [self.collectionView registerNib:[UINib nibWithNibName:[PostCollectionViewCell nibName] bundle:nil] forCellWithReuseIdentifier:[PostCollectionViewCell cellIdentifier]];
    
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        return CGSizeMake(self.bounds.size.width, [BannerCollectionViewCell cellHeight]);
    }
    return CGSizeMake(self.bounds.size.width, [PostCollectionViewCell cellHeight]);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        BannerCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[BannerCollectionViewCell cellIdentifier] forIndexPath:indexPath];
        
        return cell;
    }
    
    PostCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[PostCollectionViewCell cellIdentifier] forIndexPath:indexPath];
    
    return cell;
}


@end
