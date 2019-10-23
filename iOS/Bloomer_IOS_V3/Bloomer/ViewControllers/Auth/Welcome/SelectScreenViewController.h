//
//  WelcomeViewController.h
//  Bloomer
//
//  Created by Phan Van Thanh Dat on 10/16/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "SignUpVC.h"
#import "Auth_FBRegisterParams.h"
#import "API_CheckFBExist.h"
#import "InfinitePagingScrollView.h"
#import "PageContentViewController.h"
#import "iCarousel.h"
#import "UpdateInfoFBViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelectScreenViewController : UIViewController < iCarouselDataSource, iCarouselDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *buttonSignUp;
@property (weak, nonatomic) IBOutlet UIButton *buttonSignIn;
@property (strong, nonatomic) IBOutlet UIButton *buttonLoginBF;
@property (strong, nonatomic) IBOutlet iCarousel *carousel;

@property (nonatomic,strong) NSArray *arrPageTitles;
@property (nonatomic,strong) NSArray *arrPageImages;
@property (atomic, assign) NSUInteger pageIndex;

@end

NS_ASSUME_NONNULL_END
