//
//  ArticleCollectionViewCell.h
//  
//
//  Created by Tan Tan on 1/3/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArticleCollectionViewCell : UICollectionViewCell
+ (NSString*) cellIdentifier;
+ (NSString*) nibName;
+ (CGFloat)cellHeight;
@end

NS_ASSUME_NONNULL_END
