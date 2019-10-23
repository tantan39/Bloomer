//
//  ChoosingBannersViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 7/20/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "ChoosingBannersViewController.h"
#import "AppDelegate.h"

@interface ChoosingBannersViewController () {
    UserDefaultManager *userDefaultManager;
    NSMutableArray *coversUpload;
    NSInteger currentIndex;
    BOOL isChosen;
}

@end

@implementation ChoosingBannersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    coversUpload = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < _covers.count; i++) {
        [coversUpload addObject:[[_covers objectAtIndex:i] photo_id]];
    }
    
    currentIndex = 0;
    isChosen = FALSE;
    
    [self initNavigationBar];
    [self getAllPictures];
    _slideshow.type = iCarouselTypeRotary;
    
//    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
//    [layout setMinimumLineSpacing:8];
//    [layout setMinimumInteritemSpacing:8];
//    CGFloat itemSize = self.collectionView.bounds.size.width / 3;
//    [layout setItemSize:CGSizeMake(itemSize, itemSize)];
//    [_collectionView setCollectionViewLayout:layout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.badgeNumber removeFromSuperview];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:appDelegate.badgeNumber];
}
- (void)initNavigationBar {
    UIBarButtonItem *nextButton;
    nextButton = [[UIBarButtonItem alloc] initWithTitle:@"NEXT" style:UIBarButtonItemStylePlain target:self action:@selector(touchNextButton)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:nextButton, nil]];
    
    [AppHelper setTitleViewForNavigationBar:self.navigationItem title:NSLocalizedString(@"Choosing Banners", nil)];
}

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchNextButton {
    
    if (_images.count != 0 && isChosen)
    {
        for (NSInteger i = coversUpload.count - 1; i >= 0 ; i--) {
            if ([[coversUpload objectAtIndex:i] isEqualToString:@""]) {
                [coversUpload removeObjectAtIndex:i];
            }
        }
        
        covers_add *coversAdd = [[covers_add alloc] initWithAccessToken:[userDefaultManager getAccessToken]  device_token:[userDefaultManager getDeviceToken] photos:coversUpload];
        
        API_Covers_Add * api = [[API_Covers_Add alloc] initWithParams:coversAdd];
        [api postRequest:^(BaseJSON *json, RestfulResponse *objStatus) {
            if (objStatus.status)
            {
                MyProfileViewController *view = (MyProfileViewController *)_parentView;
                [view loadSlideShowUsingAPI];
                
                [self.navigationController popViewControllerAnimated:TRUE];
            } else {
                [AppHelper showMessageBox:nil message:objStatus.message];
            }
        } ErrorHandlure:^(NSError *error) {
            
        }];
        
    } else {
        [self.navigationController popViewControllerAnimated:TRUE];
    }
}

//- (void)getDataCovers_Add:(out_auth_register_verifycode *)data {
//    if ([data getStt])
//    {
//        MyProfileViewController *view = (MyProfileViewController *)_parentView;
//        [view loadSlideShowUsingAPI];
//        
//        [self.navigationController popViewControllerAnimated:TRUE];
//    }else{
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[data getTitle]
//                                                        message:data.getMegs
//                                                       delegate:self
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
//    }
//    
//}

