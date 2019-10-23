//
//  FriendsUpdateViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 2/16/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "FlowerGardenViewController.h"
#import "FriendsUpdateViewController.h"
#define OBJECT_WIDTH 80.0f
#define OBJECT_HEIGHT 80.0f
#define MARGIN_VERTICAL 0.0f
#define MARGIN_HORIZONTAL 0.0f
#define DRAGGABLE_LOCATION_WIDTH  ((OBJECT_WIDTH  * 3) + (MARGIN_HORIZONTAL * 5))
#define DRAGGABLE_LOCATION_HEIGHT ((OBJECT_HEIGHT * 3) + (MARGIN_VERTICAL   * 5))
#define SUGGESTED_BLOOMER_INDEX 2

@interface FriendsUpdateViewController () {
    UserDefaultManager *userDefaultManager;
    NSMutableArray *feedList;
    NSString *feedID;
    NSString *givedFeedID;
    NSString *givedPostID;
    BOOL loaded;
    BOOL giveProfile;
    NSInteger model;
    FlowerMenuPostPopupViewController *flowerPopup;
    NSMutableDictionary* raceFeeds;
    NSIndexPath *giveIndex;
    SEDraggableLocation *receivedLocation;
    long long givenFlowerQuantity;
}

@end

@implementation FriendsUpdateViewController
@synthesize circularMenu, profileData, thankyou;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    userDefaultManager = [[UserDefaultManager alloc] init];
    profileData = [userDefaultManager getUserProfileData];
    feedList = [[NSMutableArray alloc] init];
    raceFeeds = [[NSMutableDictionary alloc]init];
    _listDraggableLocationSingle = [[NSMutableArray alloc] init];
    _listDraggableLocationTop = [[NSMutableArray alloc] init];
    _listDraggableLocationPicture = [[NSMutableArray alloc] init];
    _listDraggableLocationDouble = [[NSMutableArray alloc] init];
    feedID = @"";
    loaded = FALSE;

    __weak FriendsUpdateViewController *weakSelf = self;
    
    [_updatesTableView addPullToRefreshWithActionHandler:^{
        FriendsUpdateViewController *strongSelf = weakSelf;
        if (strongSelf)
        {
            [strongSelf pullToRefresh];
        }
    }];
    
    [_updatesTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf infiniteScrolling];
    }];
    
    [self.updatesTableView registerNib:[UINib nibWithNibName:FriendsUpdatesRaceTableViewCell.nibName bundle:nil] forCellReuseIdentifier:FriendsUpdatesRaceTableViewCell.cellIdentifier];
    [self.updatesTableView registerNib:[UINib nibWithNibName:[SinglePhotoCell nibName] bundle:nil] forCellReuseIdentifier:[SinglePhotoCell cellIdentifier]];
    [self.updatesTableView registerNib:[UINib nibWithNibName:[TwoPhotosCell nibName] bundle:nil] forCellReuseIdentifier:[TwoPhotosCell cellIdentifier]];
    [self.updatesTableView registerNib:[UINib nibWithNibName:[ThreePhotosCell nibName] bundle:nil] forCellReuseIdentifier:[ThreePhotosCell cellIdentifier]];
    [self.updatesTableView registerNib:[UINib nibWithNibName:[FourPhotosCell nibName] bundle:nil] forCellReuseIdentifier:[FourPhotosCell cellIdentifier]];
    [self.updatesTableView registerNib:[UINib nibWithNibName:[FivePhotosCell nibName] bundle:nil] forCellReuseIdentifier:[FivePhotosCell cellIdentifier]];
    [self.updatesTableView registerNib:[UINib nibWithNibName:[SuggestedBloomerCell nibName] bundle:nil] forCellReuseIdentifier:[SuggestedBloomerCell cellIdentifier]];
    
    [self loadUserFeed];
    [self initNavigationBar];
    
    _labelTitle.text = NSLocalizedString(@"MyBloomer.emptyTitle", );
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(blockProfile:) name:[NotificationNames UidProfileLock] object:nil];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_tabbar updateFlowerValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pullToRefresh {
    feedID = @"";
    loaded = FALSE;
    
    [self loadUserFeed];
    [_updatesTableView.pullToRefreshView stopAnimating];
}

- (void)infiniteScrolling {
    if (feedList.count != 0) {
        feedID = [(Feed *)([feedList objectAtIndex:feedList.count - 1]) feed_id];
    } else {
        feedID = @"";
    }
    
    [self loadMoreWithFeedId:feedID];
}

