//
//  PostCollectionViewCell.h
//  Bloomer
//
//  Created by Tan Tan on 11/20/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfilePhotoCollectionViewCell.h"
NS_ASSUME_NONNULL_BEGIN

@protocol PostCollectionViewCellDelegate <NSObject>

- (void) collectionView:(UICollectionView *) collectionView selectedPhoto:(NSURL *) photoURL;

- (void) postCollectionViewCell_selectedEdit;

- (void) postCollectionViewCell_selectedShare;

- (void) postCollectionViewCell_selectedComment;

- (void) postCollectionViewCell_selectedFlowerNumb;

@end

@interface PostCollectionViewCell : UICollectionViewCell<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *imgvAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblDisplayName;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblCaption;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak,nonatomic) id<PostCollectionViewCellDelegate> delegate;

+ (CGFloat) cellHeight;
+ (NSString*) cellIdentifier;
+ (NSString*) nibName;

@end

NS_ASSUME_NONNULL_END
