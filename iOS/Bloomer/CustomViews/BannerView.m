//
//  BannerView.m
//  Bloomer
//
//  Created by Steven on 7/16/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BannerView.h"
#import "BrowserViewController.h"

@implementation BannerView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.bannerViewImage.layer.cornerRadius = 5;
    self.bannerViewImage.clipsToBounds = true;
}

- (IBAction)touchBannerView:(id)sender
{
    if(self.deeplinkUrl.length) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.deeplinkUrl]];
    } else {
        BrowserViewController *vc = [[BrowserViewController alloc] initWithNibName:@"BrowserViewController" bundle:nil];
        [vc setUrlString:self.urlString];
        [vc setHidesBottomBarWhenPushed:YES];
        [self.parentViewController.navigationController pushViewController:vc animated:YES];
    }
}

@end
