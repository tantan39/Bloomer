//
//  PhotoGalleryViewController.m
//  Bloomer
//
//  Created by Steven on 6/4/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Photos/Photos.h>

#import "PhotoGalleryViewController.h"
#import "PhotoGalleryCell.h"
#import "AlbumInfo.h"
#import "AppHelper.h"
#import "UIColor+Extension.h"
#import "PhotoCollectionViewCell.h"
#import "ChoosingPhotosCollectionViewCell.h"
#import "ChoosingRacesUploadViewController.h"
#import "DZNPhotoEditorViewController.h"
#import "ChangeAvatarViewController.h"

@interface PhotoGalleryViewController ()

@property (strong, nonatomic) NSMutableArray *albums;
@property (strong, nonatomic) NSMutableArray *albumPhotos;
@property (strong, nonatomic) UIButton *buttonChangeAlbum;
@property (assign, nonatomic) BOOL buttonChangeAlbumState;
@property (strong, nonatomic) NSIndexPath *selectedPhotoIndex;
@property (strong, nonatomic) NSMutableArray *selectedPhotoIndexes;
@property (strong, nonatomic) UIImage *selectedPhoto;
@property (strong, nonatomic) NSMutableArray *selectedPhotos;
@property (strong, nonatomic) UIBarButtonItem *buttonNext;
@property (assign, nonatomic) NSInteger totalUploadedPhotos;
@property (strong, nonatomic) NSMutableArray *originalPhotosIndexes;

@end

@implementation PhotoGalleryViewController

// MARK: - Functions

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigationController];
    
    [self.tableView registerNib:[UINib nibWithNibName:[PhotoGalleryCell nibName] bundle:nil] forCellReuseIdentifier:[PhotoGalleryCell cellIdentifier]];
    
    if (!self.isMultipleChoice)
    {
        [self.collectionView registerNib:[UINib nibWithNibName:[PhotoCollectionViewCell nibName] bundle:nil]forCellWithReuseIdentifier:[PhotoCollectionViewCell cellIdentifier]];
    }
    else
    {
        [self.collectionView registerNib:[UINib nibWithNibName:[ChoosingPhotosCollectionViewCell nibName] bundle:nil] forCellWithReuseIdentifier:[ChoosingPhotosCollectionViewCell cellIdentifier]];
    }
    
    [self touchButtonChangeAlbums:self.buttonChangeAlbum];
    self.buttonNext.enabled = false;
    
    self.totalUploadedPhotos = 0;
    self.selectedPhotoIndex = nil;
    self.buttonChangeAlbumState = false; // FALSE: down, TRUE: up.
    self.originalPhotosIndexes = [[NSMutableArray alloc] init];
    self.selectedPhotoIndexes = [[NSMutableArray alloc] init];
    self.selectedPhotos = [[NSMutableArray alloc] init];
    self.albums = [[NSMutableArray alloc] init];
    self.albumPhotos = [[NSMutableArray alloc] init];
    [self loadAlbums];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [AppHelper changeNavigationBarToWhite:self.navigationController];
//    self.buttonChangeAlbum.transform = CGAffineTransformMakeScale(-1.0, 1.0);
//    self.buttonChangeAlbum.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
//    self.buttonChangeAlbum.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [AppHelper changeNavigationBarToRed:self.navigationController];
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

