//
//  PostCollectionViewCell.m
//  Bloomer
//
//  Created by Tan Tan on 11/20/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "PostCollectionViewCell.h"

@implementation PostCollectionViewCell

+ (NSString *)cellIdentifier{
    return @"PostCollectionViewCell";
}

+ (NSString *)nibName{
    return @"PostCollectionViewCell";
}

+ (CGFloat)cellHeight{
    return 490;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self customInit];
}

- (void) customInit{
    self.imgvAvatar.layer.cornerRadius = self.imgvAvatar.bounds.size.width/2;
    self.imgvAvatar.clipsToBounds = YES;
    
    [self.collectionView registerNib:[UINib nibWithNibName:[ProfilePhotoCollectionViewCell nibName] bundle:nil] forCellWithReuseIdentifier:[ProfilePhotoCollectionViewCell cellIdentifier]];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
}

//MARK: UICollectionView Delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ProfilePhotoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ProfilePhotoCollectionViewCell cellIdentifier] forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor blueColor]];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(collectionView:selectedPhoto:)]) {
        [self.delegate collectionView:collectionView selectedPhoto:[NSURL new]];
    }
}
- (IBAction)btnEdit_Pressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(postCollectionViewCell_selectedEdit)]) {
        [self.delegate postCollectionViewCell_selectedEdit];
    }
}

- (IBAction)btnFlowerNumb_Pressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(postCollectionViewCell_selectedFlowerNumb)]) {
        [self.delegate postCollectionViewCell_selectedFlowerNumb];
    }
}


- (IBAction)btnComment_Pressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(postCollectionViewCell_selectedComment)]) {
        [self.delegate postCollectionViewCell_selectedComment];
    }
}

- (IBAction)btnShare_Pressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(postCollectionViewCell_selectedShare)]) {
        [self.delegate postCollectionViewCell_selectedShare];
    }
}



@end
