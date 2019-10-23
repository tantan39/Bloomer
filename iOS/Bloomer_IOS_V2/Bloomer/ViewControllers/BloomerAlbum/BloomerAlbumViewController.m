//
//  BloomerAlbumViewController.m
//  Bloomer
//
//  Created by Steven on 6/11/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerAlbumViewController.h"
#import "UserDefaultManager.h"
#import "AppHelper.h"
#import "PhotoCollectionViewCell.h"
#import <UIImageView+AFNetworking.h>
#import "UIColor+Extension.h"
#import "BloomerAlbumView.h"
#import "DZNPhotoEditorViewController.h"
#import "ChangeAvatarViewController.h"

//Tu L
#import "API_LoadPhoto.h"

#define PHOTO_LIMIT 20
#define MAX_DOT 5
#define DOT_HEIGHT 10

#define HIGHLIGHT_COLOR @"#B22225"
#define UNHIGHLIGHT_COLOR @"#BDBDBD"
#define MEDIUM_DOT_SIZE 1.5
#define SMALL_DOT_SIZE 2.5
#define NORMAL_DOT_SIZE 1
#define HIDDEN_DOT_SIZE 0

@interface BloomerAlbumViewController ()

@property (strong, nonatomic) UserDefaultManager *userDefaultManager;
@property (strong, nonatomic) NSMutableArray *photoList;
@property (strong, nonatomic) NSMutableArray *lastPostIDList;
@property (strong, nonatomic) NSMutableArray *collectionViews;
@property (strong, nonatomic) UIBarButtonItem *buttonNext;
@property (strong, nonatomic) UIImage *selectedPhoto;
@property (strong, nonatomic) NSIndexPath *selectedIndex;
@property (strong, nonatomic) NSString *selectedPhotoId;

@property (strong, nonatomic) NSMutableArray *dotViews;
@property (strong, nonatomic) NSMutableArray *dotViewHeightList;
@property (assign, nonatomic) NSInteger lastHighlightedIndex;
@property (strong, nonatomic) NSMutableArray *leftMarginList;

@end

@implementation BloomerAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userDefaultManager = [[UserDefaultManager alloc] init];
    self.photoList = [[NSMutableArray alloc] init];
    self.lastPostIDList = [[NSMutableArray alloc] init];
    self.collectionViews = [[NSMutableArray alloc] init];
    self.dotViews = [[NSMutableArray alloc] init];
    self.dotViewHeightList = [[NSMutableArray alloc] init];
    self.leftMarginList = [[NSMutableArray alloc] init];
    self.selectedPhoto = nil;
    self.selectedIndex = nil;
    self.lastHighlightedIndex = 0;
    
    [self initNavigationController];

    for (NSInteger i = 0; i < self.galleryList.count; i++)
    {
        profile_gallery *profileGallery = (profile_gallery*)[self.galleryList objectAtIndex:i];
        [self.photoList addObject:[[NSMutableArray alloc] init]];
        [self createCollectionViewWithTitle:profileGallery.name index:i];
    }
    
    self.contentViewWidth.constant = self.galleryList.count * [UIScreen mainScreen].bounds.size.width;
    [self loadBloomerAlbum];
    [self initPageControl];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [AppHelper changeNavigationBarToWhite:self.navigationController];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.translucent = false;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Top_bar_base"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (self.cancelChoosePhoto != nil && (self.isMovingFromParentViewController || self.isBeingDismissed))
    {
        self.cancelChoosePhoto();
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavigationController
{
    self.buttonNext = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Next",nil) style:UIBarButtonItemStylePlain target:self action:@selector(touchButtonNext:)];
    [self.navigationItem setRightBarButtonItem:self.buttonNext];

    if (self.selectedPhoto == nil)
    {
        [self.buttonNext setEnabled:false];
    }
    
    [AppHelper setTitleViewForNavigationBar:self.navigationItem title:NSLocalizedString(@"Bloomer Album", nil) color:[UIColor colorFromHexString:@"#202021"]];
}

- (void)loadBloomerAlbum
{
    for (NSInteger i = 0; i < self.galleryList.count; i++)
    {
        profile_gallery *gallery = (profile_gallery*)[self.galleryList objectAtIndex:i];
        NSString *lastPostID = @"";
        [self.lastPostIDList addObject:lastPostID];
        
        API_Profile_Post_GalleryFetches *api = [[API_Profile_Post_GalleryFetches alloc] initWithAccessToken:[self.userDefaultManager getAccessToken] device_token:[self.userDefaultManager getDeviceToken] key:gallery.key uid:[self.userDefaultManager getUserProfileData].uid post_id:lastPostID limit:PHOTO_LIMIT];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            JSON_GalleryFetches *data = (JSON_GalleryFetches *)jsonObject;
            if (response.status) {
                for (int i = 0; i < self.galleryList.count; i++)
                {
                    profile_gallery *profileGallery = (profile_gallery*)[self.galleryList objectAtIndex:i];
                    
                    if ([profileGallery.key isEqualToString:gallery.key])
                    {
                        [self.photoList replaceObjectAtIndex:i withObject:data.galleryList];
                        UICollectionView *collectionView = (UICollectionView*)[self.collectionViews objectAtIndex:i];
                        [collectionView reloadData];
                        break;
                    }
                }
            }
            else
            {
                [AppHelper showMessageBox:nil message:response.message];
            }
        } ErrorHandlure:^(NSError *error) {
            
        }];

    }
}