- (void)initNavigationController{
    
    [AppHelper changeNavigationBarToWhite:self.navigationController];
    
    self.buttonChangeAlbum = [[UIButton alloc] init];
//    self.buttonChangeAlbum.transform = CGAffineTransformMakeScale(-1.0, 1.0);
//    self.buttonChangeAlbum.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
//    self.buttonChangeAlbum.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    self.buttonChangeAlbum.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
    self.buttonChangeAlbum.backgroundColor = [UIColor clearColor];
    self.buttonChangeAlbum.titleLabel.font = [UIFont fontWithName:NAVIGATION_TITLE_FONT_NAME size:NAVIGATION_TITLE_FONT_SIZE];
    [self.buttonChangeAlbum setTitleColor:[UIColor colorFromHexString:@"#202021"] forState:UIControlStateNormal];
    [self.buttonChangeAlbum setTitle:[[AppHelper getLocalizedString:@"PhotoGallery.allPhotoTitle"] stringByAppendingString:@" "]  forState:UIControlStateNormal];
    [self.buttonChangeAlbum setImage:[UIImage imageNamed:@"Icon_Arrow_Down"] forState:UIControlStateNormal];
    [self.buttonChangeAlbum sizeToFit];
    [self.buttonChangeAlbum addTarget:self action:@selector(touchButtonChangeAlbums:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = self.buttonChangeAlbum;
    
    self.buttonNext = [[UIBarButtonItem alloc] initWithTitle:[AppHelper getLocalizedString:@"common.buttonNext"] style:UIBarButtonItemStylePlain target:self action:@selector(touchButtonNext:)];
    self.navigationItem.rightBarButtonItem = self.buttonNext;
}

- (void)loadAlbums
{
    [self.albums removeAllObjects];
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                PHFetchOptions *otherAlbumOptions = [PHFetchOptions new];
                PHFetchOptions *cameraRollOptions = [PHFetchOptions new];
                
                otherAlbumOptions.predicate = [NSPredicate predicateWithFormat:@"estimatedAssetCount > 0"];
                
                PHFetchResult *otherAlbumsResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:otherAlbumOptions];
                PHFetchResult *cameraRollAlbumResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:cameraRollOptions];
                
                [otherAlbumsResult enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL *stop) {
                    
                    AlbumInfo *albumInfo = [[AlbumInfo alloc] init];
                    albumInfo.name = collection.localizedTitle;
                    albumInfo.albumCollection = collection;
                    
                    PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
                    albumInfo.totalPhoto = assetsFetchResult.count;
                    
                    [self getImageFromAsset:assetsFetchResult.firstObject completion:^(UIImage *image) {
                        albumInfo.thumbnail = image;
                    }];
                    
                    [self.albums addObject:albumInfo];
                }];
                
                [cameraRollAlbumResult enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL *stop) {
                    
                    AlbumInfo *albumInfo = [[AlbumInfo alloc] init];
                    albumInfo.name = [AppHelper getLocalizedString:@"PhotoGallery.allPhotoTitle"];
                    albumInfo.albumCollection = collection;
                    
                    PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
                    albumInfo.totalPhoto = assetsFetchResult.count;

                    [self getImageFromAsset:assetsFetchResult.lastObject completion:^(UIImage *image) {
                        albumInfo.thumbnail = image;
                    }];
                    
                    [self.albums insertObject:albumInfo atIndex:0];
                    [self loadAlbumPhotos:collection];
                }];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            });
        }
        else
        {
            
        }
    }];
}

- (void)loadAlbumPhotos:(PHAssetCollection*) collection
{
    [self.albumPhotos removeAllObjects];
    
    if (self.isMultipleChoice)
    {
        [self.selectedPhotoIndexes removeAllObjects];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized)
        {
            PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
            fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            
            PHFetchResult *allPhotos = [PHAsset fetchAssetsInAssetCollection:collection options:fetchOptions];
            
            for (PHAsset *asset in allPhotos)
            {
                [self.albumPhotos addObject:asset];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }
    }];
}

- (void)getImageFromAsset:(PHAsset*)asset completion:(void (^)(UIImage* image))completion
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    CGSize screenSize = UIScreen.mainScreen.bounds.size;
    
    [PHImageManager.defaultManager requestImageForAsset:asset targetSize:CGSizeMake(screenSize.width / 3, screenSize.height / 3) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        completion(result);
    }];
}

- (void)getOriginalImageFromAsset:(PHAsset*)asset completion:(void (^)(UIImage* image))completion
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.networkAccessAllowed = true;
    
    [PHImageManager.defaultManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        completion(result);
    }];
}

- (void)getOriginalImageFromAsset:(PHAsset*)asset andIndex:(NSInteger) index completion:(void (^)(UIImage* image, NSInteger index))completion
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.networkAccessAllowed = true;
    
    [PHImageManager.defaultManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        completion(result, index);
    }];
}


