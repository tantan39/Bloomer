//
//  NavigationViewController.m
//  Bloomer
//
//  Created by Steven on 9/27/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "NavigationViewController.h"
#import "UIColor+Extension.h"
#import "Support.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    self.delegate = self;
    self.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationBar.tintColor = [UIColor colorFromHexString:@"#444444"]; //B22225
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorFromHexString:@"#444444"], NSFontAttributeName: [UIFont fontWithName:NAVIGATION_TITLE_FONT_NAME size:NAVIGATION_TITLE_FONT_SIZE]};
    self.navigationBar.translucent = false;
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [[UIImage alloc] init];
}

- (void)setNavigationBarColor:(UIColor*)color {
    self.navigationBar.barTintColor = color;
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [[UIImage alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK : - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:self action:nil];
    viewController.navigationItem.backBarButtonItem = item;
}

@end
