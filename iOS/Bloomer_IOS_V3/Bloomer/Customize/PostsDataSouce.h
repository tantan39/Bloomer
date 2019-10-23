//
//  PostsDataSouce.h
//  Bloomer
//
//  Created by Tan Tan on 11/19/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Support.h"
#import "PostCollectionViewCell.h"
#import "MyProfileHeaderViewCell.h"
#import "MyProfileViewController.h"
#import "BloomerMenuPopUpView.h"

@protocol PostsCollectionViewDelegate <NSObject>

- (void) postCollectionView:(UICollectionView *) collectionView didSelectedCell:(NSIndexPath *) indexPath;
- (void) postCollectionView:(UICollectionView *) collectionView didSelectedPhoto:(NSURL *) photoURL;
//- (void) postCollectionView:(UICollectionView *) collectionView didSelectedShare;
//- (void) postCollectionView:(UICollectionView *) collectionView didSelectedEdit;

@end

@interface PostsDataSouce : NSObject<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,PostCollectionViewCellDelegate>

@property (strong,nonatomic) UICollectionView * collectionView;
@property (strong,nonatomic) NSMutableArray * sections;
@property (strong,nonatomic) NSMutableArray * dataSource;
@property (strong,nonatomic) id<MyProfileHeaderViewCellDelegate> viewController;
@property (weak,nonatomic) id<PostsCollectionViewDelegate> delegate;

- (instancetype) initWith:(UICollectionView *) collectionView Sections:(NSMutableArray *) sections DataSource:(NSMutableArray *) array Delegate:(id) delegate;

- (void) reloadSections:(NSMutableArray *) sections;
- (void) reloadData;

@end
