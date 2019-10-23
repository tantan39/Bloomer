//
//  PicturesRaceViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 2/24/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "PicturesRaceViewController.h"
#import "PhotoListViewController.h"
#import "AppHelper.h"
#import "FlowerGardenViewController.h"

#define THUMBHEIGHT 108
#define OBJECT_WIDTH 80.0f
#define OBJECT_HEIGHT 80.0f
#define MARGIN_VERTICAL 0.0f
#define MARGIN_HORIZONTAL 0.0f
#define DRAGGABLE_LOCATION_WIDTH  ((OBJECT_WIDTH  * 3) + (MARGIN_HORIZONTAL * 5))
#define DRAGGABLE_LOCATION_HEIGHT ((OBJECT_HEIGHT * 3) + (MARGIN_VERTICAL   * 5))

@interface PicturesRaceViewController ()
{
    UserDefaultManager *userDefaultManager;
    NSMutableArray *images;
    NSString *postID;
    NSString *post_id;
    BOOL loaded;
    NSIndexPath *giveIndex;
    NSTimer *timer;
    out_profile_fetch *profileData;
    FlowerMenuPostPopupViewController *flowerPopup;
    ImagePickerPopUpViewController *imagePickerPopup;
    BOOL onProcessPull;
    BOOL onProcessRefesh;
    NSInteger numData;
    NSInteger curData;
}

@property (assign, nonatomic) NSInteger loadedPostCount;

@end

@implementation PicturesRaceViewController
@synthesize circularMenu;//, flowerPopup;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    profileData = [userDefaultManager getUserProfileData];
    images = [[NSMutableArray alloc] init];
    self.postsData = [[NSMutableArray alloc] init];
    self.loadedPostCount = 0;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _tabbar = appDelegate.tabbar;
    
    _name.text = _raceName;
    postID = @"";
    loaded = FALSE;
    onProcessPull = FALSE;
    onProcessRefesh = FALSE;
    [self loadGallery];
    __weak PicturesRaceViewController *weakSelf = self;
    
    [_collectionView addPullToRefreshWithActionHandler:^{
        [weakSelf pullToRefresh];
    }];
    
    [_collectionView addInfiniteScrollingWithActionHandler:^{
        [weakSelf infiniteScrolling];
    }];

    if(_status == RACE_CLOSED || _status == RACE_LEFT)
    {
        [self.topInfoCloseView setHidden:false];
        self.topInfoCloseView.layer.masksToBounds = NO;
        self.topInfoCloseView.layer.shadowOffset = CGSizeMake(0, 1);
        self.topInfoCloseView.layer.shadowRadius = 2;
        self.topInfoCloseView.layer.shadowOpacity = 0.5;
        self.topInfoCloseView.layer.frame = self.topInfoCloseView.frame;

        if(self.status == RACE_CLOSED) {
            self.titleForCloseLeaderBoard.text = NSLocalizedString(@"RaceHadEndContent.title", );
        } else {
            self.titleForCloseLeaderBoard.text = NSLocalizedString(@"UserLeftRaceContent.title", );
        }
    }
    else
    {
        [self.topInfoCloseView setHidden:true];

        NSLayoutConstraint* NewTableCostraint = [NSLayoutConstraint constraintWithItem:_collectionView
                                                                             attribute:NSLayoutAttributeTop
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.view
                                                                             attribute:NSLayoutAttributeTop
                                                                            multiplier:1
                                                                              constant:0];
        [self.view addConstraint:NewTableCostraint];
        [self.view layoutIfNeeded];
    }

    [self initNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_tabbar.draggableButton removeAllAllowedDropLocations];
    for (SEDraggableLocation *location in _listDraggableLocatioinList)
    {
        [_tabbar.draggableButton addAllowedDropLocation:location];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (circularMenu != nil)
    {
        [circularMenu removeFromSuperview];
    }
    
    for (SEDraggableLocation *location in _listDraggableLocatioinList)
    {
        [_tabbar.draggableButton removeAllowedDropLocation:location];
    }
}

- (void)initNavigationBar
{
    [AppHelper setTitleViewForNavigationBar:self.navigationItem title:self.raceName];
}

- (void)draggableLocation:(SEDraggableLocation *)location didRefuseObject:(SEDraggable *)object entryMethod:(SEDraggableLocationEntryMethod)method
{
    [object setHidden:true];
    
    if (circularMenu != nil) {
        [circularMenu removeFromSuperview];
    }
    
    PhotosTaggedCollectionViewCell *cell = (PhotosTaggedCollectionViewCell *)[_collectionView cellForItemAtIndexPath:location.index];
    circularMenu = [AppHelper createCircularMenuWithFrame:cell.bounds startPoint:cell.center delegate:self];
    
    [_collectionView addSubview:circularMenu];
    [self removeThankYou];

    post_id = cell.post_id;
    giveIndex = location.index;
}

- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    [menu removeFromSuperview];
    
    if (idx < 3 && idx > -1)
    {
        int flower = 0;
        
        switch (idx) {
            case 0:
                flower = FIRST_FLOWER_BUTTON_VALUE;
                break;
            case 1:
                flower = SECOND_FLOWER_BUTTON_VALUE;
                break;
            case 2:
                flower = THIRD_FLOWER_BUTTON_VALUE;
                break;
        }
        
        [self giveFlowerPost:flower];
    }
    else
    {
        if (idx == 3)
        {
        flowerPopup = [[FlowerMenuPostPopupViewController alloc] initWithNibName:@"FlowerMenuPopUpViewController" bundle:nil];
        
        flowerPopup.postID = post_id;
        flowerPopup.parentView = self;
        flowerPopup.isFirstRank = FALSE;
        
        [flowerPopup showInView:[[[UIApplication sharedApplication] delegate] window] animated:TRUE];
        }
        else
        {
            if (idx == 4 || idx == -1)
            {
                FlowerGardenViewController *view = [[FlowerGardenViewController alloc] initWithNibName:@"FlowerGardenViewController" bundle:nil];
                view.hidesBottomBarWhenPushed = TRUE;
                
                [_tabbar snapbackFlowerIconToTabbar];
                [self.navigationController pushViewController:view animated:TRUE];
            }
        }
    }
}

- (void)giveFlowerPost:(long long)flower
{
    flower_give_post *params = [[flower_give_post alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] num_flower:flower postID:post_id];
    if (params) {
        API_Flower_GivePost *api = [[API_Flower_GivePost alloc] initWithParams:params];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            out_flower_give * data = (out_flower_give *) jsonObject;
            if (response.status)
            {
                [userDefaultManager didTutorialGiveFlowerRace:TRUE];
                [self processAfterGivingFlower:data];
                [data showFlowerGivingPopupIn:[UIApplication sharedApplication].keyWindow];
            }
            else
            {
                [AppHelper showMessageBox:nil message:response.message];
            }
        } ErrorHandlure:^(NSError *error) {
            
        }];
    }
    

}

- (void)processAfterGivingFlower:(out_flower_give *)data {
    PhotosTaggedCollectionViewCell *cell = (PhotosTaggedCollectionViewCell *)[_collectionView cellForItemAtIndexPath:giveIndex];
    
    // add thank you popup
    [cell showThankYou:YES];
    
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(removeThankYou) userInfo:nil repeats:NO];
    
    profileData = [userDefaultManager getUserProfileData];
    profileData.your_num_flower = data.mFlower;
    [userDefaultManager saveUserProfileData:profileData];
    [_tabbar updateFlowerValue];
    
    out_content_post *postData = (out_content_post*)[self.postsData objectAtIndex:giveIndex.row];
    postData.mygiveflower = data.mygiveFlower;
    postData.flower = data.flower_onpost;
    
    if (postData.mygiveflower == -1)
    {
        cell.iconGivedFlowerPhoto.hidden = true;
    }
    else
    {
        cell.iconGivedFlowerPhoto.hidden = false;
    }
    
    if (data.bonus_flower > 0)
    {
        [AppHelper showMatchingFlowerPopUp:data.bonus_flower];
    }
}

- (void)removeThankYou
{
    PhotosTaggedCollectionViewCell *cell = (PhotosTaggedCollectionViewCell *)[_collectionView cellForItemAtIndexPath:giveIndex];
    [cell showThankYou:NO];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
    
    if ([[touch view] isKindOfClass:[AwesomeMenuItem class]])
    {
        return NO;
    }
    
    if (circularMenu != nil)
    {
        [circularMenu removeFromSuperview];
    }
    
    return YES;
}


- (void)pullToRefresh
{
    if(!onProcessPull)
    {
        onProcessRefesh = true;
        postID = @"";
        loaded = FALSE;
        self.loadedPostCount = 0;
        
        [self loadGallery];
    }
    [_collectionView.pullToRefreshView stopAnimating];
    [_collectionView setShowsInfiniteScrolling:YES];
}

- (void)infiniteScrolling
{
    if(!onProcessRefesh)
    {
        onProcessPull = true;
        if (images.count != 0)
        {
            postID = [(gallery *)([images objectAtIndex:images.count - 1]) post_id];
        }
        else
        {
            postID = @"";
        }
        
        [self loadGallery];
    }
    [_collectionView.infiniteScrollingView stopAnimating];
}

