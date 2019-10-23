//
//  AlbumCollectionViewCell.h
//  Bloomer
//
//  Created by Tan Tan on 11/20/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlbumCollectionViewCell : UICollectionViewCell

+ (CGFloat) cellHeight;
+ (NSString*) cellIdentifier;
+ (NSString*) nibName;

@end

NS_ASSUME_NONNULL_END
