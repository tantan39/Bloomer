//
//  NewsFeedPageMenu.h
//  Bloomer
//
//  Created by Tan Tan on 1/2/19.
//  Copyright © 2019 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppHelper.h"
#import "UIColor+Extension.h"

NS_ASSUME_NONNULL_BEGIN
@protocol NewsFeedPageMenuDelegate <NSObject>

- (void) menuSelectedIndex:(NSInteger) index;

@end

@interface NewsFeedPageMenu : UIView<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewLeftPaddingConstraint;
@property (weak, nonatomic) IBOutlet UIView *lineBottomView;
@property (weak,nonatomic) id<NewsFeedPageMenuDelegate> delegate;
@end


@interface PageMenuCell : UICollectionViewCell
@property (strong,nonatomic) UILabel * lblTitle;
@end

NS_ASSUME_NONNULL_END
