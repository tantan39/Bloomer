//
//  ChangeBannerViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/20/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//
#import <SDWebImageDownloader.h>

#import "ChangeBannerViewController.h"
#import "AppHelper.h"
#import "RepositionViewController.h"
#import "UIColor+Extension.h"
#import "banners_add.h"
#import "AppDelegate.h"
#import "BannerObj.h"
#import "PhotoCollectionViewCell.h"
#import "API_Profile_PostFetches.h"
#import "UserDefaultManager.h"
#import "API_Profile_AddBanners.h"
#import "API_Profile_BannerFetches.h"
#import "UIImageView+AFNetworking.h"

#define BANNER_LIMIT 5
#define PADDING_ITEM 2

@interface ChangeBannerViewController ()
{
    UserDefaultManager *userDefaultManager;
    out_profile_fetch *profileData;
    NSMutableArray *photoList;
    NSInteger currentIndex;
    NSMutableArray *banners;
    NSMutableArray *selectedPosts;
    NSString* lastPostID;
    UICollectionViewFlowLayout * layout;
    Spinner *spinner;
}

@end

static NSString *identifier;

@implementation ChangeBannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    userDefaultManager = [[UserDefaultManager alloc] init];
    profileData = [userDefaultManager getUserProfileData];
    spinner = ((AppDelegate*)[UIApplication sharedApplication].delegate).spinner;
    self.selectedItemIndexPaths = [[NSMutableArray alloc] init];
    photoList = [[NSMutableArray alloc] init];
    banners = [[NSMutableArray alloc] init];
    selectedPosts =[[NSMutableArray alloc] init];
    self.croppedRects = [[NSMutableArray alloc] init];
    self.bannerViews = [[NSMutableArray alloc] init];
    currentIndex = 0;
    lastPostID = @"";
    
    identifier = @"Photo";
    UINib *nib = [UINib nibWithNibName:@"PhotoCollectionViewCell" bundle: nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
    
    [self initBanner];
    [self initNavigationBar];
    [self layoutCollectionView];
    [self loadPostList];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    for (int i = 0; i < self.pageControl.numberOfPages; i++)
    {
        UIView* dot = [self.pageControl.subviews objectAtIndex:i];
        dot.layer.borderColor = [UIColor colorFromHexString:@"#B22225"].CGColor;
        dot.layer.borderWidth = 1;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.croppedRects = nil;
    photoList = nil;
    self.bannerViews = nil;
    selectedPosts = nil;
    banners = nil;
    self.bannerList = nil;
    
}

- (void)initNavigationBar {
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done",nil) style:UIBarButtonItemStyleDone target:self action:@selector(touchDoneButton)];
    doneButton.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:doneButton, nil]];

    [AppHelper setTitleViewForNavigationBar:self.navigationItem title:NSLocalizedString(@"Update banners", nil)];
}

- (void) layoutCollectionView{
    layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setMinimumInteritemSpacing:PADDING_ITEM];
    [layout setMinimumLineSpacing:PADDING_ITEM];
    CGFloat itemSize = _collectionView.bounds.size.width/3 - (PADDING_ITEM * 2);
    [layout setItemSize:CGSizeMake(itemSize, itemSize)];
    [_collectionView setCollectionViewLayout:layout];
}

- (void)initBanner {

    if (_bannerList) {
        //                _bannerList =  data.bannerList;
        for (int i = 0; i < BANNER_LIMIT; i++) {
            if (i < _bannerList.count) {
                BannerObj *temp = (BannerObj *)_bannerList[i];
                [banners addObject:temp.photo_url];
                [selectedPosts insertObject:temp.post_id atIndex:i];
                
                [self.croppedRects addObject:[NSValue valueWithCGRect:CGRectMake(temp.x1, temp.y1, temp.x2, temp.y2)]];
            } else {
                [banners addObject:@""];
                [selectedPosts insertObject:@"" atIndex:i];
                [self.croppedRects addObject:[NSValue valueWithCGRect:CGRectZero]];
            }
        }
        [self initSlideShow];
    }

}

- (void)touchDoneButton
{
    [spinner startAnimating];
    banners_add *param = [[banners_add alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] posts:selectedPosts croppedRects:self.croppedRects];
    if (param) {
        typeof(ChangeBannerViewController) * weakSelf = self;
        API_Profile_AddBanners *api = [[API_Profile_AddBanners alloc] initWithParams:param];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            [spinner stopAnimating];
            if (response.status) {
                if ([weakSelf.delegate respondsToSelector:@selector(updateBannerSuccess)]) {
                    [weakSelf.delegate updateBannerSuccess];
                }
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [AppHelper showMessageBox:nil message:response.message];
            }
        } ErrorHandlure:^(NSError *error) {
            [spinner stopAnimating];
        }];
    }
}

- (void)initSlideShow
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    for (int i = 0; i < banners.count; i++)
    {

        ProfileBannerView *profileBannerView = (ProfileBannerView*)[[[NSBundle mainBundle] loadNibNamed:@"ProfileBannerView" owner:self options:nil] objectAtIndex:0];
        profileBannerView.translatesAutoresizingMaskIntoConstraints = false;
        profileBannerView.clipsToBounds = true;
        profileBannerView.delegate = self;
        
        if(![banners[i] isEqualToString:@""])
        {
            [profileBannerView setBannerWithURLString:[banners objectAtIndex:i] croppedRectValue:[self.croppedRects objectAtIndex:i]];
        }
        
        [self.bannerViews addObject:profileBannerView];
        
        [self.slideShowContentView addSubview:profileBannerView];
        [self.selectedItemIndexPaths addObject:[NSNumber numberWithInteger:-1]];
        
        if (i == 0)
        {
            [AppHelper setupConstraintsForHorizontalView:profileBannerView previousView:self.slideShowContentView isFirstView:true parentView:self.slideShowContentView width:screenSize.width spacing:0];
        }
        else
        {
            UIImageView *previousView = (UIImageView*)[self.bannerViews objectAtIndex:i - 1];
            [AppHelper setupConstraintsForHorizontalView:profileBannerView previousView:previousView isFirstView:false parentView:self.slideShowContentView width:screenSize.width spacing:0];
        }
        
        
    }
    
    self.contentViewWidth.constant = banners.count * screenSize.width;    
}