- (void)initNavigationBar
{
    [AppHelper setTitleViewForNavigationBar:self.navigationItem title:NSLocalizedString(@"My Bloomers", nil)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [_tabbar.draggableButton removeAllAllowedDropLocations ];
    for (SEDraggableLocation *location in _listDraggableLocationSingle)
    {
        [_tabbar.draggableButton addAllowedDropLocation:location];
    }
    
    for (SEDraggableLocation *location in _listDraggableLocationTop)
    {
        [_tabbar.draggableButton addAllowedDropLocation:location];
    }
    
    for (SEDraggableLocation *location in _listDraggableLocationPicture)
    {
        [_tabbar.draggableButton addAllowedDropLocation:location];
    }
    
    for (SEDraggableLocation *location in _listDraggableLocationDouble)
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
    for (SEDraggableLocation *location in _listDraggableLocationSingle)
    {
        [_tabbar.draggableButton removeAllowedDropLocation:location];
    }
    
    for (SEDraggableLocation *location in _listDraggableLocationTop)
    {
        [_tabbar.draggableButton removeAllowedDropLocation:location];
    }
    
    for (SEDraggableLocation *location in _listDraggableLocationPicture)
    {
        [_tabbar.draggableButton removeAllowedDropLocation:location];
    }
    
    for (SEDraggableLocation *location in _listDraggableLocationDouble)
    {
        [_tabbar.draggableButton removeAllowedDropLocation:location];
    }
}

- (void)updatePinFlowerWithFeedID:(NSString*)gFeedID postID:(NSString*)postID
{
    for (NSInteger i = 0; i < feedList.count; i++)
    {
        Feed *feed = (Feed*)[feedList objectAtIndex:i];
        
        if ([feed.feed_id isEqualToString:gFeedID] )
        {
            if (feed.is_album)
            {
                for (NSInteger j = 0; j < feed.posts.count; j++)
                {
                    PostContent *post = (PostContent*)[feed.posts objectAtIndex:j];
                    
                    if ([post.post_id isEqualToString:postID])
                    {
                        post.mygiveflower = 1;
                        [self.updatesTableView reloadData];
                        
                        break;
                    }
                }
            }
            else
            {
                ((PostContent*)[feed.posts objectAtIndex:0]).mygiveflower = 1;
                [self.updatesTableView reloadData];
            }
            
            break;
        }
    }
}

- (void)blockProfile: (NSNotification*)notification {
    
    [self pullToRefresh];
}

#pragma mark - Giving Flower Init

- (void)draggableLocation:(SEDraggableLocation *)location didRefuseObject:(SEDraggable *)object entryMethod:(SEDraggableLocationEntryMethod)method
{
    receivedLocation = nil;
    
    [object setHidden:true];
    if(!object.hidden) return;
    
    if (circularMenu != nil) {
        [circularMenu removeFromSuperview];
    }
    
    receivedLocation = location;
    
    if ([location.type isEqualToString:@"single"] && location.index.row < feedList.count)
    {
        Feed *feedListItem = (Feed *)feedList[location.index.row];
        givedFeedID = feedListItem.feed_id;
        
        if (!feedListItem.is_album)
        {
            SinglePhotoCell *cell = (SinglePhotoCell *)[self.updatesTableView cellForRowAtIndexPath:location.index];
            
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
                circularMenu.farRadius = 60.0f;
                circularMenu.endRadius = 50.0f;
                circularMenu.nearRadius = 40.0f;
                circularMenu.animationDuration = 0.7f;
                circularMenu.rotateAngle = 5.04f;
                [circularMenu setExpanding:YES];
                
                [_updatesTableView addSubview:circularMenu];
                
                givedPostID = cell.post_id;
                giveProfile = FALSE;
                receivedLocation = location;
            }
            else
            {
                circularMenu = [self createCircularCellMenuWithFrame:cell.infoView.bounds];
//                circularMenu.startPoint = CGPointMake(cell.frame.origin.x + 175, cell.frame.origin.y + 69);
                circularMenu.startPoint = CGPointMake((cell.bounds.size.width - circularMenu.menusArray.count * 25) - 15, cell.frame.origin.y + 69);
                circularMenu.delegate = self;
                circularMenu.menuWholeAngle = 0;
                circularMenu.rotateAngle = 0;
                circularMenu.farRadius = 60.0f;
                circularMenu.endRadius = 50.0;
                circularMenu.nearRadius = 40.0f;
                circularMenu.animationDuration = 0.7f;
                [circularMenu setExpanding:YES];
                
                [_updatesTableView addSubview:circularMenu];
                model = cell.uid;
                giveProfile = TRUE;
            }
        }
        else
        {
            if (feedListItem.total_post == 2)
            {
                TwoPhotosCell *cell = (TwoPhotosCell *)[self.updatesTableView cellForRowAtIndexPath:location.index];
                
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
                    
                    [_updatesTableView addSubview:circularMenu];
                    model = cell.uid;
                    giveProfile = TRUE;
                }
                else
                {
                    UIView *pictureView = cell.pictureViews[location.tag];
                    PostContent *feedPic = (PostContent *)cell.feedPosts[location.tag];
                    
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
                    
                    [_updatesTableView addSubview:circularMenu];
                    
                    givedPostID = feedPic.post_id;
                    giveProfile = FALSE;
                    receivedLocation = location;
                }
                
                return;
            }
            
            if (feedListItem.total_post == 3)
            {
                ThreePhotosCell *cell = (ThreePhotosCell *)[self.updatesTableView cellForRowAtIndexPath:location.index];
                
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
                    
                    [_updatesTableView addSubview:circularMenu];
                    model = cell.uid;
                    giveProfile = TRUE;
                }
                else
                {
                    UIView *pictureView = [cell.pictureViews objectAtIndex:location.tag];
                    PostContent *feedPic = (PostContent *)cell.feedPics[location.tag];
                    
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
                    
                    [_updatesTableView addSubview:circularMenu];
                    
                    givedPostID = feedPic.post_id;
                    giveProfile = FALSE;
                    receivedLocation = location;
                }
                
                return;
            }
            
            if (feedListItem.total_post == 4)
            {
                FourPhotosCell *cell = (FourPhotosCell *)[self.updatesTableView cellForRowAtIndexPath:location.index];
                
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
                    
                    [_updatesTableView addSubview:circularMenu];
                    model = cell.uid;
                    giveProfile = TRUE;
                }
                else
                {
                    UIView *pictureView = [cell.pictureViews objectAtIndex:location.tag];
                    PostContent *feedPic = (PostContent *)cell.feedPics[location.tag];
                    
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
                    
                    [_updatesTableView addSubview:circularMenu];
                    
                    givedPostID = feedPic.post_id;
                    giveProfile = FALSE;
                    receivedLocation = location;
                }
                
                return;
            }
            
            if (feedListItem.total_post == 5)
            {
                FivePhotosCell *cell = (FivePhotosCell *)[self.updatesTableView cellForRowAtIndexPath:location.index];
                
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
                    
                    [_updatesTableView addSubview:circularMenu];
                    model = cell.uid;
                    giveProfile = TRUE;
                }
                else
                {
                    UIView *pictureView = [cell.pictureViews objectAtIndex:location.tag];
                    PostContent *feedPic = (PostContent *)cell.feedPics[location.tag];
                    
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
                    
                    [_updatesTableView addSubview:circularMenu];
                    
                    givedPostID = feedPic.post_id;
                    giveProfile = FALSE;
                    receivedLocation = location;
                }
                
                return;
            }
        }
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
    NSArray *menus = [NSArray arrayWithObjects:flowerButton1, flowerButton2, flowerButton3, flowerButton4, nil];
    
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"GivingFlower_Store"]
                                                       highlightedImage:[UIImage imageNamed:@"GivingFlower_Store"]
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
                                      initWithImage:[UIImage imageNamed:@"GivingFlower_Store"]
                                      highlightedImage:[UIImage imageNamed:@"GivingFlower_Store"]
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
            flowerPopup.parentView = self;
            flowerPopup.isFirstRank = false;
            
            if (giveProfile) {
                flowerPopup.isProfile = true;
                flowerPopup.uid = model;
            } else {
                flowerPopup.isProfile = false;
                flowerPopup.postID = givedPostID;
            }
            
            [flowerPopup showInView:[[[UIApplication sharedApplication] delegate] window] animated:true];
        } else if (idx == 4 || idx == -1) {
            FlowerGardenViewController *view = [[FlowerGardenViewController alloc] initWithNibName:@"FlowerGardenViewController" bundle:nil];
            [_tabbar snapbackFlowerIconToTabbar];
            view.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:view animated:TRUE];
        }
    }
}

