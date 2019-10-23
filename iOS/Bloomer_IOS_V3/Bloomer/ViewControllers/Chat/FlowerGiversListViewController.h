//
//  FlowerGiversListViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 6/1/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlowerGiversCollectionViewCell.h"
#import "API_Profile_FollowerFetches.h"
#import "UserDefaultManager.h"
#import "UIImageView+AFNetworking.h"

@interface FlowerGiversListViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UIViewController* mainView;
@end
