//
//  PhotoCollectionViewCell.h
//  GetPhoto
//
//  Created by Truong Thuan Tai on 7/20/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Extension.h"

@interface PhotoCollectionViewCell : UICollectionViewCell

+ (CGFloat)cellHeight;
+ (NSString*)cellIdentifier;
+ (NSString*)nibName;

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIImageView *tickPhoto;
@property (strong, nonatomic) NSString *photo_id;

- (void) setHidenBorder:(BOOL) isHide;
@end