#pragma mark - APIs

- (void)giveFlowerProfile:(long long)flower {
    flower_give_profile *params = [[flower_give_profile alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                                      device_token:[userDefaultManager getDeviceToken]
                                                                        num_flower:flower
                                                                          receiver:model];
    if (params) {
        API_Flower_GiveProfile *api = [[API_Flower_GiveProfile alloc] initWithParams:params];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            out_flower_give *data = (out_flower_give *)jsonObject;
            if (response.status) {
                [userDefaultManager didTutorialGiveFlowerRace:true];
                [self processAfterGivingFlower:data toProfile:true];
                [data showFlowerGivingPopupIn:[UIApplication sharedApplication].keyWindow];
            } else {
                [AppHelper showMessageBox:nil message:response.message];
            }
        } ErrorHandlure:^(NSError *error) {
            
        }];
    }
}

- (void)giveFlowerPost:(long long)givenFlower {
    flower_give_post *params = [[flower_give_post alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                                device_token:[userDefaultManager getDeviceToken]
                                                                  num_flower:givenFlower
                                                                      postID:givedPostID];
    givenFlowerQuantity = givenFlower;
    
    if (params) {
        API_Flower_GivePost *api = [[API_Flower_GivePost alloc] initWithParams:params];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            out_flower_give *data = (out_flower_give *)jsonObject;
            if (response.status)
            {
                [userDefaultManager didTutorialGiveFlowerRace:true];
                [self updatePinFlowerWithFeedID:givedFeedID postID:api.postID];
                [self processAfterGivingFlower:data toProfile:false];
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

- (void)processAfterGivingFlower:(out_flower_give *)data toProfile:(BOOL)toProfile
{
    if (!toProfile)
    {
        for (Feed* feedItem in feedList)
        {
            if ([feedItem.content_type isEqualToString:@"pic"])
            {
                if (feedItem.posts.count > 1)
                {
                    for (NSInteger i = 0; i < feedItem.posts.count; i++)
                    {
                        PostContent *temp = feedItem.posts[i];
                        if ([temp.post_id isEqualToString:givedPostID])
                        {
                            temp.flower += givenFlowerQuantity;
                            feedItem.total_flower += givenFlowerQuantity;
                            break;
                        }
                    }
                }
                else if (feedItem.posts.count == 1)
                {
                    PostContent *firstPost = ((PostContent *)feedItem.posts[0]);
                    if ([firstPost.post_id isEqualToString:givedPostID])
                    {
                        firstPost.flower += givenFlowerQuantity;
                        feedItem.total_flower += givenFlowerQuantity;
                    }
                }
            }
        }
    }
    
    profileData = [userDefaultManager getUserProfileData];
    profileData.your_num_flower = data.mFlower;
    [userDefaultManager saveUserProfileData:profileData];
    [self.tabbar updateFlowerValue];
    
    [self showThankYouPopup];
    
    [self.updatesTableView reloadData];
    
    if (data.bonus_flower > 0)
    {
        [AppHelper showMatchingFlowerPopUp:data.bonus_flower];
    }
}

#pragma mark - Giving Flower - Thank You popup

- (void)showThankYouPopup
{
    receivedLocation.showThankYou = true;
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
    if (tempGiveProfile)
    {
        UITableViewCell *cell = [self.updatesTableView cellForRowAtIndexPath:tempReceivedLocation.index];
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

- (void)loadUserFeed {
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
    API_Feeds *request = [[API_Feeds alloc] initWithAccessToken:[userDefaultManager getAccessToken] deviceId:[userDefaultManager getDeviceToken] feedId:feedID];
    [request request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        if(response.status) {
            JSON_FeedList *modelData = (JSON_FeedList *)jsonObject;
            if (!loaded) {
                feedList = modelData.feeds;
                if (feedList.count == 0) {
                    self.emptyView.hidden = false;
                } else {
                    self.emptyView.hidden = true;
                    
                    if (feedList.count > SUGGESTED_BLOOMER_INDEX) {
                        feed_list *suggestedCell = [[feed_list alloc] init];
                        [feedList insertObject:suggestedCell atIndex:SUGGESTED_BLOOMER_INDEX];
                    }
                    
                    //get Race info
                    [_updatesTableView reloadData];
                    loaded = TRUE;
                    [modelData.feeds enumerateObjectsUsingBlock:^(Feed*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [self loadRaceFeed: obj];
                    }];
                }
            } /*else if (modelData.feeds.count != 0) {
                [feedList addObjectsFromArray:modelData.feeds];
                [_updatesTableView reloadData];
                [self loadRaceFeed];
            }*/
        } else {
            [AppHelper showMessageBox:nil message:response.message];
        }
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    } ErrorHandlure:^(NSError *error) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];}

- (void)loadRaceFeed: (Feed*) feedItem {
        if([feedItem.content_type isEqualToString:@"race"])
        {
            API_ClosedRaceFeed *maleRequest = [[API_ClosedRaceFeed alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] key:feedItem.racekey gender:1];
            
            [maleRequest request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                if(response.status) {
                    JSON_ClosedRaceFeed *modelData = (JSON_ClosedRaceFeed*)jsonObject;
                    [raceFeeds setObject:modelData forKey:[NSString stringWithFormat:@"%@_%d", feedItem.racekey, 1]];
                    [self reloadItemRace:feedItem.feed_id gender:MALE];
                }
            } ErrorHandlure:^(NSError *error) {
                
            }];
            
            API_ClosedRaceFeed *femaleRequest = [[API_ClosedRaceFeed alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] key:feedItem.racekey gender:0];
            [femaleRequest request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                JSON_ClosedRaceFeed *modelData = (JSON_ClosedRaceFeed*)jsonObject;
                [raceFeeds setObject:modelData forKey:[NSString stringWithFormat:@"%@_%d", feedItem.racekey, 0]];
                [self reloadItemRace:feedItem.feed_id gender:FEMALE];
            } ErrorHandlure:^(NSError *error) {
                
            }];
        }
}

- (void) loadMoreWithFeedId:(NSString *) feedID{
    API_Feeds *request = [[API_Feeds alloc] initWithAccessToken:[userDefaultManager getAccessToken] deviceId:[userDefaultManager getDeviceToken] feedId:feedID];
    [request request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        if(response.status) {
            [_updatesTableView.infiniteScrollingView stopAnimating];
            JSON_FeedList *modelData = (JSON_FeedList *)jsonObject;
            if (modelData.feeds.count != 0) {
                [modelData.feeds enumerateObjectsUsingBlock:^(Feed*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [_updatesTableView beginUpdates];
                    [feedList addObject:obj];
                    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:feedList.count-1 inSection:0];
                    [_updatesTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    [_updatesTableView endUpdates];
                    [self loadRaceFeed: obj];
                }];
            }
        } else {
            [AppHelper showMessageBox:nil message:response.message];
        }

    } ErrorHandlure:^(NSError *error) {
        [_updatesTableView.infiniteScrollingView stopAnimating];
    }];
}

- (void) reloadItemRace:(NSString*)feed_id gender: (GENDER) gender {
    for (UITableViewCell *cell in [_updatesTableView visibleCells]) {
        if ([cell isKindOfClass: FriendsUpdatesRaceTableViewCell.class]) {
            FriendsUpdatesRaceTableViewCell *cellFriend = (FriendsUpdatesRaceTableViewCell*) cell;
            if ([cellFriend.feed_id isEqualToString: feed_id]) {
                if (cellFriend.getCurrentRaceGender == gender) {
                    NSIndexPath* index = [_updatesTableView indexPathForCell:cellFriend];
                    [_updatesTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return feedList.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Feed *temp = (Feed*)[feedList objectAtIndex:indexPath.row];
    
    if (indexPath.row == SUGGESTED_BLOOMER_INDEX)
    {
        return [SuggestedBloomerCell cellHeight];
    }
    
    if ([temp.content_type isEqualToString:@"pic"])
    {
        if (temp.is_album)
        {
            if (temp.total_post == 2)
            {
                return [TwoPhotosCell cellHeight];
            }
            
            if (temp.total_post == 3)
            {
                return [ThreePhotosCell cellHeight];
            }
            
            if (temp.total_post == 4)
            {
                return [FourPhotosCell cellHeight];
            }
            
            if (temp.total_post == 5)
            {
                return [FivePhotosCell cellHeight];
            }
            
            return [ThreePhotosCell cellHeight];
        }
        else
        {
            return [SinglePhotoCell cellHeight];
        }
    }
    else
    {
        return [FriendsUpdatesRaceTableViewCell cellHeight];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Feed *temp = (Feed*)[feedList objectAtIndex:indexPath.row];
    
    if (indexPath.row == SUGGESTED_BLOOMER_INDEX)
    {
        return [SuggestedBloomerCell cellHeight];
    }
    
    if ([temp.content_type isEqualToString:@"pic"])
    {
        return UITableViewAutomaticDimension;
    }
    else
    {
        return FriendsUpdatesRaceTableViewCell.cellHeight;
    }
    //    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Feed *temp = (Feed *)[feedList objectAtIndex:indexPath.row];
    
    if (indexPath.row == SUGGESTED_BLOOMER_INDEX)
    {
        SuggestedBloomerCell *cell = (SuggestedBloomerCell*)[tableView dequeueReusableCellWithIdentifier:[SuggestedBloomerCell cellIdentifier]];
        
        if (!cell.isLoaded)
        {
            [cell loadSuggestedList];
            cell.isLoaded = true;
        }
        
        cell.navigationController = self.navigationController;
        
        return cell;
    }
    
    if ([temp.content_type isEqualToString:@"pic"])
    {
        if (!temp.is_album)
        {
            // Single cell
            SinglePhotoCell *cell = (SinglePhotoCell*)[tableView dequeueReusableCellWithIdentifier:[SinglePhotoCell cellIdentifier]];
            
            cell.navigationController = self.navigationController;
            cell.parentTableView = _updatesTableView;
            cell.cellIndex = indexPath;
            cell.uid = temp.profile.uid;
            cell.tabbar = self.tabbar;
            
            PostContent *post = (PostContent *)temp.posts[0];
            cell.post_id = post.post_id;
            cell.post_url = post.photo_url;
            
            if (post.mygiveflower > 0)
            {
                cell.iconGivedFlowerPhoto.hidden = false;
            }
            else
            {
                cell.iconGivedFlowerPhoto.hidden = true;
            }
            
            // init give flower area for profile
            cell.topDraggableLocation.delegate = self;
            cell.topDraggableLocation.index = indexPath;
            cell.topDraggableLocation.type = @"single";
            cell.topDraggableLocation.thankyouStyle = 4;
            [self configureDraggableLocation:cell.topDraggableLocation makeCircle:NO];
            
            [self.tabbar.draggableButton addAllowedDropLocation:cell.topDraggableLocation];
            [self.listDraggableLocationSingle addObject:cell.topDraggableLocation];
            
            // init give flower area for photo
            cell.draggableLocation.delegate = self;
            cell.draggableLocation.index = indexPath;
            cell.draggableLocation.type = @"single";
            [self configureDraggableLocation:cell.draggableLocation makeCircle:NO];
            
            [self.tabbar.draggableButton addAllowedDropLocation:cell.draggableLocation];
            [self.listDraggableLocationSingle addObject:cell.draggableLocation];
            
            [cell.photo setImageWithAnimationFromURL:[NSURL URLWithString:post.photo_url] placeHolder:[UIImage imageNamed:@"Banners_mockup.png"]];
            
            NSDate* date = [NSDate dateWithTimeIntervalSince1970:temp.timestamp/1000];
            
            [cell.avatar setImageWithURL:[NSURL URLWithString:temp.profile.avatar]];
            cell.labelUsername.text = temp.profile.username;
            cell.labelName.text = temp.profile.name;
            cell.labelTime.text = [date timeAgo];
            [cell.labelFlower setFlowers:temp.total_flower];
            
            cell.thankYouView.hidden = !(cell.draggableLocation.showThankYou);
            cell.profileThankYouView.hidden = !(cell.topDraggableLocation.showThankYou);
            
            return cell;
        }
        else
        {
            if (temp.total_post == 2)
            {
                // Three Photos cell
                TwoPhotosCell *cell = (TwoPhotosCell*)[tableView dequeueReusableCellWithIdentifier:[TwoPhotosCell cellIdentifier]];
                
                cell.navigationController = self.navigationController;
                cell.parentTableView = _updatesTableView;
                cell.cellIndex = indexPath;
                cell.uid = temp.profile.uid;
                cell.tabbar = self.tabbar;
                cell.feedPosts = [temp.posts copy];
                cell.feedID = temp.feed_id;
                
                // init give flower area for profile
                cell.topDraggableLocation.delegate = self;
                cell.topDraggableLocation.index = indexPath;
                cell.topDraggableLocation.type = @"single";
                cell.topDraggableLocation.thankyouStyle = 4;
                [self configureDraggableLocation:cell.topDraggableLocation makeCircle:NO];
                
                cell.profileThankYouView.hidden = !(cell.topDraggableLocation.showThankYou);
                
                [self.tabbar.draggableButton addAllowedDropLocation:cell.topDraggableLocation];
                [self.listDraggableLocationSingle addObject:cell.topDraggableLocation];
                
                // init give flower area for photo
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
                    PostContent *feedPic = (PostContent*)temp.posts[i];
                    
                    UIImageView *iconGivedFlowerPhoto = (UIImageView*)cell.iconGivedFlowerPhotos[i];
                    
                    if (feedPic.mygiveflower > 0)
                    {
                        iconGivedFlowerPhoto.hidden = false;
                    }
                    else
                    {
                        iconGivedFlowerPhoto.hidden = true;
                    }
                    
                    UIImageView *photo = (UIImageView*)cell.photos[i];
                    [photo setImageWithAnimationFromURL:[NSURL URLWithString:feedPic.photo_url] placeHolder:[UIImage imageNamed:@"Banners_mockup.png"]];
                }
                
                NSDate* date = [NSDate dateWithTimeIntervalSince1970:temp.timestamp/1000];
                
                [cell.avatar setImageWithURL:[NSURL URLWithString:temp.profile.avatar]];
                cell.labelUsername.text = temp.profile.username;
                cell.labelName.text = temp.profile.name;
                cell.labelTime.text = [date timeAgo];
                [cell.labelFlower setFlowers:temp.total_flower];
                
                return cell;
            }
            
            if (temp.total_post == 3)
            {
                // Three Photos cell
                ThreePhotosCell *cell = (ThreePhotosCell*)[tableView dequeueReusableCellWithIdentifier:[ThreePhotosCell cellIdentifier]];
                
                cell.navigationController = self.navigationController;
                cell.parentTableView = _updatesTableView;
                cell.cellIndex = indexPath;
                cell.uid = temp.profile.uid;
                cell.tabbar = self.tabbar;
                cell.feedPics = [temp.posts copy];
                cell.feedID = temp.feed_id;
                
                // init give flower area for profile
                cell.topDraggableLocation.delegate = self;
                cell.topDraggableLocation.index = indexPath;
                cell.topDraggableLocation.type = @"single";
                cell.topDraggableLocation.thankyouStyle = 4;
                [self configureDraggableLocation:cell.topDraggableLocation makeCircle:NO];
                
                cell.profileThankYouView.hidden = !(cell.topDraggableLocation.showThankYou);
                
                [self.tabbar.draggableButton addAllowedDropLocation:cell.topDraggableLocation];
                [self.listDraggableLocationSingle addObject:cell.topDraggableLocation];
                
                // init give flower area for photo
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
                    PostContent *feedPic = (PostContent*)temp.posts[i];
                    
                    UIImageView *iconGivedFlowerPhoto = (UIImageView*)cell.iconGivedFlowerPhotos[i];
                    
                    if (feedPic.mygiveflower > 0)
                    {
                        iconGivedFlowerPhoto.hidden = false;
                    }
                    else
                    {
                        iconGivedFlowerPhoto.hidden = true;
                    }
                    
                    UIImageView *photo = (UIImageView*)cell.photos[i];
                    [photo setImageWithAnimationFromURL:[NSURL URLWithString:feedPic.photo_url] placeHolder:[UIImage imageNamed:@"Banners_mockup.png"]];
                }
                
                NSDate* date = [NSDate dateWithTimeIntervalSince1970:temp.timestamp/1000];
                
                [cell.avatar setImageWithURL:[NSURL URLWithString:temp.profile.avatar]];
                cell.labelUsername.text = temp.profile.username;
                cell.labelName.text = temp.profile.name;
                cell.labelTime.text = [date timeAgo];
                [cell.labelFlower setFlowers:temp.total_flower];
                
                return cell;
            }
            
            if (temp.total_post == 4)
            {
                // Three Photos cell
                FourPhotosCell *cell = (FourPhotosCell*)[tableView dequeueReusableCellWithIdentifier:[FourPhotosCell cellIdentifier]];
                
                cell.navigationController = self.navigationController;
                cell.parentTableView = _updatesTableView;
                cell.cellIndex = indexPath;
                cell.uid = temp.profile.uid;
                cell.tabbar = self.tabbar;
                cell.feedPics = [temp.posts copy];
                cell.feedID = temp.feed_id;
                
                // init give flower area for profile
                cell.topDraggableLocation.delegate = self;
                cell.topDraggableLocation.index = indexPath;
                cell.topDraggableLocation.type = @"single";
                cell.topDraggableLocation.thankyouStyle = 4;
                [self configureDraggableLocation:cell.topDraggableLocation makeCircle:NO];
                
                cell.profileThankYouView.hidden = !(cell.topDraggableLocation.showThankYou);
                
                [self.tabbar.draggableButton addAllowedDropLocation:cell.topDraggableLocation];
                [self.listDraggableLocationSingle addObject:cell.topDraggableLocation];
                
                // init give flower area for photo
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
                    PostContent *feedPic = (PostContent*)temp.posts[i];
                    
                    UIImageView *iconGivedFlowerPhoto = (UIImageView*)cell.iconGivedFlowerPhotos[i];
                    
                    if (feedPic.mygiveflower > 0)
                    {
                        iconGivedFlowerPhoto.hidden = false;
                    }
                    else
                    {
                        iconGivedFlowerPhoto.hidden = true;
                    }
                    
                    UIImageView *photo = (UIImageView*)cell.photos[i];
                    [photo setImageWithAnimationFromURL:[NSURL URLWithString:feedPic.photo_url] placeHolder:[UIImage imageNamed:@"Banners_mockup.png"]];
                }
                
                NSDate* date = [NSDate dateWithTimeIntervalSince1970:temp.timestamp/1000];
                
                [cell.avatar setImageWithURL:[NSURL URLWithString:temp.profile.avatar]];
                cell.labelUsername.text = temp.profile.username;
                cell.labelName.text = temp.profile.name;
                cell.labelTime.text = [date timeAgo];
                [cell.labelFlower setFlowers:temp.total_flower];
                
                return cell;
            }
            
            if (temp.total_post == 5)
            {
                // Three Photos cell
                FivePhotosCell *cell = (FivePhotosCell*)[tableView dequeueReusableCellWithIdentifier:[FivePhotosCell cellIdentifier]];
                
                cell.navigationController = self.navigationController;
                cell.parentTableView = _updatesTableView;
                cell.cellIndex = indexPath;
                cell.uid = temp.profile.uid;
                cell.tabbar = self.tabbar;
                cell.feedPics = [temp.posts copy];
                cell.feedID = temp.feed_id;
                
                // init give flower area for profile
                cell.topDraggableLocation.delegate = self;
                cell.topDraggableLocation.index = indexPath;
                cell.topDraggableLocation.type = @"single";
                cell.topDraggableLocation.thankyouStyle = 4;
                [self configureDraggableLocation:cell.topDraggableLocation makeCircle:NO];
                
                cell.profileThankYouView.hidden = !(cell.topDraggableLocation.showThankYou);
                
                [self.tabbar.draggableButton addAllowedDropLocation:cell.topDraggableLocation];
                [self.listDraggableLocationSingle addObject:cell.topDraggableLocation];
                
                // init give flower area for photo
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
                    PostContent *feedPic = (PostContent *)temp.posts[i];
                    
                    UIImageView *iconGivedFlowerPhoto = (UIImageView*)cell.iconGivedFlowerPhotos[i];
                    
                    if (feedPic.mygiveflower > 0)
                    {
                        iconGivedFlowerPhoto.hidden = false;
                    }
                    else
                    {
                        iconGivedFlowerPhoto.hidden = true;
                    }
                    
                    UIImageView *photo = (UIImageView*)cell.photos[i];
                    [photo setImageWithAnimationFromURL:[NSURL URLWithString:feedPic.photo_url] placeHolder:[UIImage imageNamed:@"Banners_mockup.png"]];
                }
                
                NSDate* date = [NSDate dateWithTimeIntervalSince1970:temp.timestamp/1000];
                
                [cell.avatar setImageWithURL:[NSURL URLWithString:temp.profile.avatar]];
                cell.labelUsername.text = temp.profile.username;
                cell.labelName.text = temp.profile.name;
                cell.labelTime.text = [date timeAgo];
                [cell.labelFlower setFlowers:temp.total_flower];
                
                return cell;
            }
            
            return [[UITableViewCell alloc] init];
        }
    }
    else
    {
        // Race cell
        FriendsUpdatesRaceTableViewCell *cellRace = (FriendsUpdatesRaceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:FriendsUpdatesRaceTableViewCell.cellIdentifier];
        //init value for Race cell
        cellRace.lblRaceName.text = temp.racename;
        cellRace.maleRace = [raceFeeds objectForKey:[NSString stringWithFormat:@"%@_%d",temp.racekey,1]];
        cellRace.femaleRace = [raceFeeds objectForKey:[NSString stringWithFormat:@"%@_%d",temp.racekey,0]];
        cellRace.navigationController = self.navigationController;
        cellRace.feed_id = temp.feed_id;
        
        if([cellRace getCurrentRaceGender] == FEMALE)
            [cellRace reloadRaceFeedByList:cellRace.femaleRace.winnerList];
        else
            [cellRace reloadRaceFeedByList:cellRace.maleRace.winnerList];
        
        return cellRace;
    }
    
    return nil;
}


@end
