//
//  DiscoveryViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 1/19/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "DiscoveryViewController.h"
#import "DiscoveryPopupViewController.h"
#import "AppDelegate.h"
#import "UISearchBar+Extension.h"

#define OBJECT_WIDTH 80.0f
#define OBJECT_HEIGHT 80.0f
#define MARGIN_VERTICAL 0.0f
#define MARGIN_HORIZONTAL 0.0f
#define DRAGGABLE_LOCATION_WIDTH  ((OBJECT_WIDTH  * 3) + (MARGIN_HORIZONTAL * 5))
#define DRAGGABLE_LOCATION_HEIGHT ((OBJECT_HEIGHT * 3) + (MARGIN_VERTICAL   * 5))

@interface DiscoveryViewController () {
    DiscoveryPopupViewController *popup;
    CGFloat previousContentOffset;
    UserDefaultManager *userDefaultManager;
    NSMutableArray *discoveryList;
    
    NSInteger lastUserID;
    BOOL didReload;
    BOOL giveProfile;
    NSString *postID;
    NSInteger model;
    FlowerMenuPostPopupViewController *flowerPopup;
    
    ThankYou * thankyouPopup;
    NSTimer *thankyouTimer;
    NSIndexPath *giveIndex;
    
    BOOL isSearching;
    NSMutableArray *searchResult;
    
    BOOL isLoading;
    SEDraggableLocation* receivedLocation;
    
    BOOL shouldBeginCalledBeforeHand;
    CGRect frameSearchView;
    
    NSInteger currentSearchPage;
    CGFloat tableViewHeight;
    FilterCustomView * filterMenu;
    UIView * backgroundSearchView;
    NSTimer* searchTimer;
}

@end

@implementation DiscoveryViewController

@synthesize profileData, gender, filterCity, isRefresh, userID, loadedItemIndex, circularMenu, postsPerUserID, searchResultTableView;//, flowerPopup;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    userDefaultManager = [[UserDefaultManager alloc] init];
    profileData = [userDefaultManager getUserProfileData];
    discoveryList = [[NSMutableArray alloc] init];
    _listDraggableLocationTop = [[NSMutableArray alloc] init];
    postsPerUserID = [[NSMutableDictionary alloc] init];
    
    didReload = FALSE;
    isRefresh = TRUE;
    
    userID = -1;
    lastUserID = -1;
    loadedItemIndex = 0;
    currentSearchPage = 0;
    tableViewHeight = [UIScreen mainScreen].bounds.size.height - self.navigationController.navigationBar.frame.size.height - 20 - self.tabBarController.tabBar.frame.size.height - self.searchBar.frame.size.height;
    
    __weak DiscoveryViewController *weakSelf = self;
    [_tableView addPullToRefreshWithActionHandler:^{
        if (weakSelf)
        {
            __strong DiscoveryViewController *strongSelf = weakSelf;
            [strongSelf pullToRefresh];
        }
    }];
    
    [_tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf infiniteScrolling];
    }];
    
    [self.searchResultTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMoreSearch];
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:[SinglePhotoCell nibName] bundle:nil] forCellReuseIdentifier:[SinglePhotoCell cellIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[TwoPhotosCell nibName] bundle:nil] forCellReuseIdentifier:[TwoPhotosCell cellIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[ThreePhotosCell nibName] bundle:nil] forCellReuseIdentifier:[ThreePhotosCell cellIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[FourPhotosCell nibName] bundle:nil] forCellReuseIdentifier:[FourPhotosCell cellIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[FivePhotosCell nibName] bundle:nil] forCellReuseIdentifier:[FivePhotosCell cellIdentifier]];
    
    [self.searchResultTableView registerNib:[UINib nibWithNibName:@"RacesSearchTableViewCell" bundle:nil] forCellReuseIdentifier:[RacesSearchTableViewCell cellIdentifier]];
    
//    [self.searchResultTableView registerNib:[UINib nibWithNibName:[SinglePhotoCell nibName] bundle:nil] forCellReuseIdentifier:[SinglePhotoCell cellIdentifier]];
//    [self.searchResultTableView registerNib:[UINib nibWithNibName:[TwoPhotosCell nibName] bundle:nil] forCellReuseIdentifier:[TwoPhotosCell cellIdentifier]];
//    [self.searchResultTableView registerNib:[UINib nibWithNibName:[ThreePhotosCell nibName] bundle:nil] forCellReuseIdentifier:[ThreePhotosCell cellIdentifier]];
//    [self.searchResultTableView registerNib:[UINib nibWithNibName:[FourPhotosCell nibName] bundle:nil] forCellReuseIdentifier:[FourPhotosCell cellIdentifier]];
//    [self.searchResultTableView registerNib:[UINib nibWithNibName:[FivePhotosCell nibName] bundle:nil] forCellReuseIdentifier:[FivePhotosCell cellIdentifier]];
    
    [searchResultTableView setHidden:true];
    searchResultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.searchBar setupSearchBar];
    [self.searchBar customizeDefaultRoundSearchBar];
    
    [self initNavigationBar];
    
    gender = 0;
    [self loadDiscoveryWithGender:gender];
    
    [self fetchFlowerGivingPopup];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(blockProfile:) name:[NotificationNames UidProfileLock] object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [_tabbar updateFlowerValue];
    
    [_tabbar.draggableButton removeAllAllowedDropLocations];
    for (SEDraggableLocation *location in self.listDraggableLocationTop)
    {
        [_tabbar.draggableButton addAllowedDropLocation:location];
    }
    
    [_tableView reloadData];
    if (_showPopup) {
        [self touchTitle];
    }
    
//    if([userDefaultManager isReloadDiscovery] == TRUE)
//    {
//        [self pullToRefresh];
//        [userDefaultManager setReloadDiscovery:FALSE];
//    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    if (circularMenu != nil) {
        [circularMenu removeFromSuperview];
    }
    
    for (SEDraggableLocation *location in self.listDraggableLocationTop)
    {
        [_tabbar.draggableButton removeAllowedDropLocation:location];
    }
    
    [filterMenu handleDismiss];
}

- (void)initNavigationBar
{
    [AppHelper setTitleViewForNavigationBar:self.navigationItem title:NSLocalizedString(@"Discovery", "")];
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_filter"] style:UIBarButtonItemStyleDone target:self action:@selector(handleFilter)];
}

- (void)touchTitle {
    popup = [[DiscoveryPopupViewController alloc] initWithNibName:@"DiscoveryPopupViewController" bundle:nil];
    popup.parentView = self;
    
    popup.view.frame = [UIScreen mainScreen].bounds; // Get device's bounds
    [popup showInView:[[[UIApplication sharedApplication] delegate] window] animated:TRUE];
}

- (void)blockProfile: (NSNotification*)notification {
    NSInteger uid = [[[notification userInfo] objectForKey:[NotificationKey UidProfile]] integerValue];
    if (discoveryList.count != 0) {
        BOOL isReload = FALSE;
        for (int i = 0; i < [discoveryList count]; i ++) {
            DiscoveryModel *temp = (DiscoveryModel *)[discoveryList objectAtIndex:i];
                if (uid == temp.uid) {
                    [discoveryList removeObject:temp];
                    isReload = TRUE;
                    i --;
                }
        }
        
        if (isReload) {
            [self.tableView reloadData];
        }
        
        if (discoveryList.count == 0) {
             [self infiniteScrolling];
        }
    }
}

