//
//  BrowserViewController.h
//  Bloomer
//
//  Created by Steven on 2/16/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowserViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) NSString *urlString;

@end
