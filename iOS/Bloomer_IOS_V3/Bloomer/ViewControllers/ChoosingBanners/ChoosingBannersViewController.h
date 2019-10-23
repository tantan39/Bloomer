//
//  ChoosingBannersViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 7/20/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoCollectionViewCell.h"
#import "iCarousel.h"
#import "API_GalleriesLoad.h"
#import "out_photo_load.h"
#import "UserDefaultManager.h"
#import "UIImageView+AFNetworking.h"
#import "TabBarView.h"
//#import "out_photo_load_link.h"
#import "API_Covers_Add.h"
#import "covers_add.h"
#import "out_auth_register_verifycode.h"
#import "MyProfileViewController.h"
#import "galleries_photo.h"
#import "covers.h"

@interface ChoosingBannersViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, iCarouselDataSource, iCarouselDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;
@property (weak, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) NSMutableArray *covers;
@property (weak, nonatomic) IBOutlet iCarousel *slideshow;
@property (strong, nonatomic) TabBarView *tabbar;
@property (nonatomic, strong) NSIndexPath *selectedItemIndexPath;
@property (weak, nonatomic) UIViewController* parentView;

@end
