//
//  AlbumsDataSource.m
//  Bloomer
//
//  Created by Tan Tan on 11/20/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "AlbumsDataSource.h"

static CGFloat PADDING = 16;
static CGFloat SPACING = 8;

@implementation AlbumsDataSource

- (instancetype)initWith:(UICollectionView *)collectionView Sections:(NSMutableArray *) sections DataSource:(NSMutableArray *)array Delegate:(id)delegate{
    self = [super init];
    if (self) {
        self.collectionView = collectionView;
        [self.collectionView registerNib:[UINib nibWithNibName:[AlbumCollectionViewCell nibName] bundle:nil] forCellWithReuseIdentifier:[AlbumCollectionViewCell cellIdentifier]];
        
        self.sections = [[NSMutableArray alloc] initWithArray:sections];
        self.dataSource = array;
        self.viewController = delegate;
    }
    return self;
}

-  (void)reloadSections:(NSMutableArray *)sections{
    self.sections = sections;
    [self.collectionView reloadData];
}

- (void)reloadData{
    if (self.dataSource) {
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
     return self.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    SectionTypeCell sectionType =  [(NSNumber *)[self.sections objectAtIndex:section] integerValue];
    switch (sectionType) {
        case UpdateProfileRemindPopUp:{
            return 1;
        }
            break;
        case ProfileInfo:{
            return 1;
        }
            break;
            
        case DataCollection:{
            return 2;
        }
            break;
            
        default:
            break;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    SectionTypeCell sectionType =  [(NSNumber *)[self.sections objectAtIndex:section] integerValue];
    switch (sectionType) {
        case UpdateProfileRemindPopUp:{
            return 0;
        }
            break;
        case ProfileInfo:{
            return 0;
        }
            break;
            
        case DataCollection:{
            return SPACING;
        }
            break;
            
        default:
            break;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    SectionTypeCell sectionType =  [(NSNumber *)[self.sections objectAtIndex:section] integerValue];
    switch (sectionType) {
        case UpdateProfileRemindPopUp:{
            return UIEdgeInsetsMake(0, 0, 0, 0);
        }
            break;
        case ProfileInfo:{
            return UIEdgeInsetsMake(0, 0, 0, 0);
        }
            break;
            
        case DataCollection:{
            return UIEdgeInsetsMake(0, PADDING, 0, PADDING);
        }
            break;
            
        default:
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    SectionTypeCell sectionType =  [(NSNumber *)[self.sections objectAtIndex:indexPath.section] integerValue];
    switch (sectionType) {
        case UpdateProfileRemindPopUp:{
            return CGSizeMake(WIDTH_SCREEN, [UpdateProfileCollectionViewCell cellHeight]);
        }
            break;
        case ProfileInfo:{
            return CGSizeMake(WIDTH_SCREEN, [MyProfileHeaderViewCell cellHeight]);
        }
            break;
            
        case DataCollection:{
            CGFloat widthItem = WIDTH_SCREEN - (PADDING * 2) ;
            return CGSizeMake(widthItem, [AlbumCollectionViewCell cellHeight]);
        }
            break;
            
        default:
            break;
    }

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SectionTypeCell sectionType =  [(NSNumber *)[self.sections objectAtIndex:indexPath.section] integerValue];
    switch (sectionType) {
        case UpdateProfileRemindPopUp:{
            UpdateProfileCollectionViewCell * reminderPopUpCell = (UpdateProfileCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[UpdateProfileCollectionViewCell cellIdentifier] forIndexPath:indexPath];
            reminderPopUpCell.delegate = self.viewController;
            return reminderPopUpCell;
        }
            break;
        case ProfileInfo:{
            MyProfileHeaderViewCell * headerCell = (MyProfileHeaderViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[MyProfileHeaderViewCell cellIdentifier] forIndexPath:indexPath];
            headerCell.delegate = self.viewController;
            return headerCell;
        }
            break;
            
        case DataCollection:{
            AlbumCollectionViewCell * cell = (AlbumCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:[AlbumCollectionViewCell cellIdentifier] forIndexPath:indexPath];
            //    cell.lblTitle.text = @"Album ";
            return cell;
        }
            break;
            
        default:
            break;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    if ([self.delegate respondsToSelector:@selector(albumCollectionView:didSelectedCell:)]) {
//        [self.delegate albumCollectionView:collectionView didSelectedCell:indexPath];
//    }
    PhotoAlbumVC * photoAlbum = [[PhotoAlbumVC alloc] init];
    MyProfileViewController * myProfileVC = (MyProfileViewController *) self.viewController;
    if (myProfileVC) {
        [myProfileVC.navigationController pushViewController:photoAlbum animated:YES];
    }
}
@end
