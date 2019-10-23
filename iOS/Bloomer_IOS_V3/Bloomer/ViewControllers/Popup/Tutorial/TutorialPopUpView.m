//
//  TutorialPopUpView.m
//  Bloomer
//
//  Created by Steven on 3/29/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "TutorialPopUpView.h"
#import "AppHelper.h"
#import "UserDefaultManager.h"
#import "UIView+Extension.h"

@interface TutorialPopUpView()

@property (strong, nonatomic) UserDefaultManager *userDefaultManager;

@end

@implementation TutorialPopUpView

+ (id)createInView:(UIView*)view tutorialType:(TutorialType)tutorialType
{
    TutorialPopUpView *popupView = [[NSBundle mainBundle] loadNibNamed:@"TutorialPopUpView" owner:view options:nil][0];
    popupView.translatesAutoresizingMaskIntoConstraints = false;
    popupView.ownerView = view;
    [popupView initAnimatedImageView:tutorialType];
    
    return popupView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.userDefaultManager = [[UserDefaultManager alloc] init];    
}

- (void)initAnimatedImageView:(TutorialType)type
{
    NSString *name = @"";
    switch (type) {
        case Leaderboard:
            [self.userDefaultManager setSeenLeaderboardTut:TRUE];
            name = IS_IPHONE_X ? @"IpX_Leaderboard" : @"Leaderboard";
            break;
            
        case MyBloomer:
            [self.userDefaultManager setSeenMyBloomerTut:TRUE];
            name =  IS_IPHONE_X ? @"IpX_MyBloomer" : @"MyBloomer";
            break;
            
        case Discovery:
            [self.userDefaultManager setSeenDiscoveryTut:TRUE];
            name = IS_IPHONE_X ? @"IpX_Discovery" : @"Discovery";
            break;
            
        case OtherProfile:
            [self.userDefaultManager setSeenUserProfileTut:TRUE];
            name = IS_IPHONE_X ? @"IpX_OtherProfile" : @"OtherProfile";
            break;
    }
    

    
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_%@", name, [AppHelper getLocalizedString:@"Common.CurrentLocalized"]] ofType:@"gif"];
    
    NSData *data = [NSData dataWithContentsOfFile: path];
    FLAnimatedImage *animatedImage = [FLAnimatedImage animatedImageWithGIFData:data];
    self.animatedImageView.animatedImage = animatedImage;
    self.animatedImageView.loopCompletionBlock = ^(NSUInteger loopCountRemaining){
        [self.animatedImageView stopAnimating];
        [self removeAnimate];
    };
}

- (void)showAnimate
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (void)showWithAnimated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.ownerView addSubview:self];
        [self.ownerView addConstraints:[self getConstraintsWithParent:self.ownerView top:0 bottom:0 left:0 right:0]];
        [self.ownerView layoutIfNeeded];
        
        if (animated)
        {
            [self showAnimate];
        }
    });
}

@end
