//
//  PhotosTaggedInRacesViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 2/19/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "FlowerGardenViewController.h"
#import "PhotosTaggedInRacesViewController.h"
#import "RaceInfoPopUpView.h"
#import "AppHelper.h"

#define THUMBHEIGHT 108
#define OBJECT_WIDTH 80.0f
#define OBJECT_HEIGHT 80.0f
#define MARGIN_VERTICAL 0.0f
#define MARGIN_HORIZONTAL 0.0f
#define DRAGGABLE_LOCATION_WIDTH  ((OBJECT_WIDTH  * 3) + (MARGIN_HORIZONTAL * 5))
#define DRAGGABLE_LOCATION_HEIGHT ((OBJECT_HEIGHT * 3) + (MARGIN_VERTICAL   * 5))

static NSString * const PhotoCellIdentifier = @"PhotoCell";

@interface PhotosTaggedInRacesViewController () {
    MenuRacePopupController *popup;
    UserDefaultManager *userDefaultManager;
    NSMutableArray *galleryList;
    NSString *postID;
    BOOL loaded;
    out_profile_fetch *profileData;
    NSIndexPath *giveIndex;
    NSTimer *timer;
    FlowerMenuPostPopupViewController *flowerPopup;
}

@end

@implementation PhotosTaggedInRacesViewController

@synthesize circularMenu;//, flowerPopup;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:FALSE];
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    profileData = [userDefaultManager getUserProfileData];
    _listDraggableLocatioinList = [[NSMutableArray alloc] init];
    galleryList = [[NSMutableArray alloc] init];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _tabbar = appDelegate.tabbar;
    postID = @"";
    loaded = false;
    [self loadGallery];
    
    __weak PhotosTaggedInRacesViewController *weakSelf = self;
    [_collectionView addPullToRefreshWithActionHandler:^{
        PhotosTaggedInRacesViewController *strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf pullToRefresh];
        }
    }];
    
    [self.emptyScrollView addPullToRefreshWithActionHandler:^{
        PhotosTaggedInRacesViewController *strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf pullToRefresh];
        }
    }];
    
    [_collectionView addInfiniteScrollingWithActionHandler:^{
        [weakSelf infiniteScrolling];
    }];
    
    [self setHeaderView];
    [self setupEmptyDataView];
    
    [_bothGendersButton setTitle:NSLocalizedString(@"SHOW BOTH\nGENDERS", nil)  forState: UIControlStateNormal];
    _bothGendersButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _bothGendersButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_femaleButton setTitle:NSLocalizedString(@"SHOW FEMALE\nPICTURES",nil) forState: UIControlStateNormal];
    _femaleButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _femaleButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_maleButton setTitle:NSLocalizedString(@"SHOW MALE\nPICTURES",nil) forState: UIControlStateNormal];
    _maleButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _maleButton.titleLabel.textAlignment = NSTextAlignmentCenter;
//    _gender = BOTH_FEMALE_MALE;
    [self updateSelectedGenderView];

    [self initNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadGallery {
    postID = @"";
    loaded = false;
    
    [self loadGallery];
}

- (void)pullToRefresh {
    postID = @"";
    loaded = false;
    
    [self loadGallery];
    [self.collectionView.pullToRefreshView stopAnimating];
    [self.emptyScrollView.pullToRefreshView stopAnimating];
}

- (void)infiniteScrolling {
    if (galleryList.count != 0) {
        postID = [(gallery *)([galleryList objectAtIndex:galleryList.count - 1]) post_id];
    } else {
        postID = @"";
    }
    
    [self loadGallery];
    [_collectionView.infiniteScrollingView stopAnimating];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_tabbar updateFlowerValue];
}

- (void)setHeaderView {
    /*
    _collectionView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
    _genderView.frame = CGRectMake(0, -40, 320, 40);
    [_collectionView addSubview: _genderView];
     */
}

- (void)loadGallery {
                [self.collectionView reloadData];
    [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner startAnimating];
    API_Races_GalleryFetches *api = [[API_Races_GalleryFetches alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                                             device_token:[userDefaultManager getDeviceToken]
                                                                                      key:_key gender:_gender post_id:postID
                                                                                    limit:LOAD_GALLERY_MAX_LIMIT];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        if (response.status) {
            JSON_GalleryFetches *data = (JSON_GalleryFetches *)jsonObject;
            if (!loaded) {
                galleryList = data.galleryList;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                if([_collectionView.visibleCells count] > 0)
                    //                    [_collectionView reloadItemsAtIndexPaths:[_collectionView indexPathsForVisibleItems]];
                    //                else
                    [_collectionView reloadData];
                    [self.collectionView layoutIfNeeded];
                });
                
                loaded = true;
            } else {
                if (data.galleryList.count != 0) {
                    [galleryList addObjectsFromArray:data.galleryList];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //                    if([_collectionView.visibleCells count] > 0)
                        //                        [_collectionView reloadItemsAtIndexPaths:[_collectionView indexPathsForVisibleItems]];
                        //                    else
                        [_collectionView reloadData];
                        [self.collectionView layoutIfNeeded];
                    });
                }
            }
            [self setHeaderView];
        } else {
            [AppHelper showMessageBox:nil message:response.message];
        }
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        
    } ErrorHandlure:^(NSError *error) {
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];
}

