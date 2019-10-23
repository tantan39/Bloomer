//
//  HotNewsPopUpView.h
//  Bloomer
//
//  Created by Steven on 4/11/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotNewsPopUpView : UIView

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *buttonClose;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewEqualHeightConstraint;

- (IBAction)touchCloseButton:(id)sender;

@property (weak, nonatomic) UIView *ownerView;

+ (id)createInView:(UIView*)view contentLink:(NSString*)contentLink;
- (void)showWithAnimated:(BOOL)animated;

@end
