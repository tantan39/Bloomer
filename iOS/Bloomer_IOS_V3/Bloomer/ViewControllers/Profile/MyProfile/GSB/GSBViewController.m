//
//  PopupForGBS.m
//  Bloomer
//
//  Created by Thanh Tu Nguyen on 8/7/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "GSBViewController.h"

@interface GSBViewController () {
    UIActivityIndicatorView *spinner;
}

@end

@implementation GSBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"MembershipViewController.membership", );
    // Setup delegates and gestures
    self.myWebView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *urlString = [[[APIDefine infoGSB] stringByAppendingString:[NSLocalizedString(@"EN",nil) lowercaseString]]
                           stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (self.gsbType != nil) {
        urlString = [NSString stringWithFormat:[APIDefine benefitsGSB],
                     self.gsbType,
                     [NSLocalizedString(@"EN",nil) lowercaseString]];
    }
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.myWebView loadRequest:urlRequest];
    
    // Setup web spinner
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    spinner.color = UIColor.redColor;
    CGRect spinnerFrame = spinner.frame;
    spinnerFrame.origin.x = self.view.frame.size.width / 2 - spinnerFrame.size.width / 2;
    spinnerFrame.origin.y = self.view.frame.size.height / 2 - spinnerFrame.size.height / 2;
    if (self.gsbType) {
        spinnerFrame.origin.y -= 50;
    }
    spinner.frame = spinnerFrame;
    [self.view addSubview:spinner];
    [spinner startAnimating];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (spinner != nil) {
        [spinner stopAnimating];
        [spinner removeFromSuperview];
    }
}

@end