- (void)initNavigationBar {
    
    if([_parentView isKindOfClass:[RacesViewController class]])
    {
        UILabel *titleView;
        
        if([_raceDate isEqualToString:@""])
        {
            titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 9, 200, 19)];
        }
        else
        {
            titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 200, 19)];
        }
        
        titleView.textAlignment = NSTextAlignmentLeft;
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:16];
        titleView.textColor = [UIColor whiteColor];
        titleView.text = _raceName;
        
        UILabel *dateView = [[UILabel alloc] initWithFrame:CGRectMake(0, 21, 250, 13)];
        dateView.textAlignment = NSTextAlignmentLeft;
        dateView.backgroundColor = [UIColor clearColor];
        dateView.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:11];
        dateView.textColor = [UIColor whiteColor];
        dateView.text = _raceDate;
        
        UIView *title = [[UIView alloc] initWithFrame:CGRectMake(60, 20, 200, 35)];
        
        [title addSubview:titleView];
        [title addSubview:dateView];
        
        UIBarButtonItem *leftTitle = [[UIBarButtonItem alloc] initWithCustomView:title];
        
        self.navigationItem.leftItemsSupplementBackButton = true;
        [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects: leftTitle, nil]];
        
        [title sizeToFit];
    }
    else
    {
        UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 150, 19)];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.textAlignment = NSTextAlignmentCenter;
        titleView.font = [UIFont fontWithName:NAVIGATION_TITLE_FONT_NAME size:16];
        titleView.textColor = [UIColor whiteColor];
        titleView.text = _raceName;
        
        UILabel *dateView = [[UILabel alloc] initWithFrame:CGRectMake(-3, 21, 150, 13)];
        dateView.backgroundColor = [UIColor clearColor];
        dateView.textAlignment = NSTextAlignmentCenter;
        dateView.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:11];
        dateView.textColor = [UIColor whiteColor];
        //    dateView.text = @"4th January 2018";
        dateView.text = _raceDate;
        
        UIView *title = [[UIView alloc] initWithFrame:CGRectMake(60, 20, 150, 35)];
        [title addSubview:titleView];
        [title addSubview:dateView];
        
        self.navigationItem.titleView = title;
        [title sizeToFit];
    }
    
    if ([self.parentView isKindOfClass:[RacesViewController class]]) {
        NSArray *rightBarButtonArray = [[NSArray alloc] init];
//        UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Icon_Leaderboard_More"] style:UIBarButtonItemStylePlain target:self action:@selector(touchInfoButton)];
        UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [infoButton setImage:[UIImage imageNamed:@"Icon_Leaderboard_More"] forState:UIControlStateNormal];
        infoButton.frame = CGRectMake(0, 0, 22, 22);
        [infoButton addTarget:self action:@selector(touchInfoButton) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *infoButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
        rightBarButtonArray = [rightBarButtonArray arrayByAddingObject:infoButtonItem];
        
        if ((self.gender == [userDefaultManager getUserProfileData].gender || self.gender == 2)
            && ((self.categoryType != RACECATEGORY_LOCATION && self.categoryType != RACECATEGORY_EVENT) || (self.joinState == RACE_JOINED && !_isComingSoon))) {
            UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [cameraButton setImage:[[UIImage imageNamed:@"Icon_Camera_White"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                          forState:UIControlStateNormal];
            [cameraButton addTarget:self action:@selector(touchButtonCamera) forControlEvents:UIControlEventTouchUpInside];
            cameraButton.frame = CGRectMake(0, 0, 32, 22);
            UIBarButtonItem *cameraButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cameraButton];
            
            rightBarButtonArray = [rightBarButtonArray arrayByAddingObject:cameraButtonItem];
        }
        [self.navigationItem setRightBarButtonItems:rightBarButtonArray];
    }
}

- (void)touchButtonCamera {
    RacesViewController *view = (RacesViewController*)self.parentView;
    [view touchButtonCamera];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_tabbar.draggableButton removeAllAllowedDropLocations ];
    for (SEDraggableLocation *location in _listDraggableLocatioinList)
    {
        [_tabbar.draggableButton addAllowedDropLocation:location];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (circularMenu != nil) {
        [circularMenu removeFromSuperview];
    }
    for (SEDraggableLocation *location in _listDraggableLocatioinList)
    {
        [_tabbar.draggableButton removeAllowedDropLocation:location];
    }
}

- (void)touchInfoButton {
//    popup = [[MenuRacePopupController alloc] initWithNibName:@"MenuRacePopupController" bundle:nil];
//    popup.parentView = self.parentView;
//    [popup showInView:[[[UIApplication sharedApplication] delegate] window] animated:TRUE];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"LeaderBoardInfo.tittle", ) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        RacesViewController *view = (RacesViewController*)self.parentView;
        
        RaceInfoPopupView *popup = [RaceInfoPopupView createInView:UIApplication.sharedApplication.delegate.window raceContent:view.raceInfo raceName:view.categoryType > RACECATEGORY_LOCATION ? @"" : self.raceName endTime:@""];
        [popup showWithAnimated:true];
    }]];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"CancelPopupRace.title", ) style:UIAlertActionStyleCancel handler:nil];
    [cancelAction setValue:UIColorFromRGB(0x0076FF) forKey:@"titleTextColor"];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
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
    postID = cell.post_id;
    [self removeThankYou];
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
        
        [self giveFlower:flower];
    }
    else
    {
        if (idx == 3)
        {
            flowerPopup = [[FlowerMenuPostPopupViewController alloc] initWithNibName:@"FlowerMenuPopUpViewController" bundle:nil];
            
            flowerPopup.postID = postID;
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

- (void)giveFlower:(long long)flower {
    flower_give_post *params = [[flower_give_post alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] num_flower:flower postID:postID];
    if (params) {
        API_Flower_GivePost *api = [[API_Flower_GivePost alloc] initWithParams:params];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            out_flower_give * data = (out_flower_give *) jsonObject;
            if (response.status) {
                [userDefaultManager didTutorialGiveFlowerRace:TRUE];
                [self processAfterGivingFlower:data];
                [data showFlowerGivingPopupIn:[UIApplication sharedApplication].keyWindow];
            } else {
                [AppHelper showMessageBox:nil message:response.message];
            }
        } ErrorHandlure:^(NSError *error) {
            
        }];
    }
}