- (void)hideAlbumList
{
    self.tableViewCenterY.constant = [UIScreen mainScreen].bounds.size.height;

    [UIView animateWithDuration:0.3 animations:^{
        [self.tableView setNeedsLayout];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished)
        {
            
        }
    }];
}

- (void)showAlbumList
{
    self.tableViewCenterY.constant = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.tableView setNeedsLayout];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished)
        {
            
        }
    }];
}

- (void)arrangePhotolist
{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.selectedPhotos.count; i++)
    {
        for (NSInteger j = 0 ; j < self.originalPhotosIndexes.count; j++)
        {
            NSInteger temp = [[self.originalPhotosIndexes objectAtIndex:j] intValue];
            if (temp == i)
            {
                [result addObject:[self.selectedPhotos objectAtIndex:j]];
                break;
            }
        }
    }
    self.selectedPhotos = result;
}

// MARK: - UITableViewDelegate, UITableViewDatasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.albums.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoGalleryCell *cell = (PhotoGalleryCell*)[tableView dequeueReusableCellWithIdentifier:[PhotoGalleryCell cellIdentifier] forIndexPath:indexPath];
    
    AlbumInfo *albumInfo = (AlbumInfo*)[self.albums objectAtIndex:indexPath.row];
    cell.labelAlbumName.text = albumInfo.name;
    cell.labelAlbumPhotoNumber.text = @(albumInfo.totalPhoto).stringValue;
    cell.albumThumbnail.image = albumInfo.thumbnail;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PhotoGalleryCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlbumInfo *albumInfo = (AlbumInfo*)[self.albums objectAtIndex:indexPath.row];
    [self loadAlbumPhotos:albumInfo.albumCollection];
    [self touchButtonChangeAlbums:self.buttonChangeAlbum];
    [self.buttonChangeAlbum setTitle:albumInfo.name forState:UIControlStateNormal];
}

// MARK: - UICollectionViewDelegate, UICollectionViewDatasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.albumPhotos.count;
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
    if (!self.isMultipleChoice)
    {
        PhotoCollectionViewCell *cell = (PhotoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[PhotoCollectionViewCell cellIdentifier] forIndexPath:indexPath];
        
        PHAsset *asset = (PHAsset*)self.albumPhotos[indexPath.row];
        [self getImageFromAsset:asset completion:^(UIImage *image) {
            cell.image.image = image;
        }];
        
        [cell setHidenBorder:TRUE];
        
        if (self.selectedPhotoIndex != nil && [indexPath compare:self.selectedPhotoIndex] == NSOrderedSame)
        {
            [cell setHidenBorder: FALSE];
        }
        else
        {
            [cell setHidenBorder: TRUE];
        }
        
        return cell;
    }
    else
    {
        ChoosingPhotosCollectionViewCell *cell = (ChoosingPhotosCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[ChoosingPhotosCollectionViewCell cellIdentifier] forIndexPath:indexPath];

        PHAsset *asset = (PHAsset*)self.albumPhotos[indexPath.row];
        [self getImageFromAsset:asset completion:^(UIImage *image) {
            cell.image.image = image;
        }];
        
        [cell getCellToNormal];
        for (int i = 0; i < self.selectedPhotoIndexes.count; i++)
        {
            NSIndexPath *index = (NSIndexPath *)[self.selectedPhotoIndexes objectAtIndex:i];
            
            if (index.row == indexPath.row)
            {
                [cell onClickImage:i + 1];
                break;
            }
        }
        
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isMultipleChoice)
    {
        NSMutableArray *indexPaths = [NSMutableArray arrayWithObject:indexPath];
        PhotoCollectionViewCell *cell = (PhotoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        if (self.selectedPhotoIndex)
        {
            if ([indexPath compare:self.selectedPhotoIndex] == NSOrderedSame)
            {
                self.selectedPhotoIndex = nil;
                self.selectedPhoto = nil;
                self.buttonNext.enabled = false;
                [collectionView reloadItemsAtIndexPaths:indexPaths];
                
                return;
            }
            else
            {
                [indexPaths addObject:self.selectedPhotoIndex];
                self.selectedPhotoIndex = indexPath;
                self.buttonNext.enabled = true;
            }
        }
        else
        {
            self.selectedPhotoIndex = indexPath;
            self.buttonNext.enabled = true;
        }
        
        [cell setHidenBorder:FALSE];
        [collectionView reloadItemsAtIndexPaths:indexPaths];
    }
    else
    {
        BOOL contain = FALSE;
        int deleteIndex = 0;
        NSMutableArray<NSIndexPath*> *needToReloadIndexPaths = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < self.selectedPhotoIndexes.count; i++)
        {
            NSIndexPath *index = (NSIndexPath*)[self.selectedPhotoIndexes objectAtIndex:i];
            [needToReloadIndexPaths addObject:index];
            
            if (index.row == indexPath.row)
            {
                contain = TRUE;
                deleteIndex = i;
                break;
            }
        }
        
        if (!contain)
        {
            self.buttonNext.enabled = true;
            
            [self.selectedPhotoIndexes addObject:indexPath];
            [needToReloadIndexPaths addObject:indexPath];
            
            if (self.selectedPhotoIndexes.count > 5)
            {
                [self.selectedPhotoIndexes removeObjectAtIndex:0];
            }
            
            [collectionView reloadItemsAtIndexPaths:needToReloadIndexPaths];
            if ([self.selectedPhotoIndexes count] == 0)
            {
                self.buttonNext.enabled = false;
            }
        }
        else
        {
            [self.selectedPhotoIndexes removeObjectAtIndex:deleteIndex];
            
            [collectionView reloadItemsAtIndexPaths:needToReloadIndexPaths];
            if ([self.selectedPhotoIndexes count] == 0)
            {
                self.buttonNext.enabled = false;
            }
        }
    }
}

