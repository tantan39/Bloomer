//
//  ProfileBannerView.h
//  Bloomer
//
//  Created by Steven on 6/8/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class ProfileBannerView;
@protocol ProfileBannerViewDelegate <NSObject>
- (void) bannerTouchRemove:(ProfileBannerView *) banner;
@end

@interface ProfileBannerView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (copy, nonatomic) void (^touchRemoveButton)(void);
@property (weak,nonatomic) id<ProfileBannerViewDelegate> delegate;

- (void)setBannerWithURLString:(NSString*)urlString croppedRectValue:(NSValue*)croppedRectValue;

@end
