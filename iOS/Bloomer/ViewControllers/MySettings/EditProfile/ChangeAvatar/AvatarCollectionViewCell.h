//
//  AvatarCollectionViewCell.h
//  Bloomer
//
//  Created by VanLuu on 6/9/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AvatarCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
@property (weak, nonatomic) IBOutlet UILabel *lblraceName;
@property (weak, nonatomic) NSString *raceKey;
@end
