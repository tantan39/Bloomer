//
//  BloomerNewsCollectionViewCell.m
//  Bloomer
//
//  Created by Tan Tan on 1/3/19.
//  Copyright © 2019 Glassegg. All rights reserved.
//

#import "BloomerNewsCollectionViewCell.h"

@implementation BloomerNewsCollectionViewCell

+ (NSString *)cellIdentifier{
    return @"BloomerNewsCollectionViewCell";
}

+ (NSString *)nibName{
    return @"BloomerNewsCollectionViewCell";
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
    [self.collectionView registerNib:[UINib nibWithNibName:[ContestCollectionViewCell nibName] bundle:nil] forCellWithReuseIdentifier:[ContestCollectionViewCell cellIdentifier]];
    
    [self.collectionView registerNib:[UINib nibWithNibName:[ArticleCollectionViewCell nibName] bundle:nil] forCellWithReuseIdentifier:[ArticleCollectionViewCell cellIdentifier]];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return CGSizeMake(self.bounds.size.width, [ContestCollectionViewCell cellHeight]);
    }
    return CGSizeMake(self.bounds.size.width, [ArticleCollectionViewCell cellHeight]);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ContestCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ContestCollectionViewCell cellIdentifier] forIndexPath:indexPath];
        return cell;
    }
    ArticleCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ArticleCollectionViewCell cellIdentifier] forIndexPath:indexPath];
    return cell;
}

@end
