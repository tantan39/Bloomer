//
//  BannerView.h
//  Bloomer
//
//  Created by Steven on 7/16/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BannerView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *bannerViewImage;

@property (weak, nonatomic) NSString* urlString;

@property (weak, nonatomic) NSString* deeplinkUrl;

@property (weak, nonatomic) UIViewController *parentViewController;

- (IBAction)touchBannerView:(id)sender;

@end
