//
//  CommunityCollectionViewCell.h
//  Bloomer
//
//  Created by Tan Tan on 1/3/19.
//  Copyright © 2019 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostCollectionViewCell.h"
#import "BannerCollectionViewCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface CommunityCollectionViewCell : UICollectionViewCell<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

+ (NSString*) cellIdentifier;
+ (NSString*) nibName;

@end


NS_ASSUME_NONNULL_END