- (void)createCollectionViewWithTitle:(NSString*)title index:(NSInteger)index
{
    BloomerAlbumView *bloomerAlbumView = [[NSBundle mainBundle] loadNibNamed:@"BloomerAlbumView" owner:self.contentView options:nil][0];
    bloomerAlbumView.translatesAutoresizingMaskIntoConstraints = false;
    bloomerAlbumView.collectionView.tag = index;
    bloomerAlbumView.collectionView.delegate = self;
    bloomerAlbumView.collectionView.dataSource = self;
    [bloomerAlbumView.collectionView registerNib:[UINib nibWithNibName:[PhotoCollectionViewCell nibName] bundle:nil] forCellWithReuseIdentifier:[PhotoCollectionViewCell cellIdentifier]];
    bloomerAlbumView.labelTitle.text = title;
    [self.contentView addSubview:bloomerAlbumView];
    
    if (index == 0)
    {
        [AppHelper setupConstraintsForHorizontalView:[bloomerAlbumView.collectionView superview] previousView:nil isFirstView:true parentView:self.contentView width:[UIScreen mainScreen].bounds.size.width spacing:0];
        
        [self.collectionViews addObject:bloomerAlbumView.collectionView];
    }
    else
    {
        UICollectionView *previousCollectionView = (UICollectionView*)[self.collectionViews objectAtIndex:index - 1];
        
        [AppHelper setupConstraintsForHorizontalView:[bloomerAlbumView.collectionView superview] previousView:previousCollectionView isFirstView:false parentView:self.contentView width:[UIScreen mainScreen].bounds.size.width spacing:0];
        
        [self.collectionViews addObject:bloomerAlbumView.collectionView];
    }
}

- (void)initPageControl
{
    for (NSInteger i = 0; i < self.galleryList.count; i++)
    {
        [self createDotViewWithIndex:i];
    }
    
    if (self.dotViews && [self.dotViews count] > 0)
        [self highlightDotViewWithIndex:0];
    
    if (self.galleryList.count <= MAX_DOT)
    {
        self.pageControlMainViewWidth.constant = (DOT_HEIGHT * self.galleryList.count) + ((self.galleryList.count - 1) * DOT_HEIGHT / 2);
    }
    else
    {
        self.pageControlMainViewWidth.constant = (DOT_HEIGHT * 3) + (DOT_HEIGHT / 2 * MAX_DOT) + (DOT_HEIGHT / MEDIUM_DOT_SIZE) + (10 / SMALL_DOT_SIZE);
    }
}

