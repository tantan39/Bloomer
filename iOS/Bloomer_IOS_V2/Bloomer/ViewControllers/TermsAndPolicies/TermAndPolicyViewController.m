//
//  TermAndPolicyViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 1/7/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "TermAndPolicyViewController.h"

@interface TermAndPolicyViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *contentWebview;

@end

@implementation TermAndPolicyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.isTerm)
    {
        [AppHelper setTitleViewForNavigationBar:self.navigationItem title:NSLocalizedString(@"Terms Of Service", nil)];
    }
    else
    {
        [AppHelper setTitleViewForNavigationBar:self.navigationItem title:NSLocalizedString(@"Privacy Policy", nil)];
    }
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Top_bar_base"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-100, 0)
                                                         forBarMetrics:UIBarMetricsDefault];
    //load webview url
//    NSString *urlString = @"http://dev.apis.bloomerapp.vn/en/privacy/";
    NSString *urlString = [self.urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_contentWebview loadRequest:urlRequest];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [AppHelper changeNavigationBarToRed: self.navigationController];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    return YES;
}

@end
