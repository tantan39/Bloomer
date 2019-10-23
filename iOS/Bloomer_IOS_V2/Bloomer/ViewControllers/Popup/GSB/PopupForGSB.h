//
//  PopupForGBS.h
//  Bloomer
//
//  Created by Thanh Tu Nguyen on 8/7/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIDefine.h"
#import "BlueRoundButton.h"

@interface PopupForGSB : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *popupContentView;
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property (weak, nonatomic) IBOutlet BlueRoundButton *separateOKButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *popupContentViewTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *popupContentViewBottomSpace;

@property (strong, nonatomic) NSString *gsbType;

- (void)showInView:(UIView *)aView animated:(BOOL)animated;

@end
