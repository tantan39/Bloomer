//
//  PhotosDataSource.h
//  Bloomer
//
//  Created by Tan Tan on 11/19/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Support.h"
#import "UpdateProfileCollectionViewCell.h"
#import "MyProfileHeaderViewCell.h"
#import "ProfilePhotoCollectionViewCell.h"
#import "MyProfileViewController.h"

@protocol PhotosCollectionViewDelegate <NSObject>

//- (void) photoCollectionView:(UICollectionView *) collectionView didSelectedCell:(NSIndexPath *) indexPath;

@end

@interface PhotosDataSource : NSObject<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>

@property (strong,nonatomic) UICollectionView * collectionView;
@property (strong,nonatomic) NSMutableArray * sections;
@property (strong,nonatomic) NSMutableArray * dataSource;
@property (strong,nonatomic) id<MyProfileHeaderViewCellDelegate> viewController;
@property (weak,nonatomic) id<PhotosCollectionViewDelegate> delegate;

- (instancetype) initWith:(UICollectionView *) collectionView Sections:(NSMutableArray *) sections DataSource:(NSMutableArray *) array Delegate:(id<MyProfileHeaderViewCellDelegate>) delegate;

- (void) reloadSections:(NSMutableArray *) sections;
- (void) reloadData;

@end