- (void)loadGallery
{
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
    API_Profile_Post_GalleryFetches *API = [[API_Profile_Post_GalleryFetches alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] key:_key uid:_uid post_id:postID limit:LOAD_GALLERY_MAX_LIMIT];
    [API request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        JSON_GalleryFetches *data = (JSON_GalleryFetches *)jsonObject;
        if (response.status)
        {
            if([postID isEqualToString:@""]) {
                [self.postsData removeAllObjects];
            }
            numData = data.galleryList.count;
            if(data.galleryList.count == 0)
            {
                onProcessRefesh = FALSE;
                onProcessPull = FALSE;
                [_collectionView setShowsInfiniteScrolling:NO];
            }
            for (NSInteger i = 0; i < data.galleryList.count; i++)
            {
                curData = i;
                gallery *galleryData = (gallery*)[data.galleryList objectAtIndex:i];
                out_content_post *postData = [[out_content_post alloc] init];
                [self.postsData addObject:postData];
                [self loadContentPostWithPostID:galleryData.post_id];
            }
            
            if (!loaded)
            {
                images = [data galleryList];
                loaded = TRUE;
            }
            else
            {
                if ([data galleryList].count != 0)
                {
                    [images addObjectsFromArray:[data galleryList]];
                }
            }
        }
        else
        {
            [AppHelper showMessageBox:nil message:response.message];
        }
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    } ErrorHandlure:^(NSError *error) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];

}

- (void)loadContentPostWithPostID:(NSString*)postid
{
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
    API_Content_Post_Fetches *api = [[API_Content_Post_Fetches alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] post_id:postid];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        out_content_post * data = (out_content_post *) jsonObject;
        if (response.status)
        {
            for (NSInteger i = 0; i < images.count; i++)
            {
                gallery *galleryData = (gallery*)[images objectAtIndex:i];
                
                if ([data.post_id isEqualToString:galleryData.post_id])
                {
                    [self.postsData replaceObjectAtIndex:i withObject:data];
                    
                    break;
                }
            }
            
            self.loadedPostCount += 1;
            
            if (self.loadedPostCount == images.count)
            {
                [self.collectionView reloadData];
            }
            
            if(curData == (numData-1))
            {
                onProcessRefesh = FALSE;
                onProcessPull = FALSE;
            }
        }
        else{
            [AppHelper showMessageBox:nil message:response.message];
        }
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    } ErrorHandlure:^(NSError *error) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];
}

- (void)deletePhotoAtIndex:(NSInteger)index{
    [images removeObjectAtIndex:index];
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return images.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    return CGSizeMake(screenSize.width / 2 - 2.5, screenSize.width / 2 - 2.5);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"PhotosTagged";
    
    UINib *nib = [UINib nibWithNibName:@"PhotosTaggedCollectionViewCell" bundle: nil];
    [collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
    
    PhotosTaggedCollectionViewCell *cell = (PhotosTaggedCollectionViewCell *)[_collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    gallery *temp = (gallery *)[images objectAtIndex:indexPath.row];
    out_content_post *postData = (out_content_post*)[self.postsData objectAtIndex:indexPath.row];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:postData.photo_url]];
    [cell.photo setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"Banners_mockup.png"]
                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                   cell.photo.image = image;
                               } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                   
                               }];
    cell.navigationController = self.navigationController;
    cell.post_id = temp.post_id;
    
    if (postData.mygiveflower == -1)
    {
        cell.iconGivedFlowerPhoto.hidden = true;
    }
    else
    {
        cell.iconGivedFlowerPhoto.hidden = false;
    }
    
    [AppHelper configureDraggableLocation:cell.draggableLocation objectSize:_tabbar.draggableButton.frame.size isCircle:false hightlight:false highlightColor:nil];
    cell.draggableLocation.delegate = self;
    cell.draggableLocation.index = indexPath;
    [_tabbar.draggableButton addAllowedDropLocation:cell.draggableLocation];
    [_listDraggableLocatioinList addObject:cell.draggableLocation];
    
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoListViewController *viewController = [[PhotoListViewController alloc] initWithNibName:@"PhotoListViewController" bundle:nil];
    
    viewController.postsData = self.postsData;
    viewController.raceName = self.raceName;
    viewController.currentIndexPath = indexPath;
    viewController.parentView = self;
//    viewController.raceKey = _key;
    
    if (profileData.uid == self.uid)
    {
        viewController.hidesBottomBarWhenPushed = true;
    }
    else
    {
        viewController.hidesBottomBarWhenPushed = false;
    }
    
    [self.navigationController pushViewController:viewController animated:true];  
}

#pragma mark - Action Functions

- (void)touchUploadButton {
    imagePickerPopup = [[ImagePickerPopUpViewController alloc] initWithNibName:@"ImagePickerPopUpViewController" bundle:nil];
    imagePickerPopup.parentView = self;
    imagePickerPopup.tag = _key;
    imagePickerPopup.raceName = _raceName;
    imagePickerPopup.isUploadAvatar = false;
    imagePickerPopup.view.frame = [UIScreen mainScreen].bounds; // Get device's bounds
    [imagePickerPopup showInView:[[[UIApplication sharedApplication] delegate] window] animated:TRUE];
}

@end
