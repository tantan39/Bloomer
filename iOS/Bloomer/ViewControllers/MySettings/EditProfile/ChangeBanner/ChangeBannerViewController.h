//
//  ChangeBannerViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/20/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileBannerView.h"
#import "ImageCropView.h"

@protocol ChangeBannerViewControllerDelegate< NSObject>
- (void) updateBannerSuccess;
@end

@interface ChangeBannerViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, ImageCropViewControllerDelegate, ProfileBannerViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *slideshow;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIView *slideShowContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;

@property (weak, nonatomic) NSMutableArray *bannerList;
@property (nonatomic, strong) NSIndexPath *selectedItemIndexPath;
//@property (strong, nonatomic) NSMutableArray *imageViews;
@property (strong, nonatomic) NSMutableArray<ProfileBannerView*>* bannerViews;
@property (strong, nonatomic) NSMutableArray *croppedRects;
@property (strong, nonatomic) NSMutableArray * selectedItemIndexPaths;
@property (weak,nonatomic) id<ChangeBannerViewControllerDelegate> delegate;

@end