- (void)pullToRefresh {
    isRefresh = TRUE;
    userID = 0;
    loadedItemIndex = 0;
    lastUserID = -1;
    isLoading = FALSE;
    
    [postsPerUserID removeAllObjects];
    
    [self loadDiscoveryWithGender:gender];
    
    [_tableView.pullToRefreshView stopAnimating];
}

- (void)infiniteScrolling
{
    if (discoveryList.count != 0)
    {
        userID = [(DiscoveryModel *)([discoveryList objectAtIndex:discoveryList.count - 1]) uid];
    }
    else{
        userID = 0;
    }
    
    [self loadDiscoveryWithGender:gender];

//    if (userID != lastUserID)
//    {
//        [self loadDiscoveryWithGender:gender];
//        lastUserID = userID;
//    }
}

- (void)loadMoreSearch
{
    currentSearchPage += 1;
    
    [self searchAll:self.searchBar.text page:currentSearchPage];
    [self.searchResultTableView.infiniteScrollingView stopAnimating];
}

- (void)saveFilterOptions {
    [userDefaultManager saveDiscoveryOptions:gender location:filterCity];
}

- (void)loadCityList {
    API_LoadLocation *API = [[API_LoadLocation alloc] init];
    __weak typeof(self) weakSelf = self;
    [API request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        out_location_load *data = (out_location_load *)jsonObject;
        if (response.status) {
            if (weakSelf) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                strongSelf.cityList = data.citys;
//                [strongSelf loadDiscoveryOptions];
            }
        } else {
            [AppHelper showMessageBox:nil message:response.message];
        }
    } ErrorHandlure:^(NSError *error) {
        
    }];

}

- (void)loadDiscoveryWithGender:(NSInteger) gender {
    if (isLoading) {
        return;
    }
    isLoading = TRUE;
    
    API_DiscoveryFetches *request = [[API_DiscoveryFetches alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                                           device_token:[userDefaultManager getDeviceToken]
                                                                                 gender:gender
                                                                             is_refresh:isRefresh
                                                                                    uid:userID];
    __weak typeof(self) weakSelf = self;
    [request getRequest:^(BaseJSON *json, RestfulResponse *data) {
        if (weakSelf) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [_tableView.infiniteScrollingView stopAnimating];
            if (data.status) {
                if (isRefresh) {
                    [discoveryList removeAllObjects];
                    [strongSelf.tableView reloadData];
                }
                isLoading = FALSE;
                isRefresh = FALSE;
                JSON_DiscoveryFetches *model = (JSON_DiscoveryFetches *)json;
                
                if (loadedItemIndex == 0) {

                    [model.discoveryList enumerateObjectsUsingBlock:^(DiscoveryModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [strongSelf.tableView beginUpdates];
                        [discoveryList addObject:obj];
                        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                        [strongSelf.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        [strongSelf.tableView endUpdates];
                    }];
                    [strongSelf.tableView scrollsToTop];
                    loadedItemIndex = discoveryList.count;
                } else {
                    if (model.discoveryList.count != 0) {
                        [model.discoveryList enumerateObjectsUsingBlock:^(DiscoveryModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            [strongSelf.tableView beginUpdates];
                            [discoveryList addObject:obj];
                            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:discoveryList.count-1 inSection:0];
                            [strongSelf.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
                            [strongSelf.tableView endUpdates];
                        }];

                        loadedItemIndex = discoveryList.count;
                    }
                }
            } else {
                
                [AppHelper showMessageBox:nil message:data.message];
            }
        }
        
    } ErrorHandlure:^(NSError *error) {
        NSLog(@"Discovery Fetches RequestFailed");
    }];
}

- (void) fetchFlowerGivingPopup{
    API_FlowerGivingPopup * api = [[API_FlowerGivingPopup alloc] initWithAccessToken:[userDefaultManager getAccessToken] DeviceToken:[userDefaultManager getDeviceToken]];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        
        if (response.status) {
            JSON_FlowerGivingPopup * data = (JSON_FlowerGivingPopup *) jsonObject;
            if (data.type == 4) {
                [DailyFlowerGivingPopUp createDoubleViewInView:[[UIApplication sharedApplication] keyWindow]];
            }else if (data.type == 5){
                [DailyFlowerGivingPopUp createMissViewInView:[[UIApplication sharedApplication] keyWindow]];
            }
        }else{
            [AppHelper showMessageBox:nil message:response.message];
        }
    } ErrorHandlure:^(NSError *error) {
        
    }];
}


- (void) invalidateSearchTimer {
    if (searchTimer != nil) {
        [searchTimer invalidate];
        searchTimer = nil;
    }
}

-(void) filterUser {
    if (self.searchBar.text.length > 0) {
        [self searchAll:self.searchBar.text page:currentSearchPage];
    }
}

