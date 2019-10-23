//
//  ComingSoonRaceCell.h
//  Bloomer
//
//  Created by Tran Thai Tan on 9/27/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Extension.h"

@interface ComingSoonRaceCell : UICollectionViewCell
+ (CGFloat) cellHeight;
+ (NSString*) cellIdentifier;
+ (NSString*) nibName;

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIImageView *imgvMain;

@end