- (void)processAfterGivingFlower:(out_flower_give *)data {
    PhotosTaggedCollectionViewCell *cell = (PhotosTaggedCollectionViewCell *)[_collectionView cellForItemAtIndexPath:giveIndex];
    [cell.thankyouView setHidden:FALSE];
    
    if (data.mygiveFlower > 0) {
        gallery * item = [galleryList objectAtIndex:giveIndex.row];
        item.mygiveflower = data.mygiveFlower;
        [cell.iconGivedFlowerPhoto setHidden:NO];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(removeThankYou) userInfo:nil repeats:NO];
    
    profileData = [userDefaultManager getUserProfileData];
    profileData.your_num_flower = data.mFlower;
    [userDefaultManager saveUserProfileData:profileData];
    [_tabbar updateFlowerValue];
    
    if (data.bonus_flower > 0)
    {
        [AppHelper showMatchingFlowerPopUp:data.bonus_flower];
    }
}

- (void)removeThankYou {
    PhotosTaggedCollectionViewCell *cell = (PhotosTaggedCollectionViewCell *)[_collectionView cellForItemAtIndexPath:giveIndex];
    [cell.thankyouView setHidden:TRUE];
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

- (void)clearDraggableLocationList
{
    if (_listDraggableLocatioinList.count != 0)
    {
        for (int i = 0; i < _listDraggableLocatioinList.count; i++)
        {
            [_tabbar.draggableButton removeAllowedDropLocation:[_listDraggableLocatioinList objectAtIndex:i]];
        }
    }
}

- (void)setupEmptyDataView {
    NSString *emptyDataTxtValue = NSLocalizedString(@"PhotosTaggedInRaces.NoPhotos",);
    self.emptyTextField.text = emptyDataTxtValue;
    [self.emptyTextField setTextColor:[UIColor rgb:188 green:189 blue:190]];
    self.emptyTextField.font = [UIFont fontWithName:@"SFUIDisplay-Semibold" size:14];
    [self.emptyImageView setImage:[UIImage imageNamed:@"Icon_No_Photos"]];
}

// MARK: Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return galleryList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    return CGSizeMake(screenSize.width / 2 - 2.5, screenSize.width / 2 - 2.5);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    @autoreleasepool {
        NSString *identifier = @"PhotosTagged";
        
        UINib *nib = [UINib nibWithNibName:@"PhotosTaggedCollectionViewCell" bundle: nil];
        [collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
        
        PhotosTaggedCollectionViewCell *cell = (PhotosTaggedCollectionViewCell *)[_collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        if(cell == nil)
        {
            
        }
        
        gallery *temp = (gallery *)[galleryList objectAtIndex:indexPath.row];
        [cell.photo setImageWithURL:[NSURL URLWithString:temp.photo_url]];
        cell.post_id = temp.post_id;
        if (temp.mygiveflower > 0)
        {
            cell.iconGivedFlowerPhoto.hidden = false;
        }
        else
        {
            cell.iconGivedFlowerPhoto.hidden = true;
        }
        
        cell.navigationController = self.navigationController;
        [AppHelper configureDraggableLocation:cell.draggableLocation objectSize:_tabbar.draggableButton.frame.size isCircle:false hightlight:false highlightColor:nil];
        cell.draggableLocation.delegate = self;
        cell.draggableLocation.index = indexPath;
        [_tabbar.draggableButton addAllowedDropLocation:cell.draggableLocation];
        [_listDraggableLocatioinList addObject:cell.draggableLocation];
        
        return cell;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FullPictureViewController *view = [[FullPictureViewController alloc] initWithNibName:@"FullPictureViewController" bundle:nil];
    
    gallery *temp = (gallery *)[galleryList objectAtIndex:indexPath.row];
    view.isScrollingEnabled = FALSE;
    view.post_id = temp.post_id;
    view.galleryData = galleryList;
    view.currentIndex = indexPath.row;
    view.raceName = self.raceName;
    view.parentView = self;
    
    [self.navigationController pushViewController:view animated:TRUE];

}

- (IBAction)touchBothGenders:(id)sender {
    _gender = BOTH_FEMALE_MALE;
    postID = @"";
    loaded = FALSE;
    
    [self updateSelectedGenderView];
    [self loadGallery];
}

- (IBAction)touchFemale:(id)sender {
    _gender = FEMALE;
    postID = @"";
    loaded = FALSE;
    [self updateSelectedGenderView];
    [self loadGallery];
}

- (IBAction)touchMale:(id)sender {
    _gender = MALE;
    postID = @"";
    loaded = FALSE;
    [self updateSelectedGenderView];
    [self loadGallery];
}

- (void)updateSelectedGenderView {
    switch (_gender) {
        case FEMALE:
        {
            [_bothGendersButton setEnabled:TRUE];
            _bothGendersButton.titleLabel.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:11];
            [_femaleButton setEnabled:FALSE];
            _femaleButton.titleLabel.font = [UIFont fontWithName:@"SFUIDisplay-Semibold" size:11];
            [_maleButton setEnabled:TRUE];
            _maleButton.titleLabel.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:11];
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                [_selectedLine setFrame:CGRectMake(_femaleButton.frame.origin.x + (_femaleButton.frame.size.width - _selectedLine.frame.size.width)/2, _selectedLine.frame.origin.y, _selectedLine.frame.size.width, _selectedLine.frame.size.height)];
            } completion:^(BOOL finished) {
                
            }];
        }
            break;
        case MALE:
        {
            [_bothGendersButton setEnabled:TRUE];
            _bothGendersButton.titleLabel.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:11];
            [_femaleButton setEnabled:TRUE];
            _femaleButton.titleLabel.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:11];
            [_maleButton setEnabled:FALSE];
            _maleButton.titleLabel.font = [UIFont fontWithName:@"SFUIDisplay-Semibold" size:11];
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                [_selectedLine setFrame:CGRectMake(_maleButton.frame.origin.x + (_maleButton.frame.size.width - _selectedLine.frame.size.width)/2, _selectedLine.frame.origin.y, _selectedLine.frame.size.width, _selectedLine.frame.size.height)];
            } completion:^(BOOL finished) {
                
            }];
        }
            break;
        case BOTH_FEMALE_MALE:
        {
            [_bothGendersButton setEnabled:FALSE];
            _bothGendersButton.titleLabel.font = [UIFont fontWithName:@"SFUIDisplay-Semibold" size:11];
            [_femaleButton setEnabled:TRUE];
            _femaleButton.titleLabel.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:11];
            [_maleButton setEnabled:TRUE];
            _maleButton.titleLabel.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:11];
            [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                [_selectedLine setFrame:CGRectMake(_bothGendersButton.frame.origin.x + (_bothGendersButton.frame.size.width - _selectedLine.frame.size.width)/2, _selectedLine.frame.origin.y, _selectedLine.frame.size.width, _selectedLine.frame.size.height)];
            } completion:^(BOOL finished) {
                
            }];
            
        }
            break;
            
        default:
            break;
    }
}

- (void)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