#pragma mark - Giving Flower
- (void)draggableLocation:(SEDraggableLocation *)location didRefuseObject:(SEDraggable *)object entryMethod:(SEDraggableLocationEntryMethod)method
{
    receivedLocation = nil;
    
    [object setHidden:true];
    
    if (circularMenu != nil) {
        [circularMenu removeFromSuperview];
    }
    
    receivedLocation = location;
    
    DiscoveryModel *discoveryItem = (DiscoveryModel *)[discoveryList objectAtIndex:location.index.row];
    UITableView *tableView = self.tableView;
    
    if (discoveryItem.totalPost == 1)
    {
        SinglePhotoCell *cell = (SinglePhotoCell *)[tableView cellForRowAtIndexPath:location.index];
        
        if (cell == nil)
        {
            return;
        }
        
        if (location == cell.draggableLocation)
        {
            circularMenu = [self createCircularMenuWithFrame:cell.pictureView.bounds];
            circularMenu.startPoint = CGPointMake(cell.frame.origin.x + cell.pictureView.center.x, cell.frame.origin.y + cell.pictureView.center.y);
            circularMenu.delegate = self;
            circularMenu.menuWholeAngle = 2.5f;
            circularMenu.rotateAngle = 5.04f;
            circularMenu.farRadius = 60.0f;
            circularMenu.endRadius = 50.0f;
            circularMenu.nearRadius = 40.0f;
            circularMenu.animationDuration = 0.7f;
            [circularMenu setExpanding:YES];
            
            [tableView addSubview:circularMenu];
            
            postID = cell.post_id;
            giveProfile = FALSE;
            receivedLocation = location;
        }
        else
        {
            circularMenu = [self createCircularCellMenuWithFrame:cell.infoView.bounds];
//            circularMenu.startPoint = CGPointMake(cell.frame.origin.x + 175, cell.frame.origin.y + 69);
            circularMenu.startPoint = CGPointMake((cell.bounds.size.width - circularMenu.menusArray.count * 25) - 15, cell.frame.origin.y + 69);
            
            circularMenu.delegate = self;
            circularMenu.menuWholeAngle = 0;
            circularMenu.rotateAngle = 0;
            circularMenu.farRadius = 60.0f;
            circularMenu.endRadius = 50.0;
            circularMenu.nearRadius = 40.0f;
            circularMenu.animationDuration = 0.7f;
            [circularMenu setExpanding:YES];
            
            [tableView addSubview:circularMenu];
            model = cell.uid;
            giveProfile = TRUE;
        }
        
        return;
    }
    
    if (discoveryItem.totalPost == 2)
    {
        TwoPhotosCell *cell = (TwoPhotosCell *)[tableView cellForRowAtIndexPath:location.index];
        
        if (cell == nil)
        {
            return;
        }
        
        if (location == cell.topDraggableLocation)
        {
            circularMenu = [self createCircularCellMenuWithFrame:cell.infoView.bounds];
            circularMenu.startPoint = CGPointMake(cell.frame.origin.x + 175, cell.frame.origin.y + 69);
            circularMenu.delegate = self;
            circularMenu.menuWholeAngle = 0;
            circularMenu.rotateAngle = 0;
            circularMenu.farRadius = 60.0f;
            circularMenu.endRadius = 50.0;
            circularMenu.nearRadius = 40.0f;
            circularMenu.animationDuration = 0.7f;
            [circularMenu setExpanding:YES];
            
            [tableView addSubview:circularMenu];
            model = cell.uid;
            giveProfile = TRUE;
        }
        else
        {
            UIView *pictureView = [cell.pictureViews objectAtIndex:location.tag];
            feed_pic *feedPic = (feed_pic*)[cell.feedPosts objectAtIndex:location.tag];
            
            circularMenu = [self createCircularMenuWithFrame:pictureView.bounds];
            circularMenu.startPoint = CGPointMake(cell.frame.origin.x + pictureView.center.x, cell.frame.origin.y + pictureView.center.y);
            circularMenu.delegate = self;
            circularMenu.menuWholeAngle = 2.5f;
            circularMenu.farRadius = 60.0f;
            circularMenu.endRadius = 50.0f;
            circularMenu.nearRadius = 40.0f;
            circularMenu.animationDuration = 0.7f;
            circularMenu.rotateAngle = 5.04f;
            [circularMenu setExpanding:YES];
            
            [tableView addSubview:circularMenu];
            
            postID = feedPic.photo_id;
            giveProfile = FALSE;
            receivedLocation = location;
        }
        
        return;
    }
    
    if (discoveryItem.totalPost == 3)
    {
        ThreePhotosCell *cell = (ThreePhotosCell *)[tableView cellForRowAtIndexPath:location.index];
        
        if (cell == nil)
        {
            return;
        }
        
        if (location == cell.topDraggableLocation)
        {
            circularMenu = [self createCircularCellMenuWithFrame:cell.infoView.bounds];
            circularMenu.startPoint = CGPointMake(cell.frame.origin.x + 175, cell.frame.origin.y + 69);
            circularMenu.delegate = self;
            circularMenu.menuWholeAngle = 0;
            circularMenu.rotateAngle = 0;
            circularMenu.farRadius = 60.0f;
            circularMenu.endRadius = 50.0;
            circularMenu.nearRadius = 40.0f;
            circularMenu.animationDuration = 0.7f;
            [circularMenu setExpanding:YES];
            
            [tableView addSubview:circularMenu];
            model = cell.uid;
            giveProfile = TRUE;
        }
        else
        {
            UIView *pictureView = [cell.pictureViews objectAtIndex:location.tag];
            feed_pic *feedPic = (feed_pic*)[cell.feedPics objectAtIndex:location.tag];
            
            circularMenu = [self createCircularMenuWithFrame:pictureView.bounds];
            circularMenu.startPoint = CGPointMake(cell.frame.origin.x + pictureView.center.x, cell.frame.origin.y + pictureView.center.y);
            circularMenu.delegate = self;
            circularMenu.menuWholeAngle = 2.5f;
            circularMenu.farRadius = 60.0f;
            circularMenu.endRadius = 50.0f;
            circularMenu.nearRadius = 40.0f;
            circularMenu.animationDuration = 0.7f;
            circularMenu.rotateAngle = 5.04f;
            [circularMenu setExpanding:YES];
            
            [tableView addSubview:circularMenu];
            
            postID = feedPic.photo_id;
            giveProfile = FALSE;
            receivedLocation = location;
        }
        
        return;
    }
    
    if (discoveryItem.totalPost == 4)
    {
        FourPhotosCell *cell = (FourPhotosCell *)[tableView cellForRowAtIndexPath:location.index];
        
        if (cell == nil)
        {
            return;
        }
        
        if (location == cell.topDraggableLocation)
        {
            circularMenu = [self createCircularCellMenuWithFrame:cell.infoView.bounds];
            circularMenu.startPoint = CGPointMake(cell.frame.origin.x + 175, cell.frame.origin.y + 69);
            circularMenu.delegate = self;
            circularMenu.menuWholeAngle = 0;
            circularMenu.rotateAngle = 0;
            circularMenu.farRadius = 60.0f;
            circularMenu.endRadius = 50.0;
            circularMenu.nearRadius = 40.0f;
            circularMenu.animationDuration = 0.7f;
            [circularMenu setExpanding:YES];
            
            [tableView addSubview:circularMenu];
            model = cell.uid;
            giveProfile = TRUE;
        }
        else
        {
            UIView *pictureView = [cell.pictureViews objectAtIndex:location.tag];
            feed_pic *feedPic = (feed_pic*)[cell.feedPics objectAtIndex:location.tag];
            
            circularMenu = [self createCircularMenuWithFrame:pictureView.bounds];
            circularMenu.startPoint = CGPointMake(cell.frame.origin.x + pictureView.center.x, cell.frame.origin.y + pictureView.center.y);
            circularMenu.delegate = self;
            circularMenu.menuWholeAngle = 2.5f;
            circularMenu.farRadius = 60.0f;
            circularMenu.endRadius = 50.0f;
            circularMenu.nearRadius = 40.0f;
            circularMenu.animationDuration = 0.7f;
            circularMenu.rotateAngle = 5.04f;
            [circularMenu setExpanding:YES];
            
            [tableView addSubview:circularMenu];
            
            postID = feedPic.photo_id;
            giveProfile = FALSE;
            receivedLocation = location;
        }
        
        return;
    }
    
    if (discoveryItem.totalPost == 5)
    {
        FivePhotosCell *cell = (FivePhotosCell *)[tableView cellForRowAtIndexPath:location.index];
        
        if (cell == nil)
        {
            return;
        }
        
        if (location == cell.topDraggableLocation)
        {
            circularMenu = [self createCircularCellMenuWithFrame:cell.infoView.bounds];
            circularMenu.startPoint = CGPointMake(cell.frame.origin.x + 175, cell.frame.origin.y + 69);
            circularMenu.delegate = self;
            circularMenu.menuWholeAngle = 0;
            circularMenu.rotateAngle = 0;
            circularMenu.farRadius = 60.0f;
            circularMenu.endRadius = 50.0;
            circularMenu.nearRadius = 40.0f;
            circularMenu.animationDuration = 0.7f;
            [circularMenu setExpanding:YES];
            
            [tableView addSubview:circularMenu];
            model = cell.uid;
            giveProfile = TRUE;
        }
        else
        {
            UIView *pictureView = [cell.pictureViews objectAtIndex:location.tag];
            feed_pic *feedPic = (feed_pic*)[cell.feedPics objectAtIndex:location.tag];
            
            circularMenu = [self createCircularMenuWithFrame:pictureView.bounds];
            circularMenu.startPoint = CGPointMake(cell.frame.origin.x + pictureView.center.x, cell.frame.origin.y + pictureView.center.y);
            circularMenu.delegate = self;
            circularMenu.menuWholeAngle = 2.5f;
            circularMenu.farRadius = 60.0f;
            circularMenu.endRadius = 50.0f;
            circularMenu.nearRadius = 40.0f;
            circularMenu.animationDuration = 0.7f;
            circularMenu.rotateAngle = 5.04f;
            [circularMenu setExpanding:YES];
            
            [tableView addSubview:circularMenu];
            
            postID = feedPic.photo_id;
            giveProfile = FALSE;
            receivedLocation = location;
        }
        
        return;
    }
}

