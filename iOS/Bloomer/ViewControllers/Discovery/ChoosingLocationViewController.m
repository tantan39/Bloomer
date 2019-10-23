//
//  ChoosingLocationViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 1/27/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "ChoosingLocationViewController.h"

@interface ChoosingLocationViewController ()

@end

@implementation ChoosingLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    DiscoveryViewController *parent = (DiscoveryViewController *)_parentView;
    parent.showPopup = TRUE;
}

- (void)initNavigationBar
{
    [AppHelper setTitleViewForNavigationBar:self.navigationItem title:NSLocalizedString(@"Choosing Location", nil)];
}

@end
