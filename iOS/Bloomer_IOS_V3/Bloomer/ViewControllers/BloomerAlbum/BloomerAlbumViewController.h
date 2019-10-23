//
//  BloomerAlbumViewController.h
//  Bloomer
//
//  Created by Steven on 6/11/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API_Profile_Post_GalleryFetches.h"
#import "profile_gallery.h"

@interface BloomerAlbumViewController : UIViewController<UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet UIView *pageControlMainView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pageControlMainViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pageControlMainViewCenterX;

@property (copy, nonatomic) void(^chosePhoto)(UIImage *chosenImage);
@property (copy, nonatomic) void(^cancelChoosePhoto)();

@property (weak, nonatomic) UIViewController* parentView;
@property (strong, nonatomic) NSMutableArray* galleryList;
@property (assign, nonatomic) NSInteger raceIndex;

@end
