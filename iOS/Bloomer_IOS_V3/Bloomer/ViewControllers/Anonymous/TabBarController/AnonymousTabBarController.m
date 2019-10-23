//
//  AnonymousTabBarController.m
//  Bloomer
//
//  Created by Steven on 5/4/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "AnonymousTabBarController.h"
#import "AppDelegate.h"
#import "AnonymousRaceListViewController.h"
#import "AnonymousMyBloomerViewController.h"
#import "AnonymousDiscoveryViewController.h"
#import "AppHelper.h"

@interface AnonymousTabBarController ()

@end

@implementation AnonymousTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.translucent = false;
    self.delegate = self;
    
    _tabbar = [[TabBarView alloc] initWithFrame:CGRectMake(135, -13, 50, 63)];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.tabbar = _tabbar;
    
    [_tabbar initTabbar];
//    [_tabbar setFlowerButtonWithDefaultImage];
    [self initNavigationBar];
    [self setNavigationPage];
    [self.tabBar addSubview:_tabbar];
    appDelegate.tabBarView = self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [AppHelper handleDeeplink];
}

- (void) initNavigationBar
{
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)setNavigationPage
{
    AnonymousRaceListViewController *raceListViewController = [[AnonymousRaceListViewController alloc] initWithNibName:@"AnonymousRaceListViewController" bundle:nil];
    raceListViewController.tabbar = self.tabbar;
    raceListViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Contests",) image:[UIImage imageNamed:@"Icon_Tab_Leaderboard"] tag:10];
    [raceListViewController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"Icon_Tab_Leaderboard_Active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    UINavigationController *raceListNavigationController = [[UINavigationController alloc] initWithRootViewController:raceListViewController];
    [self initNavigationBarBackground:raceListNavigationController];
    
    AnonymousMyBloomerViewController *myBloomerViewController = [[AnonymousMyBloomerViewController alloc] initWithNibName:@"AnonymousMyBloomerViewController" bundle:nil];
    myBloomerViewController.tabbar = self.tabbar;
    myBloomerViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"My Bloomers",) image:[UIImage imageNamed:@"Icon_Tab_MyBloomers"] tag:20];
    [myBloomerViewController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"Icon_Tab_MyBloomers_Active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    UINavigationController *myBloomerNavigationController = [[UINavigationController alloc] initWithRootViewController:myBloomerViewController];
    [self initNavigationBarBackground:myBloomerNavigationController];
    
    UIViewController *middleViewController = [[UIViewController alloc] init];
    middleViewController.tabBarItem = [[UITabBarItem alloc] init];
    [middleViewController.tabBarItem setEnabled:FALSE];
    
    AnonymousDiscoveryViewController *discoveryViewController = [[AnonymousDiscoveryViewController alloc] initWithNibName:@"AnonymousDiscoveryViewController" bundle:nil];
    discoveryViewController.tabbar = self.tabbar;
    discoveryViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Discovery",) image:[UIImage imageNamed:@"Icon_Tab_Discovery"] tag:30];
    [discoveryViewController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"Icon_Tab_Discovery_Active"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]];
    UINavigationController *discoveryNavigationController = [[UINavigationController alloc] initWithRootViewController:discoveryViewController];
    [self initNavigationBarBackground:discoveryNavigationController];
    
    UIViewController *lastViewController = [[UIViewController alloc] init];
    lastViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Me",) image:[UIImage imageNamed:@"Icon_Tab_Profile"] tag:30];
    [lastViewController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"Icon_Tab_Profile_Active"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]];
    
    [self setViewControllers:@[raceListNavigationController, myBloomerNavigationController, middleViewController, discoveryNavigationController, lastViewController]];
    
//    NavigationMeViewController *meView;
//    meView  = [[NavigationMeViewController alloc] initWithNibName:@"NavigationMeViewController" bundle:nil];
//    meView.tabbar = _tabbar;
//    UINavigationController *meNav = [[UINavigationController alloc] initWithRootViewController:meView];
//    [self initNavigationBarBackground:meNav];
    
//    myprofileNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Me",) image:[UIImage imageNamed:@"icon_me"] tag:40];
//    UIImage *selectedMyprofileNav = [UIImage imageNamed:@"icon_me_active@2x.png"];
//    selectedMyprofileNav = [selectedMyprofileNav imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [myprofileNav.tabBarItem setSelectedImage:selectedMyprofileNav];
    
//    meNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Me",) image:[UIImage imageNamed:@"icon_me@2x.png"] tag:40];
//    UIImage *selectedMe = [UIImage imageNamed:@"icon_me_active@2x.png"];
//    selectedMe = [selectedMe imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [meNav.tabBarItem setSelectedImage:selectedMe];
    
    
//    [self.tabbar setTintColor:[UIColor colorWithRed:178/255 green:34/255 blue:37/255 alpha:1.0]];
    [self.tabBar setSelectedImageTintColor: [UIColor colorWithRed:178/255 green:34/255 blue:37/255 alpha:1.0]];
    [self.tabBar setBarTintColor:[UIColor whiteColor]];
    [self.tabBar setValue:@(YES) forKeyPath:@"_hidesShadow"];
}

- (void)initNavigationBarBackground:(UINavigationController *)navigationBar
{
    [navigationBar.navigationBar setBackgroundImage:[UIImage imageNamed:@"Top_bar_base.png"] forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
//{
//    if ([self.tabBar.items objectAtIndex:4] == item)
//    {
//        [self setSelectedIndex:self.selectedIndex];
//        [AppHelper showAnonymousLoginPopUpView];
//    }
//}

- (BOOL) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (viewController == [tabBarController.viewControllers objectAtIndex:4])
    {
        [AppHelper showAnonymousLoginPopUpView];
        self.selectedIndex = tabBarController.selectedIndex;
        return NO;
    }
    else
    {
        return YES;
    }
}

@end