- (void)createDotViewWithIndex:(NSInteger)index
{
    UIView *dotView = [[UIView alloc] init];
    dotView.layer.cornerRadius = 5;
    dotView.backgroundColor = [UIColor colorFromHexString:UNHIGHLIGHT_COLOR];
    dotView.translatesAutoresizingMaskIntoConstraints = false;
    dotView.clipsToBounds = true;
    
    [self.pageControlMainView addSubview:dotView];
    
    if (self.dotViews.count == 0)
    {
        [self setupConstraintsForDotView:dotView previousView:nil isFirstView:true parentView:self.pageControlMainView height:DOT_HEIGHT spacing:DOT_HEIGHT / 2];
    }
    else
    {
        UIView *previousDotView = (UIView*)[self.dotViews objectAtIndex:self.dotViews.count - 1];
        [self setupConstraintsForDotView:dotView previousView:previousDotView isFirstView:false parentView:self.pageControlMainView height:DOT_HEIGHT spacing:DOT_HEIGHT / 2];
    }
    
    [self.dotViews addObject:dotView];
    NSLayoutConstraint *dotViewHeight = (NSLayoutConstraint*)[self.dotViewHeightList objectAtIndex:index];
    NSLayoutConstraint *leftMargin = (NSLayoutConstraint*)[self.leftMarginList objectAtIndex:index];
    
    if (self.galleryList.count > MAX_DOT)
    {
        if (index == MAX_DOT - 1)
        {
            dotViewHeight.constant = DOT_HEIGHT / SMALL_DOT_SIZE;
            leftMargin.constant = DOT_HEIGHT / 2;
            dotView.layer.cornerRadius = dotViewHeight.constant / 2;
            return;
        }
        
        if (index == MAX_DOT - 2)
        {
            dotViewHeight.constant = DOT_HEIGHT / MEDIUM_DOT_SIZE;
            leftMargin.constant = DOT_HEIGHT / 2;
            dotView.layer.cornerRadius = dotViewHeight.constant / 2;
            return;
        }
        
        if (index >= MAX_DOT)
        {
            dotViewHeight.constant = 0;
            leftMargin.constant = 0;
            return;
        }
    }
}

- (void)highlightDotViewWithIndex:(NSInteger)index
{
    UIView *lastHighlightedDotView = [self.dotViews objectAtIndex:self.lastHighlightedIndex];
    lastHighlightedDotView.backgroundColor = [UIColor colorFromHexString:UNHIGHLIGHT_COLOR];
    
    UIView *dotView = [self.dotViews objectAtIndex:index];
    dotView.backgroundColor = [UIColor colorFromHexString:HIGHLIGHT_COLOR];
}

- (void)moveToNextDotViewWithIndex:(NSInteger)index
{
    [self highlightDotViewWithIndex:index];
    
    if (index >= 3)
    {
        [self changeSizeForDotViewsForGoingUpWithCurrentIndex:index];
    }
}

- (void)backToPreviousDotViewWithIndex:(NSInteger)index
{
    [self highlightDotViewWithIndex:index];
    
    if (index <= self.galleryList.count - 1 - 3)
    {
        [self changeSizeForDotViewsForBackingWithCurrentIndex:index];
    }
}

- (void)changeSizeForDotViewsForGoingUpWithCurrentIndex:(NSInteger)currentIndex
{
    CGFloat width = 0;
    
    for (NSInteger i = 0; i < self.galleryList.count; i++)
    {
        BOOL isHidden = true;
        
        if (i == currentIndex - 3)
        {
            [self changeSizeForDotView:i size:MEDIUM_DOT_SIZE];
            isHidden = false;
            width += (DOT_HEIGHT / 2) + (DOT_HEIGHT / MEDIUM_DOT_SIZE);
        }
        
        if (i == currentIndex - 4)
        {
            [self changeSizeForDotView:i size:SMALL_DOT_SIZE];
            isHidden = false;
            width += (DOT_HEIGHT / 2) + (DOT_HEIGHT / SMALL_DOT_SIZE);
        }
        
        if (i == currentIndex + 1)
        {
            [self changeSizeForDotView:i size:MEDIUM_DOT_SIZE];
            isHidden = false;
            width += (DOT_HEIGHT / 2) + (DOT_HEIGHT / MEDIUM_DOT_SIZE);
        }
        
        if (i == currentIndex + 2)
        {
            [self changeSizeForDotView:i size:SMALL_DOT_SIZE];
            isHidden = false;
            width += (DOT_HEIGHT / 2) + (DOT_HEIGHT / SMALL_DOT_SIZE);
        }
        
        if (i >= currentIndex - 2 && i <= currentIndex)
        {
            [self changeSizeForDotView:i size:NORMAL_DOT_SIZE];
            isHidden = false;
            width += (DOT_HEIGHT / 2) + (DOT_HEIGHT / NORMAL_DOT_SIZE);
        }
        
        if (isHidden)
        {
            [self changeSizeForDotView:i size:HIDDEN_DOT_SIZE];
        }
    }
    
    NSLog(@"Width: %f", width);
    self.pageControlMainViewWidth.constant = width;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)changeSizeForDotViewsForBackingWithCurrentIndex:(NSInteger)currentIndex
{
    CGFloat width = 0;
    
    for (NSInteger i = 0; i < self.galleryList.count; i++)
    {
        BOOL isHidden = true;
        
        if (i == currentIndex - 1)
        {
            [self changeSizeForDotView:i size:MEDIUM_DOT_SIZE];
            isHidden = false;
            width += (DOT_HEIGHT / 2) + (DOT_HEIGHT / MEDIUM_DOT_SIZE);
        }
        
        if (i == currentIndex - 2)
        {
            [self changeSizeForDotView:i size:SMALL_DOT_SIZE];
            isHidden = false;
            width += (DOT_HEIGHT / 2) + (DOT_HEIGHT / SMALL_DOT_SIZE);
        }
        
        if (i == currentIndex + 3)
        {
            [self changeSizeForDotView:i size:MEDIUM_DOT_SIZE];
            isHidden = false;
            width += (DOT_HEIGHT / 2) + (DOT_HEIGHT / MEDIUM_DOT_SIZE);
        }
        
        if (i == currentIndex + 4)
        {
            [self changeSizeForDotView:i size:SMALL_DOT_SIZE];
            isHidden = false;
            width += (DOT_HEIGHT / 2) + (DOT_HEIGHT / SMALL_DOT_SIZE);
        }
        
        if (i >= currentIndex && i <= currentIndex + 2)
        {
            [self changeSizeForDotView:i size:NORMAL_DOT_SIZE];
            isHidden = false;
            width += (DOT_HEIGHT / 2) + (DOT_HEIGHT / NORMAL_DOT_SIZE);
        }
        
        if (isHidden)
        {
            [self changeSizeForDotView:i size:HIDDEN_DOT_SIZE];
        }
    }
    
    self.pageControlMainViewWidth.constant = width;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)changeSizeForDotView:(NSInteger)index size:(CGFloat)size
{
    NSLayoutConstraint *dotViewHeight = (NSLayoutConstraint*)[self.dotViewHeightList objectAtIndex:index];
    NSLayoutConstraint *leftMargin = (NSLayoutConstraint*)[self.leftMarginList objectAtIndex:index];
    UIView *dotView = [self.dotViews objectAtIndex:index];
    
    if (size == 0)
    {
        dotViewHeight.constant = 0;
        leftMargin.constant = 0;
    }
    else
    {
        dotViewHeight.constant = DOT_HEIGHT / size;
        dotView.layer.cornerRadius = dotViewHeight.constant / 2;
        
        if (index != 0)
        {
            leftMargin.constant = DOT_HEIGHT / 2;
        }
    }
}

