//
//  PhotoAlbumVC.m
//  Bloomer
//
//  Created by Tan Tan on 11/21/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "PhotoAlbumVC.h"

@interface PhotoAlbumVC ()

@end

@implementation PhotoAlbumVC
- (instancetype)init{
    self = [super initWithNibName:@"PhotoAlbumVC" bundle:nil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [AppHelper setTitleViewForNavigationBar:self.navigationItem title:@"Funny Album"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:[PostCollectionViewCell nibName] bundle:nil] forCellWithReuseIdentifier:[PostCollectionViewCell cellIdentifier]];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(WIDTH_SCREEN, [PostCollectionViewCell cellHeight]);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PostCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[PostCollectionViewCell cellIdentifier] forIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView selectedPhoto:(NSURL *)photoURL{
    FullScreensViewController *view = [[FullScreensViewController alloc] init];
    //    view.modalPresentationCapturesStatusBarAppearance = FALSE;
    //    view.parentView = self;
    //    view.photo = self.imageView.image;
    //    view.strURL = self.content_post.photo_url_full;
    //    view.galerryData = self.galleryData;
    //    view.currentIndex = self.currentIndex;
    //    view.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //
    //    UIViewController *previousViewController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    //    if ([previousViewController isKindOfClass:[PhotosTaggedInRacesViewController class]])
    //    {
    //        view.isMultiple = false;
    //    }
    //    else
    //    {
    //        view.isMultiple = true;
    //    }
    
    [self presentViewController:view animated:YES completion:nil];
}
@end
