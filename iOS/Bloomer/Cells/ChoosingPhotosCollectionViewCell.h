//
//  ChoosingPhotosCollectionViewCell.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 7/23/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Support.h"

@interface ChoosingPhotosCollectionViewCell : UICollectionViewCell 

+ (CGFloat)cellHeight;
+ (NSString*)nibName;
+ (NSString*)cellIdentifier;

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIImageView *tickPhoto;
@property (weak, nonatomic) IBOutlet UIView *RedPanel;
@property (weak, nonatomic) IBOutlet UILabel *Number;
-(void)onClickImage:(NSInteger) number;
-(void) getCellToNormal;
@end
