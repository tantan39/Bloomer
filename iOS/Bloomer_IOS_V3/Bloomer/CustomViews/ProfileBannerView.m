//
//  ProfileBannerView.m
//  Bloomer
//
//  Created by Steven on 6/8/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "ProfileBannerView.h"
#import "UIImageView+Extension.h"
#import "AppHelper.h"

@implementation ProfileBannerView

- (void)setBannerWithURLString:(NSString*)urlString croppedRectValue:(NSValue*)croppedRectValue;
{
    [[SDImageCache sharedImageCache]clearMemory];
    [[SDImageCache sharedImageCache]clearDisk];
    
    [self.bannerImageView setImageWithAnimationFromURL:[NSURL URLWithString:urlString] placeHolder:[UIImage imageNamed:@"Banners_mockup.png"]];
}

- (IBAction)touchRemoveButton:(id)sender
{
    [self.bannerImageView setImage:[UIImage imageNamed:@"Banners_mockup.png"]];
    if ([self.delegate respondsToSelector:@selector(bannerTouchRemove:)]) {
        [self.delegate bannerTouchRemove:self];
    }
}

@end
