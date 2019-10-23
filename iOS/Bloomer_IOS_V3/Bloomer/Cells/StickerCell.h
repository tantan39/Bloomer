//
//  StickerCell.h
//  Bloomer
//
//  Created by Steven on 2/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StickerCell : UICollectionViewCell

// MARK: - Static variables
+ (CGFloat) cellHeight;
+ (NSString*) cellIdentifier;
+ (NSString*) nibName;

@property (weak, nonatomic) IBOutlet UIImageView *image;

@end
