//
//  PageContentViewController.m
//  Bloomer
//
//  Created by Phan Van Thanh Dat on 10/19/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "PageContentViewController.h"

@interface PageContentViewController ()

@end

@implementation PageContentViewController

@synthesize ivScreenImage,lblScreenLabel;
@synthesize imgFile,txtTitle;

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.lblScreenLabel.font = [UIFont fontWithName:@"SFProText-Semibold" size:30];
}

- (void) setUp: (NSString*) nameImage title: (NSString*)title {
    self.ivScreenImage.image = [UIImage imageNamed:nameImage];
    self.lblScreenLabel.text = title;
}

@end