// MARK: - Selectors
- (void)touchButtonChangeAlbums:(UIButton*)button
{
    if (!self.buttonChangeAlbumState)
    {
        [self.buttonChangeAlbum setImage:[UIImage imageNamed:@"Icon_Arrow_Up"] forState:UIControlStateNormal];
        [self hideAlbumList];
    }
    else
    {
        [self.buttonChangeAlbum setImage:[UIImage imageNamed:@"Icon_Arrow_Down"] forState:UIControlStateNormal];
        [self showAlbumList];
    }
    
    self.buttonChangeAlbumState = !self.buttonChangeAlbumState;
}

- (void)touchButtonNext:(UIBarButtonItem*)button
{
    if (!self.isMultipleChoice)
    {
        if (self.selectedPhotoIndex == nil)
            return;
                
        PHAsset *asset = (PHAsset*)self.albumPhotos[self.selectedPhotoIndex.row];
        [self getOriginalImageFromAsset:asset completion:^(UIImage *image) {
            
            DZNPhotoEditorViewController *editPhotoViewController = [[DZNPhotoEditorViewController alloc] initWithImage:image];
            editPhotoViewController.cropMode = DZNPhotoEditorViewControllerCropModeCircular;
            [editPhotoViewController setAcceptBlock:^(DZNPhotoEditorViewController *editor, NSDictionary *userInfo) {
                
                UIImage *edittedPhoto = userInfo[UIImagePickerControllerEditedImage];
                
                if (self.chosePhoto != nil)
                {
                    self.chosePhoto(edittedPhoto);
                    [self.parentView.navigationController popToViewController:self.parentView animated:true];
                    return;
                }
                
//                if ([_parentView isKindOfClass:[ConfirmInfoViewController class]])
//                {
//                    self.selectedPhoto = edittedPhoto;
//                    
//                    for (UIViewController *controller in self.parentView.navigationController.viewControllers)
//                    {
//                        ConfirmInfoViewController *confirmInfoVC = (ConfirmInfoViewController *) controller;
//                        if ([confirmInfoVC isKindOfClass:[ConfirmInfoViewController class]])
//                        {
//                            confirmInfoVC.imgAvatar = edittedPhoto;
//                            [self.parentView.navigationController popToViewController:confirmInfoVC animated:YES];
//                            
//                            break;
//                        }
//                    }
//                }
                else if ([_parentView isKindOfClass:[UpdateInfoViewController class]]){
                    self.selectedPhoto = edittedPhoto;
                    
                    for (UIViewController *controller in self.parentView.navigationController.viewControllers)
                    {
                        UpdateInfoViewController *updateInfoVC = (UpdateInfoViewController *) controller;
                        if ([updateInfoVC isKindOfClass:[UpdateInfoViewController class]])
                        {
                            updateInfoVC.imgUpload = edittedPhoto;
                            [self.parentView.navigationController popToViewController:updateInfoVC animated:YES];
                            
                            break;
                        }
                    }
                }
                else if ([_parentView isKindOfClass:[ChangeAvatarViewController class]])
                {
                    ChangeAvatarViewController *view = (ChangeAvatarViewController *)self.parentView;
                    view.isUploadFromBloomer = false;
                    [view updateAvatarForRaceByIndex:self.selectedPhotoIndex.row andImage:edittedPhoto];
                }
                else
                {
                    MyProfileViewController *view = (MyProfileViewController*)self.parentView;
                    [view UploadAvatartoLocationRaceWithImage:edittedPhoto raceKey:@"vn" complete:^{
//                        [self.parentView.navigationController setNavigationBarHidden:NO];
//                        [self.parentView.navigationController popToViewController:self.parentView animated:YES];
                    }];
                }
            }];
            
            [editPhotoViewController setCancelBlock:^(DZNPhotoEditorViewController *editor){
                [self.parentView.navigationController popViewControllerAnimated:YES];
            }];
            
            [self.navigationController pushViewController:editPhotoViewController animated:true];
        }];
    }
    else
    {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
        self.totalUploadedPhotos = 0;
        [self.selectedPhotos removeAllObjects];
        [self.originalPhotosIndexes removeAllObjects];
        
        for (NSInteger i = 0; i < self.selectedPhotoIndexes.count; i++)
        {
            NSIndexPath *indexPath = (NSIndexPath*)[self.selectedPhotoIndexes objectAtIndex:i];
            PHAsset *asset = (PHAsset*)self.albumPhotos[indexPath.row];
            
            [self getOriginalImageFromAsset:asset andIndex:i completion:^(UIImage *image, NSInteger index) {
                
                if (image != nil)
                {
                    self.totalUploadedPhotos += 1;
                    [self.selectedPhotos addObject:image];
                    [self.originalPhotosIndexes addObject:[NSNumber numberWithInteger:index]];
                    
                    if (self.totalUploadedPhotos == self.selectedPhotoIndexes.count)
                    {
                        [self arrangePhotolist];
                        
                        if (self.key == nil)
                        {
                            ChoosingRacesUploadViewController *viewController = [[ChoosingRacesUploadViewController alloc] init];
                            viewController.uploadPhotos = self.selectedPhotos;
                            viewController.parentView = self.parentView;
                            viewController.locationIndex = self.selectedPhotoIndexes;
                            viewController.hidesBottomBarWhenPushed = true;
                            [self.navigationController pushViewController:viewController animated:TRUE];
                            
                            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
                        }
                        else
                        {
                            UploadingPicturesTableViewController *viewController = [[UploadingPicturesTableViewController alloc] init];
                            viewController.uploadPhotos = self.selectedPhotos;
                            viewController.locationIndex = self.selectedPhotoIndexes;
                            viewController.parentView = self.parentView;
                            viewController.tag = [[NSMutableArray alloc] initWithObjects:self.key, nil];
                            viewController.key = self.key;
                            viewController.name = self.raceName;
                            viewController.hidesBottomBarWhenPushed = true;
                            
                            [self.parentView.navigationController pushViewController:viewController animated:TRUE];
                            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
                        }
                    }
                }

            }];
        }
    }
}

@end