- (void)configureDraggableLocation:(SEDraggableLocation *)draggableLocation makeCircle:(BOOL)isCircle {
    // set the width and height of the objects to be contained in this SEDraggableLocation (for spacing/arrangement purposes)
    draggableLocation.objectWidth = OBJECT_WIDTH;
    draggableLocation.objectHeight = OBJECT_HEIGHT;

    // set the bounding margins for this location
    draggableLocation.marginLeft = MARGIN_HORIZONTAL;
    draggableLocation.marginRight = MARGIN_HORIZONTAL;
    draggableLocation.marginTop = MARGIN_VERTICAL;
    draggableLocation.marginBottom = MARGIN_VERTICAL;

    // set the margins that should be preserved between auto-arranged objects in this location
    draggableLocation.marginBetweenX = MARGIN_HORIZONTAL;
    draggableLocation.marginBetweenY = MARGIN_VERTICAL;

    // set up highlight-on-drag-over behavior
    draggableLocation.highlightColor = [UIColor clearColor].CGColor;

    if(isCircle)
        draggableLocation.layer.cornerRadius = draggableLocation.frame.size.width / 2; // VanLuu-remove #1 avatar
    draggableLocation.clipsToBounds = true;
    draggableLocation.highlightOpacity = 0.4f;
    draggableLocation.shouldHighlightOnDragOver = YES;

    // you may want to toggle this on/off when certain events occur in your app
    draggableLocation.shouldAcceptDroppedObjects = NO;

    // set up auto-arranging behavior
    draggableLocation.shouldKeepObjectsArranged = YES;
    draggableLocation.fillHorizontallyFirst = YES; // NO makes it fill rows first
    draggableLocation.allowRows = YES;
    draggableLocation.allowColumns = YES;
    draggableLocation.shouldAnimateObjectAdjustments = YES; // if this is set to NO, objects will simply appear instantaneously at their new positions
    draggableLocation.animationDuration = 0.5f;
    draggableLocation.animationDelay = 0.0f;
    draggableLocation.animationOptions = UIViewAnimationOptionLayoutSubviews ; // UIViewAnimationOptionBeginFromCurrentState;

    draggableLocation.shouldAcceptObjectsSnappingBack = YES;
}

- (AwesomeMenu *)createCircularMenuWithFrame:(CGRect)frame
{
    UIImage *backgroundImage1 = [UIImage imageNamed:@"GivingFlowers_1.png"];
    UIImage *highlightedBackgroundImage1 = [UIImage imageNamed:@"GivingFlowers_1.png"];
    UIImage *backgroundImage10 = [UIImage imageNamed:@"GivingFlowers_10.png"];
    UIImage *highlightedBackgroundImage10 = [UIImage imageNamed:@"GivingFlowers_10.png"];
    UIImage *backgroundImage100 = [UIImage imageNamed:@"GivingFlowers_100.png"];
    UIImage *highlightedBackgroundImage100 = [UIImage imageNamed:@"GivingFlowers_100.png"];
    AwesomeMenuItem *flowerButton1 = [[AwesomeMenuItem alloc]
                                      initWithImage:backgroundImage1
                                      highlightedImage:highlightedBackgroundImage1
                                      text:@(FIRST_FLOWER_BUTTON_VALUE).stringValue];
    AwesomeMenuItem *flowerButton2 = [[AwesomeMenuItem alloc]
                                      initWithImage:backgroundImage10
                                      highlightedImage:highlightedBackgroundImage10
                                      text:@(SECOND_FLOWER_BUTTON_VALUE).stringValue];
    AwesomeMenuItem *flowerButton3 = [[AwesomeMenuItem alloc]
                                      initWithImage:backgroundImage100
                                      highlightedImage:highlightedBackgroundImage100
                                      text:@(THIRD_FLOWER_BUTTON_VALUE).stringValue];
    AwesomeMenuItem *flowerButton4 = [[AwesomeMenuItem alloc]
                                      initWithImage:[UIImage imageNamed:@"GivingFlowers_....png"]
                                      highlightedImage:[UIImage imageNamed:@"GivingFlowers_....png"]
                                      text:@""];
//    AwesomeMenuItem *flowerButton5 = [[AwesomeMenuItem alloc]
//                                      initWithImage:[UIImage imageNamed:@"GivingFlower_Store.png"]
//                                      highlightedImage:[UIImage imageNamed:@"GivingFlower_Store.png"]
//                                      text:@""];
    NSArray *menus = [NSArray arrayWithObjects:flowerButton1, flowerButton2, flowerButton3, flowerButton4, nil];
    
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"GivingFlower_Store.png"]
                                                       highlightedImage:[UIImage imageNamed:@"GivingFlower_Store.png"]
                                                                   text:@""];
    
    AwesomeMenu *resultMenu = [[AwesomeMenu alloc] initWithFrame:frame startItem:startItem optionMenus:menus isCell:FALSE];
    
    return resultMenu;
}

- (AwesomeMenu *)createCircularCellMenuWithFrame:(CGRect)frame
{
    
    UIImage *backgroundImage1 = [UIImage imageNamed:@"GivingFlowers_1.png"];
    UIImage *highlightedBackgroundImage1 = [UIImage imageNamed:@"GivingFlowers_1.png"];
    UIImage *backgroundImage10 = [UIImage imageNamed:@"GivingFlowers_10.png"];
    UIImage *highlightedBackgroundImage10 = [UIImage imageNamed:@"GivingFlowers_10.png"];
    UIImage *backgroundImage100 = [UIImage imageNamed:@"GivingFlowers_100.png"];
    UIImage *highlightedBackgroundImage100 = [UIImage imageNamed:@"GivingFlowers_100.png"];
    AwesomeMenuItem *flowerButton1 = [[AwesomeMenuItem alloc]
                                      initWithImage:backgroundImage1
                                      highlightedImage:highlightedBackgroundImage1
                                      text:@(FIRST_FLOWER_BUTTON_VALUE).stringValue];
    AwesomeMenuItem *flowerButton2 = [[AwesomeMenuItem alloc]
                                      initWithImage:backgroundImage10
                                      highlightedImage:highlightedBackgroundImage10
                                      text:@(SECOND_FLOWER_BUTTON_VALUE).stringValue];
    AwesomeMenuItem *flowerButton3 = [[AwesomeMenuItem alloc]
                                      initWithImage:backgroundImage100
                                      highlightedImage:highlightedBackgroundImage100
                                      text:@(THIRD_FLOWER_BUTTON_VALUE).stringValue];
    AwesomeMenuItem *flowerButton4 = [[AwesomeMenuItem alloc]
                                      initWithImage:[UIImage imageNamed:@"GivingFlowers_....png"]
                                      highlightedImage:[UIImage imageNamed:@"GivingFlowers_....png"]
                                      text:@""];
    AwesomeMenuItem *flowerButton5 = [[AwesomeMenuItem alloc]
                                      initWithImage:[UIImage imageNamed:@"GivingFlower_Store.png"]
                                      highlightedImage:[UIImage imageNamed:@"GivingFlower_Store.png"]
                                      text:@""];
    NSArray *menus = [NSArray arrayWithObjects:flowerButton1, flowerButton2, flowerButton3, flowerButton4, flowerButton5, nil];
    
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:nil
                                                       highlightedImage:nil
                                                                   text:@""];
    
    AwesomeMenu *resultMenu = [[AwesomeMenu alloc] initWithFrame:frame startItem:startItem optionMenus:menus isCell:TRUE];
    
    return resultMenu;
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
        
        if (giveProfile) {
            [self giveFlowerProfile:flower];
        } else {
            [self giveFlowerPost:flower];
        }
    }
    else
    {
        if (idx == 3) {
            flowerPopup = [[FlowerMenuPostPopupViewController alloc] initWithNibName:@"FlowerMenuPopUpViewController" bundle:nil];
            
            if (giveProfile) {
                flowerPopup.isProfile = TRUE;
                flowerPopup.uid = model;
            } else {
                flowerPopup.isProfile = FALSE;
                flowerPopup.postID = postID;
            }
            
            flowerPopup.parentView = self;
            flowerPopup.isFirstRank = FALSE;
            
            flowerPopup.view.frame = [UIScreen mainScreen].bounds; // Get device's bounds
            [flowerPopup showInView:[[[UIApplication sharedApplication] delegate] window] animated:TRUE];
        } else if (idx == 4 || idx == -1) {
            FlowerGardenViewController *view = [[FlowerGardenViewController alloc] initWithNibName:@"FlowerGardenViewController" bundle:nil];
            [_tabbar snapbackFlowerIconToTabbar];
            view.hidesBottomBarWhenPushed = TRUE;
            [self.navigationController pushViewController:view animated:TRUE];
        }
    }
}

