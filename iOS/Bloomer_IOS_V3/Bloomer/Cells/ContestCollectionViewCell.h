//
//  ContestCollectionViewCell.h
//  Bloomer
//
//  Created by Tan Tan on 1/3/19.
//  Copyright © 2019 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContestCollectionViewCell : UICollectionViewCell

+ (NSString*) cellIdentifier;
+ (NSString*) nibName;
+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
