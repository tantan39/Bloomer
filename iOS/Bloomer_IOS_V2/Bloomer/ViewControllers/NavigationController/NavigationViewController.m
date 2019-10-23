//
//  NavigationViewController.m
//  Bloomer
//
//  Created by Steven on 9/27/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "NavigationViewController.h"
#import "UIColor+Extension.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.delegate = self;
    self.navigationBar.barTintColor = [UIColor colorFromHexString:@"#B22225"];
    self.navigationBar.tintColor = UIColor.whiteColor;
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: UIColor.whiteColor};
    self.navigationBar.translucent = false;
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