- (void)setupConstraintsForDotView:(UIView*)view previousView:(UIView*)previousView isFirstView:(BOOL)isFirstView parentView:(UIView*)parentView height:(CGFloat)height spacing:(CGFloat)spacing
{
    NSLayoutConstraint *leftMargin = [[NSLayoutConstraint alloc] init];
    
    if (isFirstView)
    {
        leftMargin = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    }
    else
    {
        leftMargin = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeRight multiplier:1 constant:spacing];
    }
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height];
    NSLayoutConstraint *ratioConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    [parentView addConstraints:@[leftMargin, centerY]];
    [view addConstraints:@[heightConstraint, ratioConstraint]];
    [self.dotViewHeightList addObject:heightConstraint];
    [self.leftMarginList addObject:leftMargin];
}

// MARK: - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView)
    {
        CGFloat offset = scrollView.contentOffset.x;
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        NSInteger currentIndex = (int)(offset) / (int)(screenWidth);
        
        if (self.lastHighlightedIndex != currentIndex && currentIndex < self.galleryList.count)
        {
            if (self.galleryList.count > MAX_DOT)
            {
                if (self.lastHighlightedIndex < currentIndex)
                {
                    [self moveToNextDotViewWithIndex:currentIndex];
                }
                else
                {
                    [self backToPreviousDotViewWithIndex:currentIndex];
                }
            }
            else
            {
                [self highlightDotViewWithIndex:currentIndex];
            }
            
            self.lastHighlightedIndex = currentIndex;
            NSLog(@"Current Index: %d", currentIndex);
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSMutableArray *photos = [self.photoList objectAtIndex:collectionView.tag];
    return photos.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    return CGSizeMake(screenSize.width / 3 - 2, screenSize.width / 3 - 2);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *photos = [self.photoList objectAtIndex:collectionView.tag];
    gallery *photo = [photos objectAtIndex:indexPath.row];
    
    PhotoCollectionViewCell *cell = (PhotoCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:[PhotoCollectionViewCell cellIdentifier] forIndexPath:indexPath];
    
    [cell setPhoto_id:photo.photo_id];
    [cell.image setImageWithURL:[NSURL URLWithString:photo.photo_url]];
    [cell setHidenBorder:true];
    
    if (self.selectedPhoto != nil && indexPath.row == self.selectedIndex.row && collectionView.tag == self.selectedIndex.section)
    {
        [cell setHidenBorder:false];
    }
    else
    {
        [cell setHidenBorder:true];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *cell = (PhotoCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setHidenBorder:false];
    
    self.selectedPhotoId = cell.photo_id;
    self.selectedPhoto = cell.image.image;

    if (self.selectedIndex)
    {
        if (indexPath.row == self.selectedIndex.row && collectionView.tag == self.selectedIndex.section)
        {
            self.selectedIndex = nil;
            self.selectedPhoto = nil;
            self.buttonNext.enabled = false;
        }
        else
        {
            UICollectionView *previousSelectedCollectionView = (UICollectionView*)[self.collectionViews objectAtIndex:self.selectedIndex.section];
            [previousSelectedCollectionView reloadData];
            
            self.selectedIndex = [NSIndexPath indexPathForRow:indexPath.row inSection:collectionView.tag];
            self.buttonNext.enabled = true;
        }
    }
    else
    {
        self.selectedIndex = [NSIndexPath indexPathForRow:indexPath.row inSection:collectionView.tag];
        self.buttonNext.enabled = true;
    }

    [collectionView reloadData];
}

// MARK: - Selectors
- (void)touchButtonNext:(UIBarButtonItem *)button
{
    if(self.selectedPhoto == nil)
        return;
    
    API_LoadPhoto *api = [[API_LoadPhoto alloc] initWithPhotoId:self.selectedPhotoId size:@"o"];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        if(response.status) {
            JSON_LoadPhoto *data = (JSON_LoadPhoto*)jsonObject;
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:data.photo_url]]];
            
            DZNPhotoEditorViewController *viewController = [[DZNPhotoEditorViewController alloc] initWithImage:image];
            viewController.cropMode = DZNPhotoEditorViewControllerCropModeCircular;
            [viewController setAcceptBlock:^(DZNPhotoEditorViewController *editor, NSDictionary *userInfo){
                profile_gallery *profileGallery = (profile_gallery*)[self.galleryList objectAtIndex:self.selectedIndex.section];
                UIImage *edittedPhoto = userInfo[UIImagePickerControllerEditedImage];
                self.selectedPhoto = edittedPhoto;
                
                if (self.chosePhoto != nil)
                {
                    self.chosePhoto(image);
                    [self.parentView.navigationController popToViewController:self.parentView animated:true];
                    return;
                }
                
                ChangeAvatarViewController *view = (ChangeAvatarViewController *)self.parentView;
                view.isUploadFromBloomer = [view.curRaceKey isEqualToString:profileGallery.name];
                [view updateAvatarForRaceByIndex:self.raceIndex andImage:edittedPhoto];
            }];
            
            [viewController setCancelBlock:^(DZNPhotoEditorViewController *editor){
                [self.parentView.navigationController popViewControllerAnimated:YES];
            }];
            
            [self.parentView.navigationController pushViewController:viewController animated:true];
        }
    } ErrorHandlure:^(NSError *error) {
        
    }];
    
