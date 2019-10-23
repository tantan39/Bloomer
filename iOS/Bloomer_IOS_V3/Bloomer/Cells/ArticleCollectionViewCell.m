//
//  ArticleCollectionViewCell.m
//  
//
//  Created by Tan Tan on 1/3/19.
//

#import "ArticleCollectionViewCell.h"

@implementation ArticleCollectionViewCell

+ (NSString *)cellIdentifier{
    return @"ArticleCollectionViewCell";
}

+ (NSString *)nibName{
    return @"ArticleCollectionViewCell";
}

+ (CGFloat)cellHeight{
    return 390;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
