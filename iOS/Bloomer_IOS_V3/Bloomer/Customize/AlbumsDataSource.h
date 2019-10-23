//
//  AlbumsDataSource.h
//  Bloomer
//
//  Created by Tan Tan on 11/20/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MyProfileHeaderViewCell.h"
#import "Support.h"
#import "AlbumCollectionViewCell.h"
#import "MyProfileViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AlbumsCollectionViewDelegate <NSObject>

//- (void) albumCollectionView:(UICollectionView *) collectionView didSelectedCell:(NSIndexPath *) indexPath;

@end

@interface AlbumsDataSource : NSObject <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>

@property (strong,nonatomic) UICollectionView * collectionView;
@property (strong,nonatomic) NSMutableArray * sections;
@property (strong,nonatomic) NSMutableArray * dataSource;
@property (strong,nonatomic) id<MyProfileHeaderViewCellDelegate> viewController;
@property (weak,nonatomic) id<AlbumsCollectionViewDelegate> delegate;

- (instancetype) initWith:(UICollectionView *) collectionView Sections:(NSMutableArray *) sections DataSource:(NSMutableArray *) array Delegate:(id) delegate;

- (void) reloadSections:(NSMutableArray *) sections;
- (void) reloadData;
@end

NS_ASSUME_NONNULL_END