//    DZNPhotoEditorViewController *viewController = [[DZNPhotoEditorViewController alloc] initWithImage:self.selectedPhoto];
//    viewController.cropMode = DZNPhotoEditorViewControllerCropModeCircular;
//    [viewController setAcceptBlock:^(DZNPhotoEditorViewController *editor, NSDictionary *userInfo){
//        profile_gallery *profileGallery = (profile_gallery*)[self.galleryList objectAtIndex:self.selectedIndex.section];
//        UIImage *edittedPhoto = userInfo[UIImagePickerControllerEditedImage];
//        self.selectedPhoto = edittedPhoto;
//
//        if (self.chosePhoto != nil)
//        {
//            self.chosePhoto(self.selectedPhoto);
//            [self.parentView.navigationController popToViewController:self.parentView animated:true];
//            return;
//        }
//
//        ChangeAvatarViewController *view = (ChangeAvatarViewController *)self.parentView;
//        view.isUploadFromBloomer = [view.curRaceKey isEqualToString:profileGallery.name];
//        [view updateAvatarForRaceByIndex:self.raceIndex andImage:edittedPhoto];
//    }];
//
//    [viewController setCancelBlock:^(DZNPhotoEditorViewController *editor){
//        [self.parentView.navigationController popViewControllerAnimated:YES];
//    }];
//
//    [self.parentView.navigationController pushViewController:viewController animated:true];
}

@end
