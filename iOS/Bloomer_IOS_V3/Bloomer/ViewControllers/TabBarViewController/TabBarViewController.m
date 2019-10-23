//
//  TabBarViewController.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 3/4/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "TabBarViewController.h"
#import "AppDelegate.h"
#import "NavigationViewController.h"
#define WIDTH_FLOWER 55
#define HEIGHT_FLOWER 68
@interface TabBarViewController ()
{
    MyProfileViewController *myprofileView;
    UserDefaultManager *userDefaultManager;
}

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    
    self.tabBar.translucent = false;
    
    _tabbar = [[TabBarView alloc] initWithFrame:CGRectMake(self.tabBar.bounds.size.width/2 - WIDTH_FLOWER/2, -30, WIDTH_FLOWER, HEIGHT_FLOWER)];
    [_tabbar setTabBarMode:Flower];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.tabbar = _tabbar;
    
    [self setNavigationPage];
    [self.tabBar addSubview:_tabbar];
    appDelegate.tabBarView = self;
    
    if (![[SocketManager shareInstance] IsConnected]) {
        [[SocketManager shareInstance] establishConnection];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];    
    [AppHelper handleDeeplink];
    [self.navigationController setNavigationBarHidden:TRUE];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)setNavigationPage
{
    NewsFeedViewController *newFeedVC = [[NewsFeedViewController alloc] initWithNibName:@"NewsFeedViewController" bundle:nil];
//    newFeedVC.tabbar = _tabbar;
    NavigationViewController *raceListNav = [[NavigationViewController alloc] initWithRootViewController:newFeedVC];
    
    FriendsUpdateViewController *friendsUpdateView = [[FriendsUpdateViewController alloc] initWithNibName:@"FriendsUpdateViewController" bundle:nil];
    friendsUpdateView.tabbar = _tabbar;
    NavigationViewController *friendsUpdateNav = [[NavigationViewController alloc] initWithRootViewController:friendsUpdateView];
    
    myprofileView = [[MyProfileViewController alloc] initWithNibName:@"MyProfileViewController" bundle:nil];
    myprofileView.tabbar = _tabbar;
    NavigationViewController *myprofileNav = [[NavigationViewController alloc] initWithRootViewController:myprofileView];
    
    UIViewController *view3 = [[UIViewController alloc] init];
    
    DiscoveryViewController *discoveryView = [[DiscoveryViewController alloc] initWithNibName:@"DiscoveryViewController" bundle:nil];
    discoveryView.tabbar = _tabbar;
    NavigationViewController *discoveryNav = [[NavigationViewController alloc] initWithRootViewController:discoveryView];
    
    NSMutableArray *tabViewControllers = [[NSMutableArray alloc] init];
    [tabViewControllers addObject:raceListNav];
    [tabViewControllers addObject:friendsUpdateNav];
    [tabViewControllers addObject:view3];
    [tabViewControllers addObject:discoveryNav];
    [tabViewControllers addObject:myprofileNav];
    
    [self setViewControllers:tabViewControllers];
    
    raceListNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[[UIImage imageNamed:@"Icon_Tab_Newsfeed"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:10];
    
    raceListNav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -5);
    UIImage *selectedRL = [UIImage imageNamed:@"Icon_Tab_Newsfeed_Active"];
    selectedRL = [selectedRL imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [raceListNav.tabBarItem setSelectedImage:selectedRL];
    
    myprofileNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[[UIImage imageNamed:@"Icon_Tab_Profile"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:40];
    myprofileNav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -5);
    UIImage *selectedMyprofileNav = [UIImage imageNamed:@"Icon_Tab_Profile_Active"];
    selectedMyprofileNav = [selectedMyprofileNav imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [myprofileNav.tabBarItem setSelectedImage:selectedMyprofileNav];
    
    friendsUpdateNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[[UIImage imageNamed:@"Icon_Tab_Contest"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  tag:20];
    friendsUpdateNav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -5);
    UIImage *selectedFU = [UIImage imageNamed:@"Icon_Tab_Contest_Active"];
    selectedFU = [selectedFU imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [friendsUpdateNav.tabBarItem setSelectedImage:selectedFU];
    
    view3.tabBarItem = [[UITabBarItem alloc] init];
    [view3.tabBarItem setEnabled:FALSE];
    
    discoveryNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[[UIImage imageNamed:@"Icon_Tab_Shop"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:30];
    discoveryNav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -5);
    UIImage *selectedDis = [UIImage imageNamed:@"Icon_Tab_Shop_Active"];
    selectedDis = [selectedDis imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [discoveryNav.tabBarItem setSelectedImage:selectedDis];
    
//    [self.tabBar setSelectedImageTintColor: [UIColor colorWithRed:178/255 green:34/255 blue:37/255 alpha:1.0]];
    [self.tabBar setBarTintColor:[UIColor whiteColor]];
    [self.tabBar setValue:@(YES) forKeyPath:@"_hidesShadow"];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7"))
    {
        for (UIView* view in self.view.subviews)
        {
            NSLog(@"%f - %f", view.bounds.size.width, view.bounds.size.height);
            
            if (![view isKindOfClass:[UITabBar class]])
            {
                CGRect frame = view.frame;
                frame.size.height += 49;
                view.frame = frame;
                
                break;
            }
        }
    }
    
//    [self setSelectedIndex:4];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 40) { //MyProfile TabBarItem
        [_tabbar setTabBarMode:UploadPhoto];
    }else{
        [_tabbar setTabBarMode:Flower];
    }
}

- (void) enableMeNotification:(BOOL)isEnable
{
    if(isEnable)
    {
        [self addRedDotToTabbarItem:4];
//        [myprofileView initNavigationBar];
    }
    else
    {
        for (UIView *subView in self.tabBar.subviews ) {
            if(subView.tag == 1414)
                [subView removeFromSuperview];
        }
    }
}

- (void) addRedDotToTabbarItem:(NSInteger) index{
    NSInteger itemsCount = self.tabBar.items.count;
    CGFloat halfItemWidth = CGRectGetWidth(self.tabBar.bounds) / (itemsCount * 2);
    CGFloat xOffset = halfItemWidth * (index * 2 + 1);
    CGFloat halfImageWidth = self.tabBarController.tabBar.items[index].selectedImage.size.width/2;
    UIImage *dotImg = [UIImage imageNamed:@"Dots_filled@3x"];
    CGFloat redDotSize = 6;
    UIImageView *redDotView = [[UIImageView alloc]initWithFrame:CGRectMake(xOffset + halfImageWidth + 5, 5, redDotSize, redDotSize)];
    [redDotView setImage:dotImg];
    redDotView.tag = 1414;
    [self.tabBar addSubview:redDotView];
}

- (MyProfileViewController *)getMyProfileVC {
    return myprofileView;
}

@end
