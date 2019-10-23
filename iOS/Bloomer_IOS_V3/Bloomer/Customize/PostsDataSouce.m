//
//  PostsDataSouce.m
//  Bloomer
//
//  Created by Tan Tan on 11/19/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "PostsDataSouce.h"
static CGFloat PADDING = 4;
static CGFloat SPACING = 20;

@implementation PostsDataSouce

- (instancetype)initWith:(UICollectionView *)collectionView Sections:(NSMutableArray *) sections DataSource:(NSMutableArray *)array Delegate:(id)delegate{
    self = [super init];
    if (self) {
        self.collectionView = collectionView;
        self.sections = [[NSMutableArray alloc] initWithArray:sections];
        [self.collectionView registerNib:[UINib nibWithNibName:[PostCollectionViewCell nibName] bundle:nil] forCellWithReuseIdentifier:[PostCollectionViewCell cellIdentifier]];
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
            CGFloat widthItem = WIDTH_SCREEN - (PADDING * 2);
            return CGSizeMake(widthItem, [PostCollectionViewCell cellHeight]);
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
            PostCollectionViewCell * cell = (PostCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:[PostCollectionViewCell cellIdentifier] forIndexPath:indexPath];
            //    cell.lblTitle.text = @"Post ";
            cell.delegate = self;
            return cell;
        }
            break;
            
        default:
            break;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(postCollectionView:didSelectedCell:)]) {
        [self.delegate postCollectionView:collectionView didSelectedCell:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView selectedPhoto:(NSURL *)photoURL{
//    if ([self.delegate respondsToSelector:@selector(postCollectionView:didSelectedPhoto:)]) {
//        [self.delegate postCollectionView:collectionView didSelectedPhoto:[NSURL new]];
//    }
    FullScreensViewController *view = [[FullScreensViewController alloc] init];
    //    view.modalPresentationCapturesStatusBarAppearance = FALSE;
    //    view.parentView = self;
    //    view.photo = self.imageView.image;
    //    view.strURL = self.content_post.photo_url_full;
    //    view.galerryData = self.galleryData;
    //    view.currentIndex = self.currentIndex;
    //    view.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //
    //    UIViewController *previousViewController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    //    if ([previousViewController isKindOfClass:[PhotosTaggedInRacesViewController class]])
    //    {
    //        view.isMultiple = false;
    //    }
    //    else
    //    {
    //        view.isMultiple = true;
    //    }
    MyProfileViewController * myProfileVC = (MyProfileViewController *) self.viewController;
    if (myProfileVC) {
        [myProfileVC presentViewController:view animated:YES completion:nil];
    }
}

- (void)collectionViewCell_selectedEdit{

}

- (void)collectionViewCell_selectedShare{
    
}


@end