- (void)giveFlowerProfile:(long long)flower {
    flower_give_profile *params = [[flower_give_profile alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] num_flower:flower receiver:model];
    if (params) {
        API_Flower_GiveProfile *api = [[API_Flower_GiveProfile alloc] initWithParams:params];
        __weak typeof(self) weakSelf = self;
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            out_flower_give * data = (out_flower_give *)jsonObject;
            if (response.status) {
                if (weakSelf) {
                    [userDefaultManager didTutorialGiveFlowerRace:TRUE];
                    [weakSelf processAfterGivingFlowerToProfile:data receiverID:data.receiver ];
                    [data showFlowerGivingPopupIn:[UIApplication sharedApplication].keyWindow];
                }
            } else {
                [AppHelper showMessageBox:nil message:response.message];
            }
        } ErrorHandlure:^(NSError *error) {
            
        }];
    }

}

- (void)giveFlowerPost:(long long)flower {
    flower_give_post *params = [[flower_give_post alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] num_flower:flower postID:postID receiver:model];
    if (params) {
        API_Flower_GivePost *api = [[API_Flower_GivePost alloc] initWithParams:params];
        __weak typeof(self) weakSelf = self;
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            if (response.status) {
                if (weakSelf) {
                    out_flower_give *data = (out_flower_give *)jsonObject;
                    [userDefaultManager didTutorialGiveFlowerRace:TRUE];
                    [weakSelf processAfterGivingFlowerToPost:data receiverID:api.receiverID postID:api.postID];
                    [data showFlowerGivingPopupIn:[UIApplication sharedApplication].keyWindow];
                }
                
            } else {
                [AppHelper showMessageBox:nil message:response.message];
            }
        } ErrorHandlure:^(NSError *error) {
            
        }];
    }
    

}

- (void)processAfterGivingFlowerToPost:(out_flower_give *)data receiverID:(NSInteger)receiverID postID:(NSString*)postID{
    profileData = [userDefaultManager getUserProfileData];
    profileData.your_num_flower = data.mFlower;
    [userDefaultManager saveUserProfileData:profileData];
    [_tabbar updateFlowerValue];
    
    //update info of receive model
    for (DiscoveryModel* item in discoveryList) {
        if (item.uid == receiverID) {
            item.received_flower = data.flower_model;
        }
        
        if ([discoveryList indexOfObject:item] == receivedLocation.index.row) {
            [item.posts enumerateObjectsUsingBlock:^(feed_pic * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.photo_id isEqualToString:postID]) {
                    obj.mygiveflower = data.mygiveFlower;
                    
                    if ([receivedLocation.type isEqualToString:@"single"])
                    {
                        SinglePhotoCell *cell = [self.tableView cellForRowAtIndexPath:receivedLocation.index];
                        cell.iconGivedFlowerPhoto.hidden = !(data.mygiveFlower > 0);
                    }
                    else
                    {
                        FivePhotosCell *cell = [self.tableView cellForRowAtIndexPath:receivedLocation.index];
                        UIImageView *iconGivedFlowerPhoto = (UIImageView*)cell.iconGivedFlowerPhotos[idx];
                        iconGivedFlowerPhoto.hidden = !(data.mygiveFlower > 0);
                    }
                }
            }];
        }   
    }

    [self ShowThankYouPopup];
    if (data.bonus_flower > 0)
    {
        [AppHelper showMatchingFlowerPopUp:data.bonus_flower];
    }
    
    // [_tableView reloadData]; ====> Please don't put the reloadData method in this function. It will trouble the drag-n-drop flower system. Thanks :)!!!
}

- (void)processAfterGivingFlowerToProfile:(out_flower_give *)data receiverID:(NSInteger)receiverID {
    profileData = [userDefaultManager getUserProfileData];
    profileData.your_num_flower = data.mFlower;
    [userDefaultManager saveUserProfileData:profileData];
    [_tabbar updateFlowerValue];
    
    //update info of receive model
    for (DiscoveryModel* item in discoveryList) {
        if (item.uid == receiverID) {
            item.received_flower = data.flower_model;
        }
    }
    
    [self ShowThankYouPopup];
    if (data.bonus_flower > 0)
    {
        [AppHelper showMatchingFlowerPopUp:data.bonus_flower];
    }
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

#pragma mark - ThankYou poup

- (void)ShowThankYouPopup
{
    receivedLocation.showThankYou = true;
    
    if (giveProfile)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:receivedLocation.index];
        SinglePhotoCell *realCell = (SinglePhotoCell*)cell;
        realCell.profileThankYouView.hidden = false;
    }
    else
    {
        for (UIView *subView in receivedLocation.subviews)
        {
            if (subView.tag == 100)
            {
                subView.hidden = false;
                break;
            }
        }
    }
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:receivedLocation forKey:@"receivedLocation"];
    [userInfo setObject:[NSNumber numberWithBool:giveProfile] forKey:@"giveProfile"];
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(removeThankYou:) userInfo:userInfo repeats:NO];
}

- (void)removeThankYou:(NSTimer*)timer
{
    NSDictionary *userInfo = timer.userInfo;
    SEDraggableLocation *tempReceivedLocation = userInfo[@"receivedLocation"];
    BOOL tempGiveProfile = [userInfo[@"giveProfile"] boolValue];
    
    tempReceivedLocation.showThankYou = false;
    if (tempReceivedLocation.index.row < discoveryList.count)
    {
        if (tempGiveProfile)
        {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:tempReceivedLocation.index];
            SinglePhotoCell *realCell = (SinglePhotoCell*)cell;
            realCell.profileThankYouView.hidden = true;
        }
        else
        {
            for (UIView *subView in tempReceivedLocation.subviews)
            {
                if (subView.tag == 100)
                {
                    subView.hidden = true;
                    break;
                }
            }
        }
    }
}

