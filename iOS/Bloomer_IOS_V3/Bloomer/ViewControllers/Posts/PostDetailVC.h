//
//  PostDetailVC.h
//  Bloomer
//
//  Created by Tan Tan on 11/21/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Support.h"
#import "PostCollectionViewCell.h"
#import "FullScreensViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostDetailVC : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,PostCollectionViewCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

NS_ASSUME_NONNULL_END
