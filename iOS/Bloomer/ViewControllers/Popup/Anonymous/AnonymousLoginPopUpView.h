//
//  AnonymousLoginPopUpView.h
//  Bloomer
//
//  Created by Steven on 5/5/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnonymousLoginPopUpView : UIView

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIButton *buttonSignIn;
@property (weak, nonatomic) IBOutlet UIButton *buttonSignUp;

@property (weak, nonatomic) UIView *ownerView;

- (IBAction)touchBackground:(id)sender;
- (IBAction)touchSignUpButton:(id)sender;
- (IBAction)touchSignInButton:(id)sender;

+ (id)createInView:(UIView*)view;
- (void)showWithAnimated:(BOOL)animated;

@end
