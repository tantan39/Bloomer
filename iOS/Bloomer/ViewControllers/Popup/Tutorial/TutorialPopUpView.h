//
//  TutorialPopUpView.h
//  Bloomer
//
//  Created by Steven on 3/29/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FLAnimatedImage.h>
#import <FLAnimatedImageView.h>
#import <Lottie/LOTAnimationView.h>
#import "Support.h"

@interface TutorialPopUpView : UIView

@property (weak, nonatomic) IBOutlet FLAnimatedImageView *animatedImageView;
//@property (weak, nonatomic) IBOutlet LOTAnimationView *animatedImageView;

@property (weak, nonatomic) UIView *ownerView;

+ (id)createInView:(UIView*)view tutorialType:(TutorialType)tutorialType;
- (void)showWithAnimated:(BOOL)animated;

@end
