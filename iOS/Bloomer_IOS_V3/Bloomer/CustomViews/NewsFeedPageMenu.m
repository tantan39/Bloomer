//
//  NewsFeedPageMenu.m
//  Bloomer
//
//  Created by Tan Tan on 1/2/19.
//  Copyright © 2019 Glassegg. All rights reserved.
//

#import "NewsFeedPageMenu.h"

const static CGFloat PADDING = 0;

@interface NewsFeedPageMenu (){
    NSMutableArray * items;
}

@end

@implementation NewsFeedPageMenu

- (void)awakeFromNib{
    [super awakeFromNib];
    [self customInit];
}

- (void) customInit{
    [[NSBundle mainBundle] loadNibNamed:@"NewsFeedPageMenu" owner:self options:nil];
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
    
    items = [NSMutableArray arrayWithArray:@[@"Community" ,@"Bloomer's News"]];
 
    [self.collectionView registerClass:[PageMenuCell class] forCellWithReuseIdentifier:@"cellID"];
    
    NSIndexPath * idx = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.collectionView selectItemAtIndexPath:idx animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(self.bounds.size.width / 2 - (PADDING * 2), self.bounds.size.height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, PADDING, 0, PADDING);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PageMenuCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];

    cell.lblTitle.text = [items objectAtIndex:indexPath.row];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger offSet = indexPath.row * self.bounds.size.width/2;
    self.lineViewLeftPaddingConstraint.constant = offSet;

    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self layoutIfNeeded];
    } completion:nil];
    
    
    if ([self.delegate respondsToSelector:@selector(menuSelectedIndex:)]) {
        [self.delegate menuSelectedIndex:indexPath.row];
    }
}

@end

@implementation PageMenuCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void) customInit{
    self.lblTitle = [[UILabel alloc] init];
    [self.lblTitle setTextAlignment:NSTextAlignmentCenter];
    [self.lblTitle setFont:[UIFont fontWithName:@"SFProText-Regular" size:14]];
    [self.lblTitle setTextColor:[UIColor rgb:119 green:119 blue:119]];
    self.lblTitle.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.lblTitle];
    [AppHelper setupFullStretchConstraintsForView:self.lblTitle parentView:self];
    
}

- (void)setSelected:(BOOL)selected{
    CGFloat size = 14;
    if (selected) {
        [self.lblTitle setFont:[UIFont fontWithName:@"SFProText-Semibold" size:size]];
        [self.lblTitle setTextColor:[UIColor rgb:37 green:37 blue:41]];
        return;
    }
    [self.lblTitle setFont:[UIFont fontWithName:@"SFProText-Regular" size:size]];
    [self.lblTitle setTextColor:[UIColor rgb:119 green:119 blue:119]];
}

@end