#pragma mark - UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _tableView)
    {
        DiscoveryModel *temp = (DiscoveryModel *)[discoveryList objectAtIndex:indexPath.row];
        
        if (temp.totalPost == 1)
        {
            return [SinglePhotoCell cellHeight];
        }
        
        if (temp.totalPost == 2)
        {
            return [TwoPhotosCell cellHeight];
        }
        
        if (temp.totalPost == 3)
        {
            return [ThreePhotosCell cellHeight];
        }
        
        if (temp.totalPost == 4)
        {
            return [FourPhotosCell cellHeight];
        }
        
        if (temp.totalPost == 5)
        {
            return [FivePhotosCell cellHeight];
        }
        
        return 0;
    }
    else
    {
        return 45;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == searchResultTableView)
    {
        return [searchResult count];
    }
    else
    {
        return discoveryList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView == _tableView)
    {
        DiscoveryModel *temp = (DiscoveryModel *)[discoveryList objectAtIndex:indexPath.row];
        
        if (temp.totalPost == 1)
        {
            // Single cell
            SinglePhotoCell *cell = (SinglePhotoCell *)[tableView dequeueReusableCellWithIdentifier:[SinglePhotoCell cellIdentifier]];
            feed_pic *feedPic = (feed_pic*)temp.posts.firstObject;
            
            cell.navigationController = self.navigationController;
            cell.parentTableView = tableView;
            cell.cellIndex = indexPath;
            cell.uid = temp.uid;
            cell.tabbar = self.tabbar;
            cell.post_id = feedPic.photo_id;
            cell.post_url = feedPic.photo_url;
            
            if (feedPic.mygiveflower > 0)
            {
                cell.iconGivedFlowerPhoto.hidden = false;
            }
            else
            {
                cell.iconGivedFlowerPhoto.hidden = true;
            }

            cell.topDraggableLocation.delegate = self;
            cell.topDraggableLocation.index = indexPath;
            cell.topDraggableLocation.type = @"single";
            cell.topDraggableLocation.thankyouStyle = 4;
            [self configureDraggableLocation:cell.topDraggableLocation makeCircle:NO];
            
            [self.tabbar.draggableButton addAllowedDropLocation:cell.topDraggableLocation];
            [self.listDraggableLocationTop addObject:cell.topDraggableLocation];

            cell.draggableLocation.delegate = self;
            cell.draggableLocation.index = indexPath;
            cell.draggableLocation.type = @"single";
            [self configureDraggableLocation:cell.draggableLocation makeCircle:NO];
            
            [self.tabbar.draggableButton addAllowedDropLocation:cell.draggableLocation];
            [self.listDraggableLocationTop addObject:cell.draggableLocation];
            
            [cell.photo setImageWithAnimationFromURL:[NSURL URLWithString:feedPic.photo_url] placeHolder:[UIImage imageNamed:@"Banners_mockup.png"]];

//            [cell.photo sd_setImageWithURL:[NSURL URLWithString:feedPic.photo_url] placeholderImage:[UIImage imageNamed:@"Banners_mockup.png"]];
            
            [cell.avatar sd_setImageWithURL:[NSURL URLWithString:temp.avatar]];
            cell.labelUsername.text = temp.username;
            cell.labelName.text = temp.name;
            cell.labelFlowerWidth.constant = 0;
            cell.labelTimeWidth.constant = 0;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            cell.thankYouView.hidden = !(cell.draggableLocation.showThankYou);
            cell.profileThankYouView.hidden = !(cell.topDraggableLocation.showThankYou);
            
            return cell;
        }
        
        if (temp.totalPost == 2)
        {
            // Two Photos cell
            TwoPhotosCell *cell = (TwoPhotosCell*)[tableView dequeueReusableCellWithIdentifier:[TwoPhotosCell cellIdentifier]];
            
            cell.navigationController = self.navigationController;
            cell.parentTableView = tableView;
            cell.cellIndex = indexPath;
            cell.uid = temp.uid;
            cell.tabbar = self.tabbar;
            cell.feedPosts = [temp.posts copy];
            cell.feedID = temp.feed_id;

            cell.topDraggableLocation.delegate = self;
            cell.topDraggableLocation.index = indexPath;
            cell.topDraggableLocation.type = @"single";
            cell.topDraggableLocation.thankyouStyle = 4;
            [self configureDraggableLocation:cell.topDraggableLocation makeCircle:NO];
            
            cell.profileThankYouView.hidden = !(cell.topDraggableLocation.showThankYou);
            
            [self.tabbar.draggableButton addAllowedDropLocation:cell.topDraggableLocation];
            [self.listDraggableLocationTop addObject:cell.topDraggableLocation];

            for (NSInteger i = 0; i < cell.draggableLocations.count; i++)
            {
                SEDraggableLocation* draggableLocation = (SEDraggableLocation*)cell.draggableLocations[i];
                
                draggableLocation.delegate = self;
                draggableLocation.index = indexPath;
                draggableLocation.type = @"single";
                [self configureDraggableLocation:draggableLocation makeCircle:NO];
                
                [self.tabbar.draggableButton addAllowedDropLocation:draggableLocation];
                [self.listDraggableLocationTop addObject:draggableLocation];
                
                cell.thankYouViews[i].hidden = !(draggableLocation.showThankYou);
            }
            
            for (NSInteger i = 0; i < temp.posts.count; i++)
            {
                feed_pic *feedPic = (feed_pic*)temp.posts[i];
                UIImageView *photo = (UIImageView*)cell.photos[i];
                [photo setImageWithAnimationFromURL:[NSURL URLWithString:feedPic.photo_url] placeHolder:[UIImage imageNamed:@"Banners_mockup.png"]];
                
                UIImageView *iconGivedFlowerPhoto = (UIImageView*)cell.iconGivedFlowerPhotos[i];
                
                if (feedPic.mygiveflower > 0)
                {
                    iconGivedFlowerPhoto.hidden = false;
                }
                else
                {
                    iconGivedFlowerPhoto.hidden = true;
                }
            }

            [cell.avatar sd_setImageWithURL:[NSURL URLWithString:temp.avatar]];
            cell.labelUsername.text = temp.username;
            cell.labelName.text = temp.name;
            cell.labelFlowerWidth.constant = 0;
            cell.labelTimeWidth.constant = 0;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        
        if (temp.totalPost == 3)
        {
            // Three Photos cell
            ThreePhotosCell *cell = (ThreePhotosCell*)[tableView dequeueReusableCellWithIdentifier:[ThreePhotosCell cellIdentifier]];
            
            cell.navigationController = self.navigationController;
            cell.parentTableView = tableView;
            cell.cellIndex = indexPath;
            cell.uid = temp.uid;
            cell.tabbar = self.tabbar;
            cell.feedPics = [temp.posts copy];
            cell.feedID = temp.feed_id;

            cell.topDraggableLocation.delegate = self;
            cell.topDraggableLocation.index = indexPath;
            cell.topDraggableLocation.type = @"single";
            cell.topDraggableLocation.thankyouStyle = 4;
            [self configureDraggableLocation:cell.topDraggableLocation makeCircle:NO];
            
            cell.profileThankYouView.hidden = !(cell.topDraggableLocation.showThankYou);
            
            [self.tabbar.draggableButton addAllowedDropLocation:cell.topDraggableLocation];
            [self.listDraggableLocationTop addObject:cell.topDraggableLocation];

            for (NSInteger i = 0; i < cell.draggableLocations.count; i++)
            {
                SEDraggableLocation* draggableLocation = (SEDraggableLocation*)cell.draggableLocations[i];
                
                draggableLocation.delegate = self;
                draggableLocation.index = indexPath;
                draggableLocation.type = @"single";
                [self configureDraggableLocation:draggableLocation makeCircle:NO];
                
                [self.tabbar.draggableButton addAllowedDropLocation:draggableLocation];
                [self.listDraggableLocationTop addObject:draggableLocation];
                
                cell.thankYouViews[i].hidden = !(draggableLocation.showThankYou);
            }
            
            for (NSInteger i = 0; i < temp.posts.count; i++)
            {
                feed_pic *feedPic = (feed_pic*)temp.posts[i];
                UIImageView *photo = (UIImageView*)cell.photos[i];
                [photo setImageWithAnimationFromURL:[NSURL URLWithString:feedPic.photo_url] placeHolder:[UIImage imageNamed:@"Banners_mockup.png"]];
                
                UIImageView *iconGivedFlowerPhoto = (UIImageView*)cell.iconGivedFlowerPhotos[i];
                
                if (feedPic.mygiveflower > 0)
                {
                    iconGivedFlowerPhoto.hidden = false;
                }
                else
                {
                    iconGivedFlowerPhoto.hidden = true;
                }
            }
            
            [cell.avatar sd_setImageWithURL:[NSURL URLWithString:temp.avatar]];
            cell.labelUsername.text = temp.username;
            cell.labelName.text = temp.name;
            cell.labelFlowerWidth.constant = 0;
            cell.labelTimeWidth.constant = 0;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        
        if (temp.totalPost == 4)
        {
            // Four Photos cell
            FourPhotosCell *cell = (FourPhotosCell*)[tableView dequeueReusableCellWithIdentifier:[FourPhotosCell cellIdentifier]];
            
            cell.navigationController = self.navigationController;
            cell.parentTableView = tableView;
            cell.cellIndex = indexPath;
            cell.uid = temp.uid;
            cell.tabbar = self.tabbar;
            cell.feedPics = [temp.posts copy];
            cell.feedID = temp.feed_id;

            cell.topDraggableLocation.delegate = self;
            cell.topDraggableLocation.index = indexPath;
            cell.topDraggableLocation.type = @"single";
            cell.topDraggableLocation.thankyouStyle = 4;
            [self configureDraggableLocation:cell.topDraggableLocation makeCircle:NO];
            
            cell.profileThankYouView.hidden = !(cell.topDraggableLocation.showThankYou);
            
            [self.tabbar.draggableButton addAllowedDropLocation:cell.topDraggableLocation];
            [self.listDraggableLocationTop addObject:cell.topDraggableLocation];
            
            for (NSInteger i = 0; i < cell.draggableLocations.count; i++)
            {
                SEDraggableLocation* draggableLocation = (SEDraggableLocation*)cell.draggableLocations[i];
                
                draggableLocation.delegate = self;
                draggableLocation.index = indexPath;
                draggableLocation.type = @"single";
                [self configureDraggableLocation:draggableLocation makeCircle:NO];
                
                [self.tabbar.draggableButton addAllowedDropLocation:draggableLocation];
                [self.listDraggableLocationTop addObject:draggableLocation];
                
                cell.thankYouViews[i].hidden = !(draggableLocation.showThankYou);
            }
            
            for (NSInteger i = 0; i < temp.posts.count; i++)
            {
                feed_pic *feedPic = (feed_pic*)temp.posts[i];
                UIImageView *photo = (UIImageView*)cell.photos[i];
                [photo setImageWithAnimationFromURL:[NSURL URLWithString:feedPic.photo_url] placeHolder:[UIImage imageNamed:@"Banners_mockup.png"]];
                
                UIImageView *iconGivedFlowerPhoto = (UIImageView*)cell.iconGivedFlowerPhotos[i];
                
                if (feedPic.mygiveflower > 0)
                {
                    iconGivedFlowerPhoto.hidden = false;
                }
                else
                {
                    iconGivedFlowerPhoto.hidden = true;
                }
            }
            
            [cell.avatar sd_setImageWithURL:[NSURL URLWithString:temp.avatar]];
            cell.labelUsername.text = temp.username;
            cell.labelName.text = temp.name;
            cell.labelFlowerWidth.constant = 0;
            cell.labelTimeWidth.constant = 0;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        
        if (temp.totalPost == 5)
        {
            // Five Photos cell
            FivePhotosCell *cell = (FivePhotosCell*)[tableView dequeueReusableCellWithIdentifier:[FivePhotosCell cellIdentifier]];
            
            cell.navigationController = self.navigationController;
            cell.parentTableView = tableView;
            cell.cellIndex = indexPath;
            cell.uid = temp.uid;
            cell.tabbar = self.tabbar;
            cell.feedPics = [temp.posts copy];
            cell.feedID = temp.feed_id;

            cell.topDraggableLocation.delegate = self;
            cell.topDraggableLocation.index = indexPath;
            cell.topDraggableLocation.type = @"single";
            cell.topDraggableLocation.thankyouStyle = 4;
            [self configureDraggableLocation:cell.topDraggableLocation makeCircle:NO];
            
            cell.profileThankYouView.hidden = !(cell.topDraggableLocation.showThankYou);
            
            [self.tabbar.draggableButton addAllowedDropLocation:cell.topDraggableLocation];
            [self.listDraggableLocationTop addObject:cell.topDraggableLocation];

            for (NSInteger i = 0; i < cell.draggableLocations.count; i++)
            {
                SEDraggableLocation* draggableLocation = (SEDraggableLocation*)cell.draggableLocations[i];
                
                draggableLocation.delegate = self;
                draggableLocation.index = indexPath;
                draggableLocation.type = @"single";
                [self configureDraggableLocation:draggableLocation makeCircle:NO];
                
                [self.tabbar.draggableButton addAllowedDropLocation:draggableLocation];
                [self.listDraggableLocationTop addObject:draggableLocation];
                
                cell.thankYouViews[i].hidden = !(draggableLocation.showThankYou);
            }
            
            for (NSInteger i = 0; i < temp.posts.count; i++)
            {
                feed_pic *feedPic = (feed_pic*)temp.posts[i];
                UIImageView *photo = (UIImageView*)cell.photos[i];
                [photo setImageWithAnimationFromURL:[NSURL URLWithString:feedPic.photo_url] placeHolder:[UIImage imageNamed:@"Banners_mockup.png"]];
                
                UIImageView *iconGivedFlowerPhoto = (UIImageView*)cell.iconGivedFlowerPhotos[i];
                
                if (feedPic.mygiveflower > 0)
                {
                    iconGivedFlowerPhoto.hidden = false;
                }
                else
                {
                    iconGivedFlowerPhoto.hidden = true;
                }
            }
            
            [cell.avatar sd_setImageWithURL:[NSURL URLWithString:temp.avatar]];
            cell.labelUsername.text = temp.username;
            cell.labelName.text = temp.name;
            cell.labelFlowerWidth.constant = 0;
            cell.labelTimeWidth.constant = 0;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }
    else if (tableView == searchResultTableView)
    {
        if (searchResult.count != 0) {
            RacesSearchTableViewCell *cell = (RacesSearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[RacesSearchTableViewCell cellIdentifier]
                                                                                                         forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            DiscoveryModel  *temp = (DiscoveryModel *)[searchResult objectAtIndex:indexPath.row];
            [cell.avatar sd_setImageWithURL:[NSURL URLWithString:temp.avatar]];
            cell.name.text = temp.name;
            cell.username.text = temp.username;
            cell.rank.text = @"";//[NSString stringWithFormat:@"#%@", @(temp.rank).stringValue];
            
            return cell;
        }
    }
    
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == searchResultTableView && searchResult.count > indexPath.row) {
        UserProfileViewController *view;
        view = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
        RacesObj  *temp = (RacesObj *)[searchResult objectAtIndex:indexPath.row];
        view.uid = temp.uid;
        isSearching = false;
        [self.navigationController pushViewController:view animated:YES];
    }
}

#pragma mark - SearchBar
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    currentSearchPage = 0;
    if (searchText.length > 0) {
        searchResultTableView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [searchResultTableView setHidden:NO];
        [backgroundSearchView removeFromSuperview];
        [searchResult removeAllObjects];
        isSearching = true;
        [self invalidateSearchTimer];
        searchTimer = [NSTimer scheduledTimerWithTimeInterval: 0.25
                                                       target:self
                                                     selector:@selector(filterUser)
                                                     userInfo:nil
                                                      repeats:NO];
    } else {
        [self invalidateSearchTimer];
        [searchResultTableView setHidden:YES];

        [searchResult removeAllObjects];
        searchResultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self searchBarShouldBeginEditing:self.searchBar];
        self.notFoundView.hidden = true;
    }
}

-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [backgroundSearchView removeFromSuperview];
    [searchResult removeAllObjects];
    [searchBar setShowsCancelButton:NO animated:YES];
    
    searchBar.text = @"";
    isSearching = false;
    
    [searchResultTableView setHidden:true];
    [self.searchResultTableView reloadData];
    
    self.tableView.userInteractionEnabled = true;
    [self.view endEditing:YES];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    if (self.searchResultTableView.hidden == YES && searchResult.count == 0) {
        isSearching = true;
        self.tableView.userInteractionEnabled = false;
        
        backgroundSearchView = [[UIView alloc] initWithFrame:CGRectZero];
        backgroundSearchView.translatesAutoresizingMaskIntoConstraints = NO;
        [backgroundSearchView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
        [self.view addSubview:backgroundSearchView];
        [backgroundSearchView setAlpha:0];
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [backgroundSearchView setAlpha:1];
        } completion:nil];
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnBackgroundSearchView)];
        [backgroundSearchView addGestureRecognizer:tapGesture];
        
        NSLayoutConstraint * topConstraint = [NSLayoutConstraint constraintWithItem:backgroundSearchView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.searchBar attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        NSLayoutConstraint * leftConstraint = [NSLayoutConstraint constraintWithItem:backgroundSearchView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
        NSLayoutConstraint * rightConstraint = [NSLayoutConstraint constraintWithItem:backgroundSearchView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
        NSLayoutConstraint * bottomConstraint = [NSLayoutConstraint constraintWithItem:backgroundSearchView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        
        [self.view addConstraints:@[topConstraint,leftConstraint,rightConstraint,bottomConstraint]];
        
    }
    
    return YES;
}

- (void)searchAll:(NSString*)textSearch page:(NSInteger)page {
    // search ONLINE
    [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner startAnimating];
    API_DiscoverySearch *api = [[API_DiscoverySearch alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                                   device_token:[userDefaultManager getDeviceToken]
                                                                           term:textSearch
                                                                           size:20
                                                                           page:page];
    __weak typeof(self) weakSelf = self;
    [api getRequest:^(BaseJSON *json, RestfulResponse *response) {
        if (weakSelf) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
            if (response.status) {
                JSON_DiscoverySearch *model = (JSON_DiscoverySearch *)json;
                if (model.searchList.count == 0) {
                    if (currentSearchPage == 0) {
                        [searchResult removeAllObjects];
                        self.notFoundView.hidden = FALSE;
                    }
                    [searchResultTableView reloadData];
                } else {
                    self.notFoundView.hidden = TRUE;
                    if (currentSearchPage == 0) {
                        searchResult = model.searchList;
                    } else {
                        [searchResult addObjectsFromArray:model.searchList];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [searchResultTableView reloadData];
                        if (currentSearchPage == 0) {
                            NSIndexPath* top = [NSIndexPath indexPathForRow:NSNotFound inSection:0];
                            [strongSelf.searchResultTableView scrollToRowAtIndexPath:top atScrollPosition:UITableViewScrollPositionTop animated:YES];
                        }
                    });
                }
            } else {
                [Support addErrorMessage:response.message intoView:self.view];
            }
        }
    } ErrorHandlure:^(NSError *error) {
        NSLog(@"API_DiscoverySearch failed!");
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];
}


- (void)keyboardWillChange:(NSNotification *)notification {

    CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGRect SelfViewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGRect SearchView = [self.searchBar.window convertRect:self.searchBar.bounds fromView:self.view];
    
    CGFloat ViewSearchSize = SelfViewRect.size.height - (keyboardRect.size.height + SearchView.size.height);
    
    CGRect frame = self.searchResultTableView.frame;
    frame.size.height = ViewSearchSize ;
    if(isSearching)
    {
        self.searchResultTableView.frame = frame;
        [self.searchResultTableView setHidden:false];
    }
}

-(void) removeAllowedDropLocationsInList:(NSMutableArray* )locations {
    for (SEDraggableLocation *location in locations)
    {
        [_tabbar.draggableButton removeAllowedDropLocation:location];
    }
        
}
    
-(void) addAllowedDropLocationsInList:(NSMutableArray* )locations {
    
    for (SEDraggableLocation *location in locations)
    {
        
        [self configureDraggableLocation:location makeCircle:NO];
        location.delegate = self;
        //            (location.index = indexPath;
        [_tabbar.draggableButton addAllowedDropLocation:location];
    }
    
}

// MARK: - Selectors
- (void) handleFilter{
    if (isSearching) {
        [self searchBarCancelButtonClicked:self.searchBar];
        
    }
    filterMenu = [FilterCustomView showInView:self Index:gender];
}

- (void)filterMenuDidSelectedAtIndex:(NSInteger)index{
    gender = index;
    isRefresh = YES;
    userID = -1; //Refresh index
    [self loadDiscoveryWithGender:gender];
}

- (void) handleTapOnBackgroundSearchView{
    if (isSearching) {
        [self searchBarCancelButtonClicked:self.searchBar];
    }
    self.notFoundView.hidden = TRUE;
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    CGSize keyboardSize = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSTimeInterval time = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions option = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedLongValue];
    
    self.searchResultTableViewBottomMargin.constant = keyboardSize.height - self.tabBarController.tabBar.frame.size.height;
    [self.searchResultTableView setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:time delay:0 options:option animations:^{
        [self.searchResultTableView layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    self.searchResultTableViewBottomMargin.constant = 0;
    [self.searchResultTableView setNeedsUpdateConstraints];
    
    NSTimeInterval time = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions option = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedLongValue];
    
    [UIView animateWithDuration:time delay:0 options:option animations:^{
        [self.searchResultTableView layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

@end
