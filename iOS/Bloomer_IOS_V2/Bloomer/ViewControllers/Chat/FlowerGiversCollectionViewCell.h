//
//  FlowerGiversCollectionViewCell.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 6/13/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfileViewController.h"


@interface FlowerGiversCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *flower;
@property (assign, nonatomic) NSInteger profileID;
@property (strong, nonatomic) UIViewController* mainView;

@end
