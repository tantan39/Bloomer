//
//  BrowserViewController.m
//  Bloomer
//
//  Created by Steven on 2/16/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BrowserViewController.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface BrowserViewController () {
}

@end

@implementation BrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:FALSE];
    
    // Do any additional setup after loading the view from its nib.
//    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;

    NSString *urlString = [self.urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoExitFullScreen)
                                                 name:UIWindowDidBecomeHiddenNotification object:self.view.window];

}

- (BOOL)prefersStatusBarHidden
{
    return FALSE;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemBecameCurrent:) name:@"AVPlayerItemBecameCurrentNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)    name:UIDeviceOrientationDidChangeNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackground) name:UIApplicationWillResignActiveNotification object:nil];

}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVPlayerItemBecameCurrentNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];

    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate {
    return true;
}

- (void)playerItemBecameCurrent:(NSNotification*)notification {
    @try {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
    }
    @catch (NSException * e) {
    }

}

- (void)orientationChanged:(NSNotification *)notification{
    @try {
        [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationNone];
    }
    @catch (NSException * e) {
    }
}

-(void) enterBackground {

    [self.webView stringByEvaluatingJavaScriptFromString:@"document.querySelector('video').pause();"];
//    [[AVAudioSession sharedInstance] setActive:NO
//                                   withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation
//                                         error:nil];
}

// MARK: - UIWebViewDelegate

- (void)videoEnterFullScreen {
    
    // Fix status bar disappeared after watching video in landscape
    @try {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    }
    @catch (NSException * e) {
    }
}

- (void)videoExitFullScreen {
    
    // Fix status bar disappeared after watching video in landscape
    @try {
        [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationNone];
    }
    @catch (NSException * e) {
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
//    NSLog(@"WebView starts loading");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (self.webView.isLoading) {
        return;
    }
//    NSLog(@"WebView finishes loading");
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    return YES;
}

@end
