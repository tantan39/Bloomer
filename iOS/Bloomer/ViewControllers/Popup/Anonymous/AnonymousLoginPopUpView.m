//
//  AnonymousLoginPopUpView.m
//  Bloomer
//
//  Created by Steven on 5/5/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "AnonymousLoginPopUpView.h"
#import "UIColor+Extension.h"
#import "AppHelper.h"
#import "UIView+Extension.h"

@implementation AnonymousLoginPopUpView

+ (id)createInView:(UIView*)view
{
    AnonymousLoginPopUpView *popupView = [[NSBundle mainBundle] loadNibNamed:@"AnonymousLoginPopUpView" owner:view options:nil][0];
    popupView.translatesAutoresizingMaskIntoConstraints = false;
    popupView.ownerView = view;
    
    return popupView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.mainView.layer.cornerRadius = 12;
    self.mainView.clipsToBounds = true;
    
    self.buttonSignIn.layer.cornerRadius = self.buttonSignIn.frame.size.height / 2;
    self.buttonSignIn.layer.borderColor = [UIColor colorFromHexString:@"#b0252a"].CGColor;
    self.buttonSignIn.layer.borderWidth = 1;
    self.buttonSignIn.clipsToBounds = true;
    
    self.buttonSignUp.layer.cornerRadius = self.buttonSignUp.frame.size.height / 2;
    self.buttonSignUp.clipsToBounds = true;
}

// MARK: - Actions
- (IBAction)touchBackground:(id)sender
{
    [self removeAnimate];
}

- (IBAction)touchSignUpButton:(id)sender
{
//    [[[UserDefaultManager alloc] init] setAnonymous:false];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    UINavigationController *navigationController = (UINavigationController*)UIApplication.sharedApplication.keyWindow.rootViewController;
//    [navigationController popToViewController:[navigationController viewControllers][1] animated:false];
//    SignUpViewController *viewController = [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
//    [navigationController pushViewController:viewController animated:true];
//    [self removeAnimate];
}

- (IBAction)touchSignInButton:(id)sender
{
//    [[[UserDefaultManager alloc] init] setAnonymous:false];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    UINavigationController *navigationController = (UINavigationController*)UIApplication.sharedApplication.keyWindow.rootViewController;
//    [navigationController popToViewController:[navigationController viewControllers][1] animated:false];
//    LoginViewController *viewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//    [navigationController pushViewController:viewController animated:true];
//    [self removeAnimate];
}

// MARK: - Required Functions
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