- (void)getAllPictures {
    API_GalleriesLoad *gallerriesAPI = [[API_GalleriesLoad alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] userID:@([userDefaultManager getUserProfileData].uid).stringValue];
    [gallerriesAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        out_photo_load_link * data = (out_photo_load_link *) jsonObject;
        if (response.status) {
            
            _images = data.photos;
            
            if (data.photos.count != 0)
            {
                [self scrollToSelectedPhoto];
                [_warningLabel setHidden:TRUE];
            }
            else
            {
                [_warningLabel setHidden:FALSE];
            }
            
        } else {
            [AppHelper showMessageBox:nil message:response.message];
        }
        
    } ErrorHandlure:^(NSError *error) {
        
    }];

}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return _images.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(104, 104);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = k_PHOTO;
    
    UINib *leftNib = [UINib nibWithNibName:@"PhotoCollectionViewCell" bundle: nil];
    [cv registerNib:leftNib forCellWithReuseIdentifier:identifier];
    
    PhotoCollectionViewCell *cell = (PhotoCollectionViewCell *)[_collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    galleries_photo *temp = (galleries_photo*)[_images objectAtIndex:indexPath.row];

    cell.image.image = nil;
    [cell.image setImageWithURL:[NSURL URLWithString:temp.photoLink]];

    if (self.selectedItemIndexPath != nil && [indexPath compare:self.selectedItemIndexPath] == NSOrderedSame) {
        [cell.tickPhoto setHidden:FALSE];
    } else {
        [cell.tickPhoto setHidden:TRUE];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *indexPaths = [NSMutableArray arrayWithObject:indexPath];
    
    if (self.selectedItemIndexPath)
    {
        if ([indexPath compare:self.selectedItemIndexPath] != NSOrderedSame)
        {
            [indexPaths addObject:self.selectedItemIndexPath];
            self.selectedItemIndexPath = indexPath;
        }
    }
    else
    {
        self.selectedItemIndexPath = indexPath;
    }
    
    isChosen = TRUE;
    
    galleries_photo *temp = (galleries_photo *)[_images objectAtIndex:indexPath.row];
    
    [coversUpload replaceObjectAtIndex:currentIndex withObject:temp.photo_id];
    
    covers *cover = [[covers alloc] init];
    cover.photo_id = temp.photo_id;
    cover.pLarge = temp.photoLink;
    [_covers replaceObjectAtIndex:currentIndex withObject:cover];
    [_slideshow reloadData];
    
    [collectionView reloadItemsAtIndexPaths:indexPaths];
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return _covers.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    //if (_covers.count >= 3) {
    covers *temp = (covers *)[_covers objectAtIndex:index];
    
    view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
    
    if ([temp.pLarge isEqualToString:@"Default_Banner.png"])
    {
        [((UIImageView *)view) setImage:[UIImage imageNamed:temp.pLarge]];
    }
    else
    {
        [((UIImageView *)view) setImageWithURL:[NSURL URLWithString:temp.pLarge]];
    }
    
    if (index == currentIndex)
    {
        view.alpha = 0.5f;
        
        [UIView animateWithDuration:0.5 animations:^{
            view.alpha = 1;
        }];
    }
    else
    {
        view.alpha = 1;
        
        [UIView animateWithDuration:0.5 animations:^{
            view.alpha = 0.5f;
        }];
    }
    
    ((UIImageView *)view).contentMode = UIViewContentModeScaleAspectFill;
    ((UIImageView *)view).clipsToBounds = TRUE;
    //    } else {
    //        covers *temp = (covers *)[_covers objectAtIndex:0];
    //        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
    //        [((UIImageView *)view) setImageWithURL:[NSURL URLWithString:temp.pLarge]];
    //    }
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionSpacing:
        {
            return value * 1.5f;
        }
            
        default:
        {
            return value;
        }
    }
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel;
{
    for (NSInteger i = 0; i < 3; i++)
    {
        if (i == carousel.currentItemIndex)
        {
            UIView *view = [carousel itemViewAtIndex:i];
            view.alpha = 0.5f;
            
            [UIView animateWithDuration:0.5f animations:^{
                view.alpha = 1;
            }];
        }
        else
        {
            UIView *view = [carousel itemViewAtIndex:i];
            view.alpha = 1;
            
            [UIView animateWithDuration:0.5f animations:^{
                view.alpha = 0.5f;
            }];
        }
    }
    
    currentIndex = carousel.currentItemIndex;
    [self scrollToSelectedPhoto];
}

//- (void)loadSlideShowUsingAPI
//{
//    covers_load_using *coversAPI = [[covers_load_using alloc] initWithAccessToken:[userDefaultManager getAccessToken]
//                                                                     device_token:[userDefaultManager getDeviceToken]
//                                                                          user_id:[userDefaultManager getUserProfileData].uid];
//    coversAPI.myDelegate = self;
//    [coversAPI connect];
//}
//
//- (void)getDataCovers_Load:(out_covers_load *)data {
//
//    if ([data getStt]) {
//    } else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                        message:[data getMegs]
//                                                       delegate:self
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
//    }
//}

- (void)scrollToSelectedPhoto
{
    if (_covers.count != 0)
    {
        covers *temp = (covers *)[_covers objectAtIndex:currentIndex];
        NSString *photo_id = temp.photo_id;
        
        for (int i = 0; i < _images.count; i++)
        {
            galleries_photo *temp = (galleries_photo*)[_images objectAtIndex:i];
            
            if ([temp.photo_id isEqualToString:photo_id])
            {
                _selectedItemIndexPath = [NSIndexPath indexPathForItem:i inSection:0];
                break;
            }
        }
    }
    
    [self.collectionView reloadData];
    
    if (_covers.count != 0)
    {
        [_collectionView scrollToItemAtIndexPath:_selectedItemIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:TRUE];
    }
    
}

@end
