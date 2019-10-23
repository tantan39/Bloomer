//
//  OtherProfileViewController.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 5/13/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "OtherProfileViewController.h"

@interface OtherProfileViewController ()

@end

@implementation OtherProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    [view setBackgroundColor:[UIColor redColor]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 20, 20)];
    label.text = @"Abcjxbhckxjvhkx";
    [view addSubview:label];
    
    _tableView.tableHeaderView = view;
}



@end
