//
//  PhotosDataSource.m
//  Bloomer
//
//  Created by Tan Tan on 11/19/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "PhotosDataSource.h"

static CGFloat PADDING = 16;
static CGFloat SPACING = 4;

@interface PhotosDataSource ()

@end

@implementation PhotosDataSource

- (instancetype)initWith:(UICollectionView *)collectionView Sections:(NSMutableArray *) sections DataSource:(NSMutableArray *)array Delegate:(id)delegate{
    self = [super init];
    if (self) {
        
        self.viewController = delegate;
        
        self.collectionView = collectionView;
        
        self.sections = [[NSMutableArray alloc] initWithArray:sections];
        
        [self.collectionView registerNib:[UINib nibWithNibName:[ProfilePhotoCollectionViewCell nibName] bundle:nil] forCellWithReuseIdentifier:[ProfilePhotoCollectionViewCell cellIdentifier]];
        
        self.dataSource = array;
        
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
            return 20;
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
            CGFloat widthItem = (WIDTH_SCREEN - (PADDING * 2) - SPACING) / 2;
            return CGSizeMake(widthItem, widthItem);
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
            MyProfileViewController * vc = (MyProfileViewController *) self.viewController;
            reminderPopUpCell.delegate = vc;
            [reminderPopUpCell configCell:vc.profileData];
            return reminderPopUpCell;
            

        }
            break;
        case ProfileInfo:{
            MyProfileHeaderViewCell * headerCell = (MyProfileHeaderViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[MyProfileHeaderViewCell cellIdentifier] forIndexPath:indexPath];
            MyProfileViewController * vc = (MyProfileViewController *) self.viewController;
            headerCell.delegate = vc;
            
            [headerCell configCell:vc.profileData];
            return headerCell;
        }
            break;
            
        case DataCollection:{
            ProfilePhotoCollectionViewCell * cell = (ProfilePhotoCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:[ProfilePhotoCollectionViewCell cellIdentifier] forIndexPath:indexPath];
            return cell;
        }
            break;
            
        default:
            break;
    }
  
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    if ([self.delegate respondsToSelector:@selector(photoCollectionView:didSelectedCell:)]) {
//        [self.delegate photoCollectionView:collectionView didSelectedCell:indexPath];
//    }
    PostDetailVC * postDetailVC = [[PostDetailVC alloc] init];
    MyProfileViewController * myProfileVC = (MyProfileViewController *)self.viewController;
    if (myProfileVC) {
        [myProfileVC.navigationController pushViewController:postDetailVC animated:TRUE];
    }
}

@end