- (void)bannerTouchRemove:(ProfileBannerView *)banner{
    for (int i = 0; i < self.bannerViews.count; i++) {
        ProfileBannerView * view = [self.bannerViews objectAtIndex:i];
        if (banner == view) {
            selectedPosts[i] = @"";
            self.croppedRects[i] = [NSValue valueWithCGRect:CGRectZero];
        }
    }
}

- (void)loadPostList {
    [spinner startAnimating];
    API_Profile_PostFetches *api = [[API_Profile_PostFetches alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] uid:profileData.uid post_id:lastPostID];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        out_profile_post_fetches * data = (out_profile_post_fetches *) jsonObject;
        if (response.status) {
            [spinner stopAnimating];
            if([[data photoList] count] > 0 ){
                if(photoList.count == 0 ){
                    photoList = [data photoList];
                } else {
                    [photoList addObjectsFromArray:[data photoList]];
                }
                
                lastPostID = ((photo*)photoList[photoList.count-1]).post_id;
                [_collectionView reloadData];
            }
            
        } else {
            [AppHelper showMessageBox:nil message:response.message];
        }
    } ErrorHandlure:^(NSError *error) {
        [spinner stopAnimating];
    }];

}

#pragma mark - UICollection View Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return photoList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize screenSize = UIScreen.mainScreen.bounds.size;
    return CGSizeMake(screenSize.width / 3 - 4, screenSize.width / 3 - 4);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 4;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCollectionViewCell *cell = (PhotoCollectionViewCell *)[_collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

    photo *temp = (photo *)[photoList objectAtIndex:indexPath.row];
    [cell.image setImageWithAnimationFromURL:[NSURL URLWithString:temp.photo_url] placeHolder:[UIImage imageNamed:@"Banners_mockup.png"]];

    cell.tickPhoto.hidden = true;
    
    if (self.selectedItemIndexPaths.count > 0) {
        if ([self.selectedItemIndexPaths[currentIndex] integerValue] == indexPath.row)
        {
            cell.tickPhoto.hidden = false;
        }
    }
    
    
    if(indexPath.item == photoList.count -1){
        [self loadMorePhoto];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = (PhotoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    photo *temp = (photo *)[photoList objectAtIndex:indexPath.row];
    
    cell.tickPhoto.hidden = false;
    
    [banners replaceObjectAtIndex:currentIndex withObject:temp.photo_url];
    [selectedPosts replaceObjectAtIndex:currentIndex withObject:temp.post_id];
    
//    NSInteger indexPrevious = [self.selectedItemIndexPaths[currentIndex] integerValue];
    NSInteger indexPrevious = self.selectedItemIndexPaths.count > 0 ?  [self.selectedItemIndexPaths[currentIndex] integerValue] : 0;
    
    NSIndexPath* previousSelectedIndexPath = [NSIndexPath indexPathForRow:indexPrevious inSection:0];
    
    [self.selectedItemIndexPaths replaceObjectAtIndex:currentIndex withObject:[NSNumber numberWithInteger:indexPath.row]];
    
    if (indexPrevious != -1 && indexPrevious != indexPath.row)
    {
        [collectionView reloadItemsAtIndexPaths:@[previousSelectedIndexPath]];
    }

    if (temp.photo_url_fullSize) {
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:temp.photo_url_fullSize] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [spinner startAnimating];
            });
            
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [spinner stopAnimating];
                if (image) {
                    
                    ImageCropViewController *imageCropViewController = [[ImageCropViewController alloc] initWithImage:image];
                    imageCropViewController.delegate = self;
                    imageCropViewController.hidesBottomBarWhenPushed = true;
                    [self.navigationController pushViewController:imageCropViewController animated:true];
                    
                }
            });
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _slideshow) {
        // it's not good. consider later
        if(currentIndex >= selectedPosts.count)
            return;
        if ((NSInteger)_slideshow.contentOffset.x % (NSInteger)[UIScreen mainScreen].bounds.size.width == 0) {
            currentIndex = _slideshow.contentOffset.x / ((NSInteger)[UIScreen mainScreen].bounds.size.width);
            _pageControl.currentPage = currentIndex;
//            [self.collectionView reloadData];
        }
    }
}

#pragma mark - Other Functions
-(void) loadMorePhoto{
    [self loadPostList];
}

#pragma mark - ImageCropView protocols implement
-(void)ImageCropViewControllerDidCancel:(UIViewController *)controller {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)ImageCropViewControllerSuccess:(UIViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage rect:(CGRect)croppingRect {
    if(croppedImage != nil) {
//        UIImageView * imgv = [self.imageViews objectAtIndex:currentIndex];
        ProfileBannerView * bannerView =  [self.bannerViews objectAtIndex:currentIndex];
        [bannerView.bannerImageView setImage:croppedImage];
//        [(UIImageView*)[self.imageViews objectAtIndex:currentIndex] setImage:croppedImage];
        [self.croppedRects replaceObjectAtIndex:currentIndex withObject:[NSValue valueWithCGRect:CGRectMake(croppingRect.origin.x, croppingRect.origin.y, croppingRect.size.width + croppingRect.origin.x, croppingRect.size.height + croppingRect.origin.y)]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
